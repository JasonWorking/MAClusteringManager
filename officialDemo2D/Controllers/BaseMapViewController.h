//
//  BaseMapViewController.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface BaseMapViewController : UIViewController<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end
