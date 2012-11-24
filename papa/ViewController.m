//
//  ViewController.m
//  papa
//
//  Created by Hai Lin on 10/18/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "Image.h"
#import "showPapaViewController.h"

@interface ViewController () <RKObjectLoaderDelegate,RKRequestDelegate>
@property RKObjectManager* objectManager ;
- (IBAction)testRestKit:(UIButton *)sender;

@end

@implementation ViewController

@synthesize objectManager = _objectManager;
- (void)viewDidLoad
{
    [super viewDidLoad];
       
    // init objectManager
    if(!_objectManager) {
        
        
        RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURLString:@"http://kennel.cs.columbia.edu:8821"];
        RKManagedObjectStore *objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:RKDefaultSeedDatabaseFileName];
        
        objectManager.objectStore = objectStore;
        
        
        
        
        objectManager.serializationMIMEType = RKMIMETypeJSON;
        
        RKManagedObjectMapping* imageMapping = [RKManagedObjectMapping mappingForClass:[Image class] inManagedObjectStore:objectStore];
        [imageMapping mapKeyPath:@"url" toAttribute:@"imageURL"];
        [imageMapping mapKeyPath:@"X" toAttribute:@"cordinateX"];
        [imageMapping mapKeyPath:@"Y" toAttribute:@"cordinateY"];
        [imageMapping mapKeyPath:@"time" toAttribute:@"uploadTime"];
        [imageMapping mapKeyPath:@"id" toAttribute:@"id"];
        
        
        imageMapping.primaryKeyAttribute = @"id";
        
        [objectManager.mappingProvider setMapping:imageMapping forKeyPath:@"images"];
        
        
        _objectManager = objectManager;
    }

  

    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        
    if([segue.identifier isEqualToString:@"viewPapa"])
    {
        [segue.destinationViewController  setIndex: 0];
        
    }

    
}



- (IBAction)goToView:(UIButton *)sender {
        [self performSegueWithIdentifier:@"viewPapa" sender:self];
}



- (IBAction)testRestKit:(UIButton *)sender {
    int lastindex = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastIndex"];
    NSLog(@"lastindex : %d", lastindex);

    NSString *url = [NSString stringWithFormat:@"/get_photos.py?last_view=%d&family_id=3",lastindex];


    [_objectManager loadObjectsAtResourcePath:url delegate:self ];


}


#pragma mark RKObjectLoaderDelegate


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    RKLogInfo(@"Load collection of Images: %@", objects);
    
    if(objects.count > 0) {
        Image *firstImage = objects[0];

        int lastindex = [firstImage.id intValue];
        
        [[NSUserDefaults standardUserDefaults] setInteger:lastindex forKey:@"lastIndex" ];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
    }
    
    for (Image *image in objects) {
        NSLog(@"id: %@", image.id);
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@_imagedata",docDir, image.id];
        NSLog(@"path: %@", filePath);
        image.imagePath = filePath;
        NSError *error;
        [image.managedObjectContext save:&error];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (!fileExists) {
            NSData *data =  [NSData dataWithContentsOfURL:[NSURL URLWithString: image.imageURL]];
            [data writeToFile:filePath atomically:YES];
            
        }
         
        
        //put into different thread
/*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString *filePath = [NSString stringWithFormat:@"%@/%@_imagedata",docDir, image.id];
            NSLog(@"path: %@", filePath);
            image.imagePath = filePath;
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (!fileExists) {
                NSData *data =  [NSData dataWithContentsOfURL:[NSURL URLWithString: image.imageURL]];
                [data writeToFile:filePath atomically:YES];

            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
            });
        });
      
        */
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
    NSLog(@"log : %@",msg);
}
@end
