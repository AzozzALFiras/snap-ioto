#import "SCChatInputAudioNoteController.h"
@interface AudioPickerController : NSObject <UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  SCChatInputAudioNoteController *_controller;
}

-(instancetype)initWithController: (SCChatInputAudioNoteController *)controller;

@end
