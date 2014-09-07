//
//  AddItemViewController.m
//  Homepwner
//
//  Created by Luis Carbuccia on 8/25/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "AddItemViewController.h"
#import "ImageStore.h"
#import "ItemStore.h"
#import "Item+AddOn.h"
#import "CoreDataStack.h"


@interface AddItemViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *serialTextField;
@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIPopoverController *imagePickerPopOver;

@property (strong, nonatomic) NSDate *date;

@end

@implementation AddItemViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewForOrientation:io];
    
    // save button should be disabled when view first appears since fields will be empty
    self.doneButton.enabled = NO;
    
    // make sure text fields respond to delegate methods
    self.itemNameTextField.delegate = self;
    self.serialTextField.delegate = self;
    self.valueTextField.delegate = self;
    
    // create a date of creation
    self.date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:self.date];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

#pragma mark - IBAction Methods

- (IBAction)cancelButtonPressed:(id)sender
{
    if (self.item)
        [[ItemStore sharedStore] removeItem:self.item];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([self.itemNameTextField.text length] > 0 && [self.serialTextField.text length] > 0 && [self.valueTextField.text length] > 0)
    {
        CoreDataStack *cds = [CoreDataStack defaultStack];
        Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                   inManagedObjectContext:cds.managedObjectContext];

        item.name = self.itemNameTextField.text;
        item.value = [NSNumber numberWithInt:[self.valueTextField.text intValue]];
        item.serialNumber = self.serialTextField.text;
        [item itemKey];
        [item dateCreated];

//        [[ItemStore sharedStore] addItem:self.item];
    
        self.doneButton.enabled = YES;
    }
    
    return YES;
}

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
