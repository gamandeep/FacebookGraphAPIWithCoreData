//
//  Post.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "Post.h"

@implementation Post

+ (NSFetchRequest<Post *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"Post"];
}

- (void)loadFromDictionary:(NSDictionary *)dictionary {
    self.postId = dictionary[@"id"];
    self.type = dictionary[@"type"];
    self.createdTime = [dictionary[@"created_time"] substringToIndex:([dictionary[@"created_time"] length] - 5)];
    self.userName = dictionary[@"from"][@"name"];
    self.userId = dictionary[@"from"][@"id"];
}

+ (Post *)findOrCreatePostWithId:(NSString *)postId inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"postId = %@", postId];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    if (result.lastObject) {
        return result.lastObject;
    } else {
        Post *post = [self insertNewObjectIntoContext:context];
        post.postId = postId;
        return post;
    }
}

@dynamic postId;
@dynamic type;
@dynamic createdTime;
@dynamic userName;
@dynamic userId;

@end
