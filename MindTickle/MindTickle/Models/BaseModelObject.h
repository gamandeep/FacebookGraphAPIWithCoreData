//
//  BaseModelObject.h
//  MindTickle
//
//  Created by Gamandeep Sethi on 19/09/17.
//  Copyright © 2017 Gamandeep Sethi. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface BaseModelObject : NSManagedObject

+ (id)entityName;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext*)context;

@end
