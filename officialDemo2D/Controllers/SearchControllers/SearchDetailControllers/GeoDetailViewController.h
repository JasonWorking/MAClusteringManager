//
//  GeoDetailViewController.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-23.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface GeoDetailViewController : UIViewController

@property (nonatomic, strong) AMapGeocode *geocode;

@end
