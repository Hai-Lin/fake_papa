//
//  Image.h
//  papa
//
//  Created by Hai Lin on 11/18/12.
//  Copyright (c) 2012 Hai Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject

@property (nonatomic, retain) NSNumber * cordinateX;
@property (nonatomic, retain) NSNumber * cordinateY;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * uploadTime;

@end
