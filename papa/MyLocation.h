//
//  MyLocation.h
//  ArrestsPlotter
//
//  Created by Hai Lin on 10/21/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject<MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
