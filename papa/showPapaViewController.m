//
//  showPapaViewController.m
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import "showPapaViewController.h"

#define METERS_PER_MILE 1609.344

@interface showPapaViewController ()
@property papa *papa;
@property AVAudioPlayer *audioPlayer;
@property CLLocation *location;
@property CLLocationManager *locationManager;

@end

@implementation showPapaViewController

@synthesize index = _index;
@synthesize papa = _papa;
@synthesize image = _image;
@synthesize audioPlayer = _audioPlayer;
@synthesize nextButton = _nextButton;
@synthesize location = _location;
@synthesize distanceLabel = _distanceLabel;
@synthesize locationManager = _locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _papa = appDelegate.papas[_index];
    UIImage *gotImage = [_papa.imageData objectForKey:UIImagePickerControllerOriginalImage];
    [_image setImage:gotImage];
    if(appDelegate.papas.count <= (_index+1))
        _nextButton.enabled = NO;
    //Get user location
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    // Get the asset url
    NSURL *url = [_papa.imageData objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    // We need to use blocks. This block will handle the ALAsset that's returned:
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        // Get the location property from the asset
        _location = [myasset valueForProperty:ALAssetPropertyLocation];
        //double distance = [_location distanceFromLocation:_locationManager.location];
        //_distanceLabel.text = [NSString stringWithFormat:@"%f meters away",distance];
        
        
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


    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextPage:(UIBarButtonItem *)sender {
     AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.papas.count > (_index+1))
        [self performSegueWithIdentifier:@"nextPage" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"nextPage"])
    {
        AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.papas.count > (_index+1))
        {
            int newIndex = _index+1;
            [segue.destinationViewController setIndex:newIndex];
        }
        
    }
    
}

- (IBAction)play:(UIBarButtonItem *)sender {
    if(_papa.audioData) {
        
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithData:_papa.audioData
                    error:&error];
    
    
    _audioPlayer.delegate = self;
    
    if (error)
        NSLog(@"Error: %@",
              [error localizedDescription]);
    else
        [_audioPlayer play];
        }
    else
        NSLog(@"no audio");
}

- (IBAction)goToMap:(UIBarButtonItem *)sender {
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    double distance = [_location distanceFromLocation:_locationManager.location];
    _distanceLabel.text = [NSString stringWithFormat:@"%f miles away",distance/METERS_PER_MILE];
    NSLog(@"%@", [_location description]);
    NSLog(@"%@", [_locationManager.location description]);
    
    NSLog(@"%f",[_location distanceFromLocation:_locationManager.location]);
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error description]);
}

@end
