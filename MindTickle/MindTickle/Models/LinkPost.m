//
//  LinkPost.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 21/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "LinkPost.h"

@implementation LinkPost

- (void)loadFromDictionary:(NSDictionary *)dictionary {
    [super loadFromDictionary:dictionary];
    self.link = dictionary[@"link"];
}

@dynamic link;

@end
