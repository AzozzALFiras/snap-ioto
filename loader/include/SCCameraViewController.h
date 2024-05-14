@interface SCCameraViewController : UIViewController
-(BOOL)isInReplyingMode;
-(void)presentPreviewForVideoFuture:(id)arg1 videoCaptureConfiguration:(id)arg2 managedCapturerState:(id)arg3;
-(void)presentPreviewForImageFuture:(id)arg1 async:(BOOL)arg2 imageCaptureConfiguration:(id)arg3 managedCapturerState:(id)arg4;
@end
