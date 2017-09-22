//
//  User.h
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "BaseModelObject.h"

@interface User : BaseModelObject

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *cover;

- (void)loadFromDictionary:(NSDictionary *)dictionary;
+ (User *)findOrCreateUserWithId:(NSString *)userId inContext:(NSManagedObjectContext *)context;

@end
