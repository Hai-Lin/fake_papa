//
//  showPapaViewController.h
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface showPapaViewController : UIViewController
@property(nonatomic, assign) int index;
- (IBAction)nextPage:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
