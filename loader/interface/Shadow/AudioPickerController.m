@import Foundation;
@import UIKit;
@import AVFoundation;
#import "AudioPickerController.h"
@implementation AudioPickerController
-(instancetype)initWithController: (SCChatInputAudioNoteController *)controller{
  self = [super init];
  if (self){
    _controller = controller;
  }
  return self;

}
- (void)documentPicker:(UIDocumentPickerViewController *)controller 
didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
  if ([urls count] > 0){
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:urls[0] options:nil];
    CMTime audioDuration = audioAsset.duration;
    CGFloat audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    NSData *data = [NSData dataWithContentsOfURL: urls[0]];
    [_controller _sendAudioNoteWithData:data duration:audioDurationSeconds];
  }

}
- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
  NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
  if (videoUrl){
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset
                                                          presetName: AVAssetExportPresetPassthrough];

    NSURL* docsurl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *outputURL = [docsurl URLByAppendingPathComponent:@"upload_note.m4a"];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeAppleM4A; //For audio file
    exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);

    CGFloat audioDurationSeconds = CMTimeGetSeconds([asset duration]);

    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
      NSData *data = [NSData dataWithContentsOfURL: outputURL];
      [_controller _sendAudioNoteWithData:data duration: audioDurationSeconds];
    }];
  }

  [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
