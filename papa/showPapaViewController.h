//
//  showPapaViewController.h
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface showPapaViewController : UIViewController <AVAudioPlayerDelegate, CLLocationManagerDelegate>
@property(nonatomic, assign) int index;
- (IBAction)nextPage:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
- (IBAction)play:(UIBarButtonItem *)sender;
- (IBAction)goToMap:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
