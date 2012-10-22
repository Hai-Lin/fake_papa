//
//  MapViewController.m
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize location = _location;
@synthesize mapView = _mapView;

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


- (void)viewWillAppear:(BOOL)animated {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    
    [_mapView setRegion:viewRegion animated:YES];
    MyLocation *annotation = [[MyLocation alloc] initWithName:@"photo name" address:@"address" coordinate:_location.coordinate] ;
    [_mapView addAnnotation:annotation];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
