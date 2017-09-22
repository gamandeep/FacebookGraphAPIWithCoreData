//
//  PicturePost.m
//  MindTickle
//
//  Created by Gamandeep Sethi on 21/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import "PicturePost.h"

@implementation PicturePost

- (void)loadFromDictionary:(NSDictionary *)dictionary {
    [super loadFromDictionary:dictionary];
    self.picture = dictionary[@"picture"];
}

@dynamic picture;

@end
