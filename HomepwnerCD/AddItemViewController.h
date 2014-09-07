//
//  AddItemViewController.h
//  Homepwner
//
//  Created by Luis Carbuccia on 8/25/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface AddItemViewController : UIViewController

@property (nonatomic, strong) Item *item;
@property (nonatomic) UIModalPresentationStyle modalPresentationStyle;

@end
