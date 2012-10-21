//
//  CreateViewController.m
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()
@property AVAudioRecorder *audioRecorder;
@property AVAudioPlayer *audioPlayer;
@property NSData *audioData;

@end

@implementation CreateViewController
@synthesize imageInfo = _imageInfo;
@synthesize papa = _papa;
@synthesize image = _image;
@synthesize recordButton = _recordButton;
@synthesize stopButton = _stopButton;
@synthesize playButton = _playButton;

@synthesize audioRecorder = _audioRecorder;
@synthesize audioPlayer = _audioPlayer;
@synthesize audioData = _audioData;


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
    
    //set image
    UIImage *newImg = [_imageInfo objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"Load image");
    NSLog(@"%@", [_imageInfo description]);
    [_image setImage:newImg];
    
    //init audio player
    _playButton.enabled = NO;
    _stopButton.enabled = NO;
    
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
        [_audioRecorder prepareToRecord];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)record:(UIButton *)sender {
    if (!_audioRecorder.recording)
    {
        _playButton.enabled = NO;
        _stopButton.enabled = YES;
        [_audioRecorder record];
        [_recordButton setTitle:@"Recording" forState:UIControlStateNormal];
        
    }

}

- (IBAction)stop:(UIButton *)sender {
    _stopButton.enabled = NO;
    _playButton.enabled = YES;
    _recordButton.enabled = YES;
    
    if (_audioRecorder.recording)
    {
        [_audioRecorder stop];
        NSError *err = nil;
        _audioData = [NSData dataWithContentsOfFile:[_audioRecorder.url path] options: 0 error:&err];
        [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    } else if (_audioPlayer.playing) {
        [_audioPlayer stop];
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
    }

}

- (IBAction)play:(UIButton *)sender {
    if (!_audioRecorder.recording)
    {
        _stopButton.enabled = YES;
        _recordButton.enabled = NO;
        
        NSError *error;
        
        
        //audioPlayer = [[AVAudioPlayer alloc]
        //             initWithContentsOfURL:audioRecorder.url
        //           error:&error];
        
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
            [_playButton setTitle:@"Playing" forState:UIControlStateNormal];
            
        }
            
    }

}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_playButton setTitle:@"Play" forState:UIControlStateNormal];
}
@end
