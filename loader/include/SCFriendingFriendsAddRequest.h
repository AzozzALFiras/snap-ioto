@interface SCFriendingFriendAddParam
@property(nonatomic, readwrite, copy) NSString *suggestionToken;
@property(nonatomic, readwrite, assign) int source;
@end

@interface SCFriendingFriendsAddRequest
@property(nonatomic, readwrite, copy)NSString *page;
@property(nonatomic, readwrite, strong)NSMutableArray<SCFriendingFriendAddParam *> *paramsArray;
@end
