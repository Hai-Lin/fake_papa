//
//  CreateViewController.h
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "papa.h"

@interface CreateViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property papa * papa;
@property NSDictionary *imageInfo;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)record:(UIButton *)sender;
- (IBAction)stop:(UIButton *)sender;
- (IBAction)play:(UIButton *)sender;

@end
