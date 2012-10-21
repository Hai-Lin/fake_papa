//
//  ViewController.m
//  papa
//
//  Created by Hai Lin on 10/18/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property NSDictionary *imageRowData;


@end

@implementation ViewController

@synthesize papa = _papa;
@synthesize imageRowData = _imageRowData;
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_papa)
    {
        _papa = [[NSMutableArray alloc] init];
    }
    if(_imageRowData)
    {
        _imageRowData = [[NSDictionary alloc] init];
    }
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
    /*
    UIImage *gotImage =
    [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Get the asset url
    NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    // We need to use blocks. This block will handle the ALAsset that's returned:
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        // Get the location property from the asset
        CLLocation *location = [myasset valueForProperty:ALAssetPropertyLocation];
        NSLog(@"%@", [location description]);
        zoomLocation = location.coordinate;
        // I found that the easiest way is to send the location to another method
        //[self handleImageLocation:location];
    };
    // This block will handle errors:
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Can not get asset - %@",[myerror localizedDescription]);
        // Do something to handle the error
    };
    
    
    // Use the url to get the asset from ALAssetsLibrary,
    // the blocks that we just created will handle results
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:url
                   resultBlock:resultblock
                  failureBlock:failureblock];
    
    //End getting location
    
    
    sendImage = gotImage;
    beginImage = [CIImage imageWithCGImage:gotImage.CGImage];
    
    [filter setValue:beginImage forKey:kCIInputImageKey];
    [self changeValue:_amountSlider];
     */
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
@end
