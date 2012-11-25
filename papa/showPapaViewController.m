//
//  showPapaViewController.m
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import "showPapaViewController.h"
#import "newImageViewController.h"

#define METERS_PER_MILE 1609.344

@interface showPapaViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property papa *papa;
@property AVAudioPlayer *audioPlayer;
@property CLLocation *location;
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property NSDictionary *imageInfo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *carmeraButton;

//icons
- (IBAction)addNewContent:(UIBarButtonItem *)sender;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;
- (void)fetchImageFromDataBase;

@end

@implementation showPapaViewController

@synthesize addButton = _addButton;
@synthesize audioPlayer = _audioPlayer;
@synthesize carmeraButton = _carmeraButton;
@synthesize familyNameLabel = _familyNameLabel;
@synthesize index = _index;
@synthesize imageArray = _imageArray;
@synthesize imageInfo = _imageInfo;
@synthesize imageView = _imageView;
@synthesize location = _location;
@synthesize locationManager = _locationManager;
@synthesize papa = _papa;
@synthesize nextButton = _nextButton;
@synthesize scrollView = _scrollView;
@synthesize toolBarView = _toolBarView;




- (IBAction)addNewContent:(UIBarButtonItem *)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Add New Photo"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel Button"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Take Photo", @"From Photo Album", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showFromBarButtonItem:_addButton animated:YES];

}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

-(void)scrollViewSingleTapped:(UITapGestureRecognizer*)recognizer {
    //single tap to hide tollbar
    NSLog(@"Single Tap");
    if(_toolBarView.hidden) {
        _toolBarView.hidden = NO;
        _familyNameLabel.hidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    else {
        _toolBarView.hidden = YES;
        _familyNameLabel.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    }
}

- (void) didSwipeLeft:(UITapGestureRecognizer*)recognizer {
    NSLog(@"Swipe Left");
    if(_imageArray.count > (_index+1))
        [self performSegueWithIdentifier:@"nextPage" sender:self];
 
}

- (void) didSwipeRight:(UITapGestureRecognizer*)recognizer {
    NSLog(@"Swipe Right");
    [self.navigationController popViewControllerAnimated:YES];
    }


-(void) initScrollView {
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    
    self.scrollView.maximumZoomScale = 1.5f;
    self.scrollView.zoomScale = minScale;
    
    
    [self centerScrollViewContents];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)fetchImageFromDataBase {
    _imageArray = [[NSArray alloc] init];
    NSLog(@"fetch image from database");
    NSFetchRequest* fetchRequest = [Image fetchRequest];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    _imageArray = [Image objectsWithFetchRequest:fetchRequest];
    
    for (Image *image in _imageArray) {
        NSLog(@"id: %@", image.id);
        NSLog(@"url: %@", image.imageURL);
        NSLog(@"path: %@", image.imagePath);
        NSLog(@"cordinateX: %@", image.cordinateX);
        NSLog(@"cordinateY: %@", image.cordinateY);
        
    }
    
    
    
}



- (void) addGesturesToView {
    
    // Add gestureReconizer to scrollView
    
    //Double Tap
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    
    
    
    //pinch
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    // Add gestureReconizer to view
    //Sinlge Tap
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
    
    //Swipe Left
    UISwipeGestureRecognizer *swipeGestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeGestureRecognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureRecognizerLeft];
    
    //Swipe Right
    UISwipeGestureRecognizer *swipeGestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipeGestureRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRecognizerRight];

    
}

-(void) initSprite {
    
    UIImage *sprite = [UIImage imageNamed:@"icon_sprite"];
    
    CGImageRef cgIcon = CGImageCreateWithImageInRect(sprite.CGImage, CGRectMake(280, 200, 40, 40));
    
    [_carmeraButton setBackButtonBackgroundImage:[UIImage imageWithCGImage:cgIcon] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[_carmeraButton setImage:[UIImage imageWithCGImage:cgIcon] forState:UIControlStateNormal];

    CGImageRelease(cgIcon);

}


- (void)viewDidLoad
{

    [super viewDidLoad];
    if(!_imageArray)
        [self fetchImageFromDataBase];
               
    Image *image = _imageArray[_index];
    

    UIImage *gotImage = [UIImage imageWithData:[[NSFileManager defaultManager] contentsAtPath:image.imagePath]];
    [_imageView setImage:gotImage];
       //distance label
    _familyNameLabel.textColor = [UIColor colorWithWhite:1 alpha:1];

    _familyNameLabel.backgroundColor = [UIColor colorWithRed: 0 green:0 blue:0 alpha:0.2];

    //setup scrollView
    _scrollView.delegate = self;
    _scrollView.contentSize = gotImage.size;
    _imageView.frame = CGRectMake( 0, 0, _imageView.image.size.width, _imageView.image.size.height);
    
    [self addGesturesToView];
    
    [self initSprite];


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
    
    [self initScrollView];
    
}








- (IBAction)nextPage:(UIBarButtonItem *)sender {
    if(_imageArray.count > (_index+1))
        [self performSegueWithIdentifier:@"nextPage" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"nextPage"])
    {
        if(_imageArray.count > (_index+1))
        {
            //this is gona kill me
            int newIndex = _index+1;
            NSLog(@"array count: %d", _imageArray.count);
            NSLog(@"new index: %d", newIndex);
            [segue.destinationViewController setIndex:newIndex];
        }
    }
    if([segue.identifier isEqualToString:@"ShowMap"]) {
        [segue.destinationViewController setLocation:_location];
    }
    if([segue.identifier isEqualToString:@"viewImage"]) {
        [segue.destinationViewController setImageInfo:_imageInfo];
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
    [self performSegueWithIdentifier:@"ShowMap" sender:self];
}

#pragma mark locationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //double distance = [_location distanceFromLocation:_locationManager.location];
    //_distanceLabel.text = [NSString stringWithFormat:@"%f miles away",distance/METERS_PER_MILE];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"%@",[error description]);
}

#pragma mark UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
    NSLog(@"%f",scrollView.zoomScale);
    NSLog(@"%f",scrollView.minimumZoomScale);
}


#pragma mark UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _imageInfo = info;
    [self dismissViewControllerAnimated:YES completion:^ () {
        
        
        [self performSegueWithIdentifier:@"viewImage" sender:self];
    }];
    
    
    
    
}

- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"0 button clicked");
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.delegate = self;
            [self presentViewController:pickerC animated:YES completion:nil];
                      break;
        }
        case 1:
        {
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.delegate = self;
            [self presentViewController:pickerC animated:YES completion:nil];
            break;
        }
          
     }
}


@end
