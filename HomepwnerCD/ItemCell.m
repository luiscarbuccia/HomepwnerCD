//
//  ItemCell.m
//  Homepwner
//
//  Created by Luis Carbuccia on 8/29/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions

- (IBAction)thumbnailButtonPressed:(UIButton *)sender
{
    if (self.actionBlock)
        self.actionBlock();
}

@end
