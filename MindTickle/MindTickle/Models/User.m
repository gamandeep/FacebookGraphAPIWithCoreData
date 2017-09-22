//
//  User.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSFetchRequest<User *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

- (void)loadFromDictionary:(NSDictionary *)dictionary {
    self.userId = dictionary[@"id"];
    self.birthday = dictionary[@"birthday"];
    self.gender = dictionary[@"gender"];
    self.name = dictionary[@"name"];
    self.firstName = dictionary[@"first_name"];
    self.picture = dictionary[@"picture"][@"data"][@"url"];
    self.cover = dictionary[@"cover"][@"source"];
}

+ (User *)findOrCreateUserWithId:(NSString *)userId inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    if (result.lastObject) {
        return result.lastObject;
    } else {
        User *user = [self insertNewObjectIntoContext:context];
        user.userId = userId;
        return user;
    }
}

@dynamic userId;
@dynamic birthday;
@dynamic gender;
@dynamic name;
@dynamic firstName;
@dynamic picture;
@dynamic cover;

@end
