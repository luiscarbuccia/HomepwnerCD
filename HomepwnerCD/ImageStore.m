//
//  ImageStore.m
//  Homepwner
//
//  Created by Luis Carbuccia on 8/23/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation ImageStore

#pragma mark - Initializers

+(instancetype)sharedStore
{
    static ImageStore *sharedStore = nil;
    
//    if (!sharedStore)
//    {
//        sharedStore = [[self alloc] initPrivate];
//    }

    // multi-thread safe singleton
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedStore = [[self alloc] initPrivate];});
    
    return sharedStore;
}

// no one should call init
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ImageStore sharedstore]"
                                 userInfo:nil];
    return nil;
}

// designated initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self)
        _dictionary = [[NSMutableDictionary alloc] init];
    
    // register ImageStore as an observer with notification center for low memory warnings
    // when a low-memory warning is posted, the notification center will send the message clearCache:
    // to ImageStore instance
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(clearCache:)
               name:UIApplicationDidReceiveMemoryWarningNotification
             object:nil];
    
    return self;
}

#pragma mark - Methods

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
//    [self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image;

    // create a full path for image
    NSString *imagePath = [self imagePathForKey:key];
    
    // turn image into jpeg data
    NSData *data = UIImageJPEGRepresentation(image, .8);
    
    //write image to full path
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    // if possible, get picture from the dictionary
    UIImage *result = self.dictionary[key];
    
    if(!result)
    {
        NSString *imagePath = [self imagePathForKey:key];
        
        // create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        // if there is an image on the file system, place it into cache
        if (result)
        {
            self.dictionary[key] = result;
        }
        else
        {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key)
        return;
    
    [self.dictionary removeObjectForKey:key];
    
    // when an image is deleted from store, it is also deleted from file system
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

#pragma mark - Archiving

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingString:key];
}

#pragma mark - Memory

- (void) clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects]; 
}

@end
