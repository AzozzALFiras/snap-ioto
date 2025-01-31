@import Foundation;

#include <dlfcn.h>
#include <stddef.h>
#include <objc/runtime.h>

typedef void (*relic_hook)(Class cls, SEL sel, void * replacement);
typedef void (*relic_hookex)(Class cls, SEL sel, void *replacement, void* original);
typedef void (*relic_hookclassex)(Class cls, SEL sel, void * replacement, void * original);
typedef void (*relic_unhook)(Class cls, SEL sel);

static void *handle = NULL;

static relic_unhook $RelicUnhookMessageEx;
static relic_hookex $RelicHookMessageEx;
static relic_hookclassex $RelicHookClassMessageEx;
static relic_hook $RelicHookMessage;
static void * load(const char *name) {
  void *func = dlsym(handle, name);
  if (!func) {
    NSLog(@"Unable to load function %s! Error: %s", name, dlerror());
  }
  return func;
}

static void relic_init() {
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
      handle = dlopen("/usr/lib/null.dylib", RTLD_NOW);
      if (handle) {
          $RelicHookMessage = (relic_hook)load("RelicHookMessage");
          $RelicHookMessageEx = (relic_hookex)load("RelicHookMessageEx");
          $RelicHookClassMessageEx = (relic_hookclassex)load("RelicHookClassMessageEx");
          $RelicUnhookMessageEx = (relic_unhook)load("RelicUnhookMessageEx");
      } else {
        NSLog(@"Unable to load! Error: %s", dlerror());
      }
  });
}

void RelicHookMessageEx(Class cls, SEL sel, void * replacement, void * original) {
  relic_init();
  if($RelicHookMessageEx) {
    $RelicHookMessageEx(cls, sel, replacement, original);
  }
}

void RelicHookClassMessageEx(Class cls, SEL sel, void * replacement, void * original) {
  relic_init();
  if($RelicHookClassMessageEx) {
    $RelicHookClassMessageEx(cls, sel, replacement, original);
  }
}

void RelicHookMessage(Class cls, SEL sel, void * replacement) {
  relic_init();
  if($RelicHookMessage) {
    $RelicHookMessage(cls, sel, replacement);
  }
}

void RelicUnhookMessageEx(Class cls, SEL sel) {
  relic_init();
  if($RelicUnhookMessageEx) {
    $RelicUnhookMessageEx(cls, sel);
  }
}
