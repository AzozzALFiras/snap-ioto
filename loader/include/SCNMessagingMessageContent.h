@interface SCNMessagingMessageContent : NSObject

- (id)initWithContent:(id)arg1  contentType:(NSInteger)arg2  remoteMediaInfo:(id)arg3  remoteMediaReferences:(id)arg4  localMediaReferences:(id)arg5  thumbnailIndexLists:(id)arg6  quotedMessage:(id)arg7  snapDisplayInfo:(id)arg8  
messageTypeMetadata:(id)arg9;
-(NSData *)content;
-(NSInteger)contentType;
@end
