//
//  Post.h
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "BaseModelObject.h"

@interface Post : BaseModelObject

+ (NSFetchRequest<Post *> *)fetchRequest;

@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

- (void)loadFromDictionary:(NSDictionary *)dictionary;
+ (Post *)findOrCreatePostWithId:(NSString *)postId inContext:(NSManagedObjectContext *)context;

@end
