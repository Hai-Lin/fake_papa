//
//  MapViewController.h
//  papa
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyLocation.h"

@interface MapViewController : UIViewController
@property CLLocation *location;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
