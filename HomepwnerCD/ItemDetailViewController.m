//
//  ItemDetailViewController.m
//  Homepwner
//
//  Created by Luis Carbuccia on 8/23/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ImageStore.h"

@interface ItemDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *serialLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIPopoverController *imagePickerPopOver;

@end

@implementation ItemDetailViewController

#pragma mark- Init Methods


#pragma mark - View...

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.

    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewForOrientation:io];

    // make sure text fields respond to delegate methods
//    self.nameTextField.delegate = self;
//    self.serialTextField.delegate = self;
//    self.valueTextField.delegate = self;
    
    self.nameLabel.text = self.item.name;
    self.serialLabel.text = self.item.serialNumber;
    self.valueLabel.text = [NSString stringWithFormat:@"$%@", self.item.value];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    self.dateLabel.text = [formatter stringFromDate:self.item.dateOfCreation];
    
    // get image for corresponding key from the image store
    NSString *imageKey = self.item.key;
    UIImage *imageToDisplay = [[ImageStore sharedStore] imageForKey:imageKey];
    
    // use that image to put on the in the imageView
    self.imageView.image = imageToDisplay;
}

#pragma mark - Device Orientation Methods

- (void)prepareViewForOrientation:(UIInterfaceOrientation)orientation
{
    // if it's an iPad, there's no prep necessary
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return;
    }
    
    // if the device is in landscape orientation, and it isn't an iPad
    // disable the camera button and hide the image view
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    }
    else
    {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self prepareViewForOrientation:toInterfaceOrientation];
}

#pragma mark - IBAction Methods


- (IBAction)cameraButtonPressed:(id)sender
{
    if ([self.imagePickerPopOver isPopoverVisible])
    {
        // if the popover is already set up, get rid of it
        [self.imagePickerPopOver dismissPopoverAnimated:YES];
        self.imagePickerPopOver = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // if the device has a camera, take a picture. Otherwise, just from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    // place image picker on the screen
    // check for iPad before instantiating popOver controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        // create popover controller to display imagePicker
        self.imagePickerPopOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        self.imagePickerPopOver.delegate = self;
        
        // display the popover controller; sender is the camera bar button item
        [self.imagePickerPopOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from infor dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // store the image in the ImageStore for this key
    [[ImageStore sharedStore] setImage:image forKey:self.item.key];
    
    // put that image onto the screen in our image view
    self.imageView.image = image;
    
    // Take image picker off the screen
    // is there a popover?
    if (self.imagePickerPopOver)
    {
        // dismiss popover
        [self.imagePickerPopOver dismissPopoverAnimated:YES];
        
        //when dismissPopoverAnimated is explicitly sent, it doesn't send popoverControllerDidDismissPopover: to delegae, so imagePickerPopover must be set to nil.
        self.imagePickerPopOver = nil;
    }
    else
    {
        // dismiss modal image picker
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
