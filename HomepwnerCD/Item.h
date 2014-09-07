//
//  Item.h
//  HomepwnerCD
//
//  Created by Luis Carbuccia on 9/7/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSDate * dateOfCreation;
@property (nonatomic, retain) NSString * key;

@end
