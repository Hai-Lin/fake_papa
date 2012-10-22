//
//  ViewController.m
//  papa
//
//  Created by Hai Lin on 10/18/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property NSDictionary *imageRowData;

@end

@implementation ViewController

@synthesize imageRowData = _imageRowData;
- (void)viewDidLoad
{
    [super viewDidLoad];
        if(!_imageRowData)
    {
        _imageRowData = [[NSDictionary alloc] init];
    }
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%d", appDelegate.papas.count);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    _imageRowData = info;
        NSLog(@"pick image");
    [self performSegueWithIdentifier:@"CreateSegue" sender:self];
    
    
    
}

- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
     [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"CreateSegue"])
    {
        [segue.destinationViewController setImageInfo:_imageRowData];
        
    }
    
}


- (IBAction)create:(UIButton *)sender {
    UIImagePickerController *pickerC =
    [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];

}

- (IBAction)goToView:(UIButton *)sender {
     AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.papas.count > 0)
        [self performSegueWithIdentifier:@"viewPapa" sender:self];
}

@end
