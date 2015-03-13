//
//  CustomUserLocationViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 14-4-22.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "CustomUserLocationViewController.h"

@implementation CustomUserLocationViewController

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];

    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];

        [self.mapView updateUserLocationRepresentation:pre];

        view.calloutOffset = CGPointMake(0, 0);
    }  
}

- (void)returnAction
{
    [super returnAction];
    
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    [self.mapView setZoomLevel:16.1 animated:YES];
}

@end
