//
//  Item+AddOn.m
//  HomepwnerCD
//
//  Created by Luis Carbuccia on 9/7/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "Item+AddOn.h"

@implementation Item (AddOn)

- (void)itemKey
{
    // create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.key = key;
}

- (void)dateCreated
{
    self.dateOfCreation = [NSDate date]; 
}

- (NSString *) description
{
    // returns description of item
    return [NSString stringWithFormat:@"%@ (%@): Worth $ %@", self.name, self.serialNumber, self.value];
}



@end
