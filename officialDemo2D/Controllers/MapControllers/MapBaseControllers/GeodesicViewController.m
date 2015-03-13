//
//  GeodesicViewController.m
//  officialDemo2D
//
//  Created by 刘博 on 13-10-24.
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import "GeodesicViewController.h"

@interface GeodesicViewController ()

@property (nonatomic, strong) MAGeodesicPolyline *geodesicPolyline;

@end

@implementation GeodesicViewController

@synthesize geodesicPolyline = _geodesicPolyline;

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAGeodesicPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)initGeodesicPolyline
{
    CLLocationCoordinate2D geodesicCoords[2];
    
    geodesicCoords[0].latitude  = 39.905151;
    geodesicCoords[0].longitude = 116.401726;
    
    geodesicCoords[1].latitude  = 38.905151;
    geodesicCoords[1].longitude = 70.401726;
    
    self.geodesicPolyline = [MAGeodesicPolyline polylineWithCoordinates:geodesicCoords
                                                                  count:(sizeof(geodesicCoords)/sizeof(CLLocationCoordinate2D))];
}


#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initGeodesicPolyline];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView addOverlay:self.geodesicPolyline];
    
    [self.mapView setVisibleMapRect:self.geodesicPolyline.boundingMapRect animated:NO];
}

@end
