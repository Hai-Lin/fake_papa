//
//  newImageViewController.m
//  papa
//
//  Created by Hai Lin on 11/14/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import "newImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>






@interface newImageViewController ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate,RKRequestDelegate>
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)setImage:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property NSArray *firstPage;
@property NSArray *secondPage;
@property AVAudioRecorder *audioRecorder;
@property AVAudioPlayer *audioPlayer;
@property NSData *audioData;
@property UIBarButtonItem *finishRecordingButton;

- (void) finishedRecording;

- (void) reRecording;

- (void) audioPlayBack;


@end

@implementation newImageViewController
@synthesize audioRecorder = _audioRecorder;
@synthesize audioPlayer = _audioPlayer;
@synthesize audioData = _audioData;
@synthesize imageInfo = _imageInfo;
@synthesize papa = _papa;
@synthesize imageView = _imageView;
@synthesize toolBar = _toolBar;
@synthesize firstPage = _firstPage;
@synthesize finishRecordingButton = _finishRecordingButton;
@synthesize secondPage = _secondPage;


-(void) finishedRecording {
    
    if (!_audioRecorder.recording)
    {
        _finishRecordingButton.title = @"Stop";
                [_audioRecorder record];
        
    }

    else {
        
        [_audioRecorder stop];
        NSError *err = nil;
        _audioData = [NSData dataWithContentsOfFile:[_audioRecorder.url path] options: 0 error:&err];
        _papa.audioData = _audioData;
        NSLog(@"finishedRecroding");

        if (err)
            NSLog(@"Error: %@",
                  [err localizedDescription]);

        
        [_toolBar setItems:_secondPage animated:YES];
        
    }
   

    
}

-(void) reRecording {
    _finishRecordingButton.title = @"Record";
    [_toolBar setItems:_firstPage animated:YES];

    
}

-(void) audioPlayBack {


    NSError *error = Nil;

    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithData:_audioData
                    error:&error];
    
    
    _audioPlayer.delegate = self;
    
    if (error)
        NSLog(@"Error: %@",
              [error localizedDescription]);
    else
    {
        [_audioPlayer play];
        
    }


    
}


- (UIImage*)chopImage: (UIImage*) sourceImage
{
    float newWidth, newHeight, startX, startY;
    float oldWidth = sourceImage.size.width;
    float oldHeight = sourceImage.size.height;
    float ratio = oldWidth/oldHeight;
    if (ratio > 1.5) {
        newWidth = oldHeight*1.5;
        newHeight = oldHeight;
        startX = (oldWidth - newWidth)/2;
        startY = 0;
    }
    else {
        newHeight = oldWidth/1.5;
        newWidth = oldWidth;
        startX = 0;
        startY = (oldHeight - newHeight)/2;
    }
    
    CGRect newSize = CGRectMake(startX, startY, newWidth, newHeight);
    
    CGImageRef tmp = CGImageCreateWithImageInRect([sourceImage CGImage], newSize);
    UIImage *newImage = [UIImage imageWithCGImage:tmp];

       return newImage;
}

- (void) initToolBarItem {
    //init toolbar item
    
    UIBarButtonItem *cancelRecordingButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style: UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    cancelRecordingButton.width = 180;
    
    _finishRecordingButton = [[UIBarButtonItem alloc] initWithTitle:@"Record" style: UIBarButtonItemStylePlain target:self action:@selector(finishedRecording)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(setImage:)];
    
    UIBarButtonItem *reRecordingButton = [[UIBarButtonItem alloc] initWithTitle:@"Rerecord" style:UIBarButtonItemStylePlain target:self action:@selector(reRecording)];
    reRecordingButton.width = 90;
    
    UIBarButtonItem *audioPlayBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Playback" style:UIBarButtonItemStylePlain target:self action:@selector(audioPlayBack)];
    audioPlayBackButton.width = 120;
    
    _firstPage = [[NSArray alloc] initWithObjects:cancelRecordingButton, _finishRecordingButton,  nil];
    _secondPage = [[NSArray alloc] initWithObjects:reRecordingButton, audioPlayBackButton, doneButton, nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *newImg = [_imageInfo objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@", [_imageInfo description]);
    [_imageView setImage:[self chopImage:newImg]];
    
    _papa = [[papa alloc] init];
    _papa.imageData = _imageInfo;
    
    
    [self initToolBarItem];


    [_toolBar setItems:_firstPage animated:NO];
    
    //init audio player
    _audioData = [[NSData alloc] init];
        
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        NSLog(@"prepare to record");
        [_audioRecorder prepareToRecord];
    }
    
    //set base url
    [RKClient clientWithBaseURLString:@"http://kennel.cs.columbia.edu:8821"];


	
}


- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setImage:(UIBarButtonItem *)sender {
    //post image to serve
    
    NSDictionary* paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"3", @"family_id",
                                      @"1,2", @"coordinates",
                                      nil];
    RKParams* params = [RKParams paramsWithDictionary:paramsDictionary];
    
    NSData* imageData = UIImagePNGRepresentation(_imageView.image);

    [params setData:imageData MIMEType:@"image/png" forParam:@"uploadFile"];
    
    [[RKClient sharedClient] post:@"/try.py" params:params delegate:self];
    
}


- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
            
        }
        
    } else if ([request isPOST]) {
        
        // Handling POST /try.json
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
            NSLog([response bodyAsString]);
            [self dismissViewControllerAnimated:YES completion:nil];


        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}
@end
