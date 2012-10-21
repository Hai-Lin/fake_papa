//
//  CreateViewController.h
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "papa.h"

@interface CreateViewController : UIViewController
@property papa * papa;
@property NSDictionary *imageInfo;
@property NSData *audioInfo;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
