//
//  MTDataImporter.h
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@import CoreData;

@class MTAPIManager;

@interface MTDataImporter : NSObject

+ (instancetype)sharedManager;
- (void)importPosts:(NSArray *)posts;
- (void)loadPostsWithCompletionBlock:(void (^)(NSArray *posts, NSError *error))completion;
- (void)loadProfileForUserId:(NSString *)userId completion:(void (^)(User *user, NSError *error))completion;

@end
