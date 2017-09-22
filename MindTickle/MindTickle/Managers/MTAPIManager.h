//
//  MTAPIManager.h
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "User.h"

@interface MTAPIManager : AFHTTPSessionManager

+ (instancetype)sharedManager;
- (void)loadPostsWithCompletionBlock:(void (^)(NSArray *posts, NSError *error))completion;
- (void)loadProfileForUserId:(NSString *)userId completion:(void (^)(NSDictionary *userDict, NSError *error))completion;

@end
