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

@end

@implementation newImageViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setImage:(UIBarButtonItem *)sender {
    //post image to server
}
@end
