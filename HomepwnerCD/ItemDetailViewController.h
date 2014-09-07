//
//  ItemDetailViewController.h
//  Homepwner
//
//  Created by Luis Carbuccia on 8/23/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface ItemDetailViewController : UIViewController

@property (nonatomic, strong) Item *item;
@property (nonatomic) BOOL isAddingItem; 
@end
