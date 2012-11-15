//
//  newImageViewController.m
//  papa
//
//  Created by Hai Lin on 11/14/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import "newImageViewController.h"

@interface newImageViewController ()
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)setImage:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property NSArray *firstPage;
@property NSArray *secondPage;
- (void) finishedRecording;

- (void) reRecording;

- (void) audioPlayBack;


@end

@implementation newImageViewController
@synthesize imageInfo = _imageInfo;
@synthesize papa = _papa;
@synthesize imageView = _imageView;
@synthesize toolBar = _toolBar;
@synthesize firstPage = _firstPage;
@synthesize secondPage = _secondPage;

-(void) finishedRecording {
    
    //recording
    NSLog(@"finishedRecroding");
    
    [_toolBar setItems:_secondPage animated:YES];

    
}

-(void) reRecording {
    
    [_toolBar setItems:_firstPage animated:YES];

    
}

-(void) audioPlayBack {
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *newImg = [_imageInfo objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"Load image");
    NSLog(@"%@", [_imageInfo description]);
    [_imageView setImage:newImg];
    _papa = [[papa alloc] init];
    _papa.imageData = _imageInfo;
    
    //init toolbar item
    UIBarButtonItem *cancelRecordingButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style: UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    cancelRecordingButton.width = 180;
    
    UIBarButtonItem *finishRecordingButton = [[UIBarButtonItem alloc] initWithTitle:@"Record" style: UIBarButtonItemStylePlain target:self action:@selector(finishedRecording)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(setImage:)];
    
    UIBarButtonItem *reRecordingButton = [[UIBarButtonItem alloc] initWithTitle:@"Rerecord" style:UIBarButtonItemStylePlain target:self action:@selector(reRecording)];
    
    UIBarButtonItem *audioPlayBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStylePlain target:self action:@selector(audioPlayBack)];
    
    _firstPage = [[NSArray alloc] initWithObjects:cancelRecordingButton, finishRecordingButton,  nil];
    _secondPage = [[NSArray alloc] initWithObjects:reRecordingButton, audioPlayBackButton, doneButton, nil];
    


    [_toolBar setItems:_firstPage animated:NO];

	
}


- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setImage:(UIBarButtonItem *)sender {
    //post image to server
        
    
   [self dismissViewControllerAnimated:YES completion:nil];

}
@end
