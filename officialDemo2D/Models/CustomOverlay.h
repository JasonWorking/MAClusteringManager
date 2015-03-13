//
//  CustomOverlay.h
//  DevDemo2D
//
//  Created by 刘博 on 14-1-16.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomOverlay : NSObject<MAOverlay>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) MAMapRect boundingMapRect;

@property (nonatomic, readonly) CLLocationDistance radius;

- (id)initWithCenter:(CLLocationCoordinate2D)center radius:(CLLocationDistance)radius;

@end
