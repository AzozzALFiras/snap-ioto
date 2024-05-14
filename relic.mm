@import Foundation;
#import <substrate.h>
#import <objc/runtime.h>


#ifndef IPA
#include <pthread.h>
#include "hashmap.h"

static void performBlockOnProperThread(void (^block)(void)) {
  if (pthread_main_np()) {
    block();
  } else {
    dispatch_async(dispatch_get_main_queue(), block);
  }
}

// The original objc_msgSend.
static id (*orig_objc_msgSend)(id, SEL, ...) = NULL;

// HashMap functions.
static int pointerEquality(void *a, void *b) {
  uintptr_t ia = reinterpret_cast<uintptr_t>(a);
  uintptr_t ib = reinterpret_cast<uintptr_t>(b);
  return ia == ib;
}

// 64 bit hash from https://gist.github.com/badboy/6267743.
static inline NSUInteger pointerHash(void *v) {
  uintptr_t key = reinterpret_cast<uintptr_t>(v);
  key = (~key) + (key << 21); // key = (key << 21) - key - 1;
  key = key ^ (key >> 24);
  key = (key + (key << 3)) + (key << 8); // key * 265
  key = key ^ (key >> 14);
  key = (key + (key << 2)) + (key << 4); // key * 21
  key = key ^ (key >> 28);
  key = key + (key << 31);
  return key;
}

static HashMapRef hookMap;

static inline void * getHook(id self, SEL _cmd) {
    //lots of null checks for safety
    if(!self || !_cmd) return NULL;
    Class metaclass = object_getClass(self);
    if(!metaclass) return NULL;
    HashMapRef classmap;
    if(class_isMetaClass(metaclass)){
        classmap = (HashMapRef)HMGet(hookMap, (__bridge void *)self);
    }else{
        classmap = (HashMapRef)HMGet(hookMap, (__bridge void *)metaclass);
    }
    if(!classmap) return NULL;
    return (void *)HMGet(classmap, _cmd);
}

static inline void addHook(HashMapRef map, id obj_or_class, SEL _cmd, void * callback) {//mapAddSelector
    if(!obj_or_class || !_cmd || !callback) return;
  HashMapRef selectorSet = (HashMapRef)HMGet(map, (__bridge void *)obj_or_class);
  if (selectorSet == NULL) {
    selectorSet = HMCreate(&pointerEquality, &pointerHash);
    HMPut(map, (__bridge void *)obj_or_class, selectorSet);
  }

  HMPut(selectorSet, _cmd, callback);
}

static inline void destroyHook(HashMapRef map, id obj_or_class, SEL _cmd) { //mapDestroySelector
    if(!obj_or_class || !_cmd) return;
    HashMapRef selectorSet = (HashMapRef)HMGet(map, (__bridge void *)obj_or_class);
    if (selectorSet == NULL) {
        HMRemove(map, (__bridge void*)obj_or_class);
    }else{
      HMRemove(selectorSet, _cmd);
    }
}
extern "C" void RelicUnhookMessageEx(Class cls, SEL sel){
    performBlockOnProperThread(^(){
        destroyHook(hookMap, cls, sel);
    });
}

extern "C" void * RelicGetOriginal(){
    return (void *)orig_objc_msgSend;
}
    
// arm64(e) witchcraft

struct OrigAndReturn {
  uintptr_t orig;
  uintptr_t ret;
};

struct OrigAndReturn hookmanager(id self, SEL _cmd, uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5, uint64_t arg6, uint64_t arg7, ...) asm("hookman");

typedef id (*relic_callback)(id self, SEL _cmd, uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5, uint64_t arg6, uint64_t arg7, uint64_t arg8, uint64_t arg9, uint64_t arg10);

struct OrigAndReturn hookmanager(id self, SEL _cmd, uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5, uint64_t arg6, uint64_t arg7, ...) {
    void * hook = getHook(self,_cmd);
    if(hook){
        relic_callback replacement = (relic_callback)hook;
        
        va_list args;
        va_start(args, arg7);
        for(int x = 0; x < 208 / sizeof(uint64_t); x++){
            va_arg(args,uint64_t);
        }
        uint64_t arg8 = va_arg(args,uint64_t);
        uint64_t arg9 = va_arg(args,uint64_t);
        uint64_t arg10 = va_arg(args,uint64_t);
        //rinse and repeat for more args...
        //i call this technique "retard stack surfing"
        va_end(args);
        
        
        return (struct OrigAndReturn) {0, (uintptr_t)replacement(self, _cmd, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)};
    }
    return (struct OrigAndReturn) {reinterpret_cast<uintptr_t>(orig_objc_msgSend), 0}; //execute, keep ret //reinterpret_cast<uintptr_t>(*orig_objc_msgSend) for 0 # 1
}
__attribute__((__naked__)) static void replacementObjc_msgSend() {
  __asm__ volatile (
                    "stp q6, q7, [sp, #-32]!\n"
                    "stp q4, q5, [sp, #-32]!\n"
                    "stp q2, q3, [sp, #-32]!\n"
                    "stp q0, q1, [sp, #-32]!\n"
                    "stp x8, lr, [sp, #-16]!\n"
                    "stp x6, x7, [sp, #-16]!\n"
                    "stp x4, x5, [sp, #-16]!\n"
                    "stp x2, x3, [sp, #-16]!\n"
                    "stp x0, x1, [sp, #-16]!\n"
                    "bl hookman\n"
                    "bic x9, x0, #0xFFFFFF8000000000\n"
                    "mov x10, x1\n"
                    "ldp x0, x1, [sp], #16\n"
                    "ldp x2, x3, [sp], #16\n"
                    "ldp x4, x5, [sp], #16\n"
                    "ldp x6, x7, [sp], #16\n"
                    "ldp x8, lr, [sp], #16\n"
                    "ldp q0, q1, [sp], #32\n"
                    "ldp q2, q3, [sp], #32\n"
                    "ldp q4, q5, [sp], #32\n"
                    "ldp q6, q7, [sp], #32\n"
                    "cbz x9, Lnocall\n"
                    "br x9\n"
                    "Lnocall:\n"
                    "mov x0, x10\n"
                    "ret\n"
    );
}
#endif

// API
extern "C" void RelicHookMessage(Class cls, SEL sel, void * replacement){
    #ifdef IPA
      class_addMethod(cls, sel,(IMP)replacement, "v@:");
    #else
      performBlockOnProperThread(^(){
          addHook(hookMap, cls, sel, replacement);
      });
    #endif
}
extern "C" void RelicHookMessageEx(Class cls, SEL sel, void * replacement, void *original){
    #ifdef IPA
      MSHookMessageEx(cls, sel, (IMP)replacement, (IMP *)original);
    #else
      RelicHookMessage(cls,sel,(void *)replacement);
      *(IMP *)original = class_getMethodImplementation(cls, sel);
    #endif
}

extern "C" void RelicHookClassMessageEx(Class cls, SEL sel, void * replacement, void * original){
    Class clss = object_getClass(cls);
    #ifdef IPA
      MSHookMessageEx(clss, sel, (IMP)replacement, (IMP *)original);
    #else
      RelicHookMessage(cls,sel,replacement);
      *(IMP *) original = class_getMethodImplementation(clss, sel);
    #endif
}

__attribute__((constructor)) static void inject() {
    #ifndef IPA
      hookMap = HMCreate(&pointerEquality, &pointerHash);
      MSHookFunction((void*)&objc_msgSend, (void *)&replacementObjc_msgSend, (void **)&orig_objc_msgSend);
    #endif
}
