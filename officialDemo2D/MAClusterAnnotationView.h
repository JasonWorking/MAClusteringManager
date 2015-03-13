//
//  MAClusterAnnotationView.h
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/13.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface MAClusterAnnotationView : MAAnnotationView

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) UIColor *clusterColor;

@property (nonatomic, strong) UIColor *textColor;

@end
