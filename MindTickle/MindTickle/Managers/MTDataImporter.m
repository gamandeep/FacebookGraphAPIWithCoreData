//
//  MTDataImporter.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "MTDataImporter.h"
#import "LinkPost.h"
#import "TextPost.h"
#import "PicturePost.h"
#import "AppDelegate.h"
#import "MTAPIManager.h"

@interface MTDataImporter ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation MTDataImporter

+ (instancetype)sharedManager {
    static MTDataImporter *_sharedImporter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _sharedImporter = [[MTDataImporter alloc] initWithContext:delegate.persistentContainer.newBackgroundContext];
    });
    return _sharedImporter;
}

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        self.context = context;
        [self registerForSaveNotification];
    }
    return self;
}

- (void)registerForSaveNotification {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSManagedObjectContextDidSaveNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification* note) {
         NSManagedObjectContext *moc = delegate.persistentContainer.viewContext;
         if (note.object != moc) {
             [moc performBlock:^(){
                 [moc mergeChangesFromContextDidSaveNotification:note];
             }];
         }
     }];
}

- (void)importPosts:(NSArray *)posts {
    for(NSDictionary *postDict in posts) {
        NSString *identifier = postDict[@"id"];
        NSString *type = postDict[@"type"];
        if ([type isEqualToString:@"status"]) {
            TextPost *post = (TextPost *)[TextPost findOrCreatePostWithId:identifier inContext:self.context];
            [post loadFromDictionary:postDict];
        }
        else if ([type isEqualToString:@"photo"]) {
            PicturePost *post = (PicturePost *)[PicturePost findOrCreatePostWithId:identifier inContext:self.context];
            [post loadFromDictionary:postDict];
        }
        else if ([type isEqualToString:@"link"]) {
            LinkPost *post = (LinkPost *)[LinkPost findOrCreatePostWithId:identifier inContext:self.context];
            [post loadFromDictionary:postDict];
        }
        
    }
    [self saveContext];
}

- (void)loadPostsWithCompletionBlock:(void (^)(NSArray *posts, NSError *error))completion {
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:[TextPost entityName]];
  
    NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:[PicturePost entityName]];

    NSFetchRequest *request3 = [NSFetchRequest fetchRequestWithEntityName:[LinkPost entityName]];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    NSArray *textPosts = [delegate.persistentContainer.viewContext executeFetchRequest:request1 error:&error];
    NSArray *picturePosts = [delegate.persistentContainer.viewContext executeFetchRequest:request2 error:&error];
    NSArray *linkPosts = [delegate.persistentContainer.viewContext executeFetchRequest:request3 error:&error];

    NSMutableArray *posts = [[NSMutableArray alloc] init];
    [posts addObjectsFromArray:textPosts];
    [posts addObjectsFromArray:picturePosts];
    [posts addObjectsFromArray:linkPosts];

    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:NO]];
    [posts sortUsingDescriptors:sortDescriptors];
    
    completion(posts, error);
}

- (void)loadProfileForUserId:(NSString *)userId completion:(void (^)(User *user, NSError *error))completion {
    User *user = [User findOrCreateUserWithId:userId inContext:self.context];
    if (user.name.length) {
        completion(user, nil);
    }
    else {
        [[MTAPIManager sharedManager] loadProfileForUserId:userId completion:^(NSDictionary *userDict, NSError *error) {
            if(userDict && !error) {
                [user loadFromDictionary:userDict];
                completion(user, nil);
                [self saveContext];
            }
            else {
                completion(nil, error);
            }
        }];
    }
}

- (void)saveContext {
    [self.context performBlock:^{
        NSError *error = nil;
        [self.context save:&error];
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

@end
