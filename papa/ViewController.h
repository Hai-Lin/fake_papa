//
//  ViewController.h
//  papa
//
//  Created by Hai Lin on 10/18/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "papa.h"
#import "CreateViewController.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property NSMutableArray *papa;
- (IBAction)create:(UIButton *)sender;
@end
