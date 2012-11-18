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

@interface ViewController () <RKObjectLoaderDelegate,RKRequestDelegate>
@property NSDictionary *imageRowData;
- (IBAction)testRestKit:(UIButton *)sender;
- (IBAction)fetchData:(UIButton *)sender;

@end

@implementation ViewController

@synthesize imageRowData = _imageRowData;
- (void)viewDidLoad
{
    [super viewDidLoad];
        if(!_imageRowData)
    {
        _imageRowData = [[NSDictionary alloc] init];
    }
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%d", appDelegate.papas.count);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    _imageRowData = info;
        NSLog(@"pick image");
    [self performSegueWithIdentifier:@"CreateSegue" sender:self];
    
    
    
}

- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
     [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"CreateSegue"])
    {
        [segue.destinationViewController setImageInfo:_imageRowData];
        
    }
    
}


- (IBAction)create:(UIButton *)sender {
    UIImagePickerController *pickerC =
    [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];

}

- (IBAction)goToView:(UIButton *)sender {
     AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.papas.count > 0)
        [self performSegueWithIdentifier:@"viewPapa" sender:self];
}


- (IBAction)fetchData:(UIButton *)sender {
    NSFetchRequest* fetchRequest = [Image fetchRequest];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"url" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray* sortedObjects = [Image objectsWithFetchRequest:fetchRequest];
    for (Image *image in sortedObjects) {
        NSLog(@"url: %@", image.url);
        }
}

- (IBAction)testRestKit:(UIButton *)sender {
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURLString:@"http://kennel.cs.columbia.edu:8821"];
    RKManagedObjectStore *objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:RKDefaultSeedDatabaseFileName];
    objectManager.objectStore = objectStore;

    
        
    
    objectManager.serializationMIMEType = RKMIMETypeJSON;
    
    RKManagedObjectMapping* imageMapping = [RKManagedObjectMapping mappingForClass:[Image class] inManagedObjectStore:objectStore];
    [imageMapping mapKeyPath:@"url" toAttribute:@"url"];
    [imageMapping mapKeyPath:@"X" toAttribute:@"cordinateX"];
    [imageMapping mapKeyPath:@"Y" toAttribute:@"cordinateY"];
    [imageMapping mapKeyPath:@"time" toAttribute:@"uploadTime"];
    imageMapping.primaryKeyAttribute = @"url";
    
    [objectManager.mappingProvider setMapping:imageMapping forKeyPath:@"images"];

    [objectManager loadObjectsAtResourcePath:@"/get_photos.py?last_view=1&family_id=1" delegate:self ];

}




- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    RKLogInfo(@"Load collection of Images: %@", objects);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
    NSLog(@"log : %@",msg);
}
@end
