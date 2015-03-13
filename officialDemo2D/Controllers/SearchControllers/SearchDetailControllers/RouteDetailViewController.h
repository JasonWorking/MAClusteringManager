//
//  RouteDetailViewController.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-19.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@interface RouteDetailViewController : UIViewController

@property (nonatomic, strong) AMapRoute *route;

@property (nonatomic) AMapSearchType searchType;

@end
