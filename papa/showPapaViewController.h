//
//  showPapaViewController.h
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "Image.h"

@interface showPapaViewController : UIViewController <AVAudioPlayerDelegate, CLLocationManagerDelegate, UIScrollViewDelegate>
@property(nonatomic, assign) int index;
- (IBAction)nextPage:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
- (IBAction)play:(UIBarButtonItem *)sender;
- (IBAction)goToMap:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel;
@property NSArray * imageArray;

@end
