//
//  MAAnnotationCluster.h
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/11.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>


@interface MAAnnotationCluster : NSObject <MAAnnotation>

/// Coordinate of the annotation(cluster).
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/// Title of the annotation. Default is \c nil.
@property (nonatomic, copy  ) NSString *title;

/// Subtitle of the annotation. Default is \c nil.
@property (nonatomic, copy  ) NSString *subtitle;

/// Array of the annotations that are representer with this cluster.
@property (nonatomic, strong) NSArray  *annotations;

@end
