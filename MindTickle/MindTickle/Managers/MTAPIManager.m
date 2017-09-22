//
//  MTAPIManager.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "MTAPIManager.h"
#import "MTDataImporter.h"
#import "TextPost.h"
#import "LinkPost.h"
#import "PicturePost.h"
#import "AppDelegate.h"
#import "MTCommons.h"

NSString *const MTAPIBaseURLString = @"https://graph.facebook.com/v2.10/";
NSString *const MTAPIAccessToken = @"EAACEdEose0cBAPFRJsEZC8CHc3veFk7VuOTQMXg8Pfj7eub9y0XZCaeIWY24l3U3gcBM8nB0S2iV7XeZBOZC0r3HfXTEIhmfpVBXBQXG9ZApAGNbStZBsnyCAghHXcU5X6ztVxW0w6B8EW4TQ6gyx2cVplQSTHewIvRCMAIvmbToXfwOsy3ZBDX08OMPCc1whYDlbHx2ZAN2sgZDZD";

//For steps to generate the above access-token, go to this link : https://docs.google.com/document/d/1xu9PYWXepJ7Hq61HQbm-QDAJn0P3ixyuFliCyVqz7z0/edit?usp=sharing

@interface MTAPIManager()

@property (nonatomic, strong) NSString *previousURLString;
@property (nonatomic, strong) NSString *nextURLString;

@end


@implementation MTAPIManager

+ (instancetype)sharedManager {
    static MTAPIManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[MTAPIManager alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:MTAPIBaseURLString]];
    [self fetchAndSaveUserIdForMeProfile];
    return self;
}

- (void)loadPostsWithCompletionBlock:(void (^)(NSArray *posts, NSError *error))completion {
    NSString *restOfTheURLString = [NSString stringWithFormat:@"me/feed?fields=picture,from,message,created_time,link,type,to&access_token=%@", MTAPIAccessToken];
    if (self.nextURLString.length) {
        restOfTheURLString = [self.nextURLString stringByReplacingOccurrencesOfString:MTAPIBaseURLString withString:@""];
    }
    [self GET:restOfTheURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (!self.nextURLString.length) {
                [[MTDataImporter sharedManager] importPosts:[responseObject objectForKey:@"data"]];
            }
            self.previousURLString = [responseObject valueForKeyPath:@"paging.previous"];
            self.nextURLString = [responseObject valueForKeyPath:@"paging.next"];
            NSMutableArray *localArray = [[NSMutableArray alloc] init];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            for(NSDictionary *postDict in [responseObject objectForKey:@"data"]) {
                NSString *type = postDict[@"type"];
                Post *post;
                if ([type isEqualToString:@"status"]) {
                    post = [[TextPost alloc] initWithEntity:[NSEntityDescription entityForName:[TextPost entityName] inManagedObjectContext:delegate.persistentContainer.viewContext] insertIntoManagedObjectContext:nil];
                }
                else if ([type isEqualToString:@"photo"]) {
                    post = [[PicturePost alloc] initWithEntity:[NSEntityDescription entityForName:[PicturePost entityName] inManagedObjectContext:delegate.persistentContainer.viewContext] insertIntoManagedObjectContext:nil];                }
                else if ([type isEqualToString:@"link"]) {
                    post = [[LinkPost alloc] initWithEntity:[NSEntityDescription entityForName:[LinkPost entityName] inManagedObjectContext:delegate.persistentContainer.viewContext] insertIntoManagedObjectContext:nil];
                }
                if (post) {
                    [post loadFromDictionary:postDict];
                    [localArray addObject:post];
                }
                
            }
            completion(localArray, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion([NSArray array], error);
    }];
}

- (void)loadProfileForUserId:(NSString *)userId completion:(void (^)(NSDictionary *userDict, NSError *error))completion {
    NSString *restOfTheURLString = [NSString stringWithFormat:@"%@?fields=id,about,birthday,cover,email,gender,hometown,location,name,first_name,verified,is_verified,picture.type(large)&access_token=%@",userId, MTAPIAccessToken];
    [self GET:restOfTheURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            completion(responseObject, nil);
        }
        else {
            completion([NSDictionary dictionary], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion([NSDictionary dictionary], error);
    }];
}

- (void)fetchAndSaveUserIdForMeProfile {
    NSString *restOfTheURLString = [NSString stringWithFormat:@"me?fields=id&access_token=%@", MTAPIAccessToken];
    [self GET:restOfTheURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [prefs setObject:responseObject[@"id"] forKey:kPrefsUserIDKey];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
