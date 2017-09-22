//
//  TextPost.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 21/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "TextPost.h"

@implementation TextPost

- (void)loadFromDictionary:(NSDictionary *)dictionary {
    [super loadFromDictionary:dictionary];
    self.message = dictionary[@"message"];
}

@dynamic message;

@end
