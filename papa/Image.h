//
//  Image.h
//  papa
//
//  Created by Hai Lin on 11/17/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * uploadTime;
@property (nonatomic, retain) NSNumber * cordinateX;
@property (nonatomic, retain) NSNumber * cordinateY;

@end
