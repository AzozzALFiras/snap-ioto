@interface SCNMessagingMessageDescriptor : NSObject
-(NSInteger)messageId;
-(SCNMessagingUUID *)conversationId;
-(id)initWithConversationId:(SCNMessagingUUID *)arg1 messageId:(NSInteger)arg2;
@end
