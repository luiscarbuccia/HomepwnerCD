//
//  ImageViewController.m
//  Homepwner
//
//  Created by Luis Carbuccia on 8/30/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

#pragma  mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.view = imageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    // when an instance of ImageViewController is created, it will be given an image.
    [super viewWillAppear:animated];
    
    // cast the view to UIImageView so the compiler knows it is ok to send it setImage
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image; 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
