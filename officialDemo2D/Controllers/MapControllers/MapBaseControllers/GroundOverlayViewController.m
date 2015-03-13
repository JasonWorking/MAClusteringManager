//
//  GroundOverlayViewController.m
//  DevDemo2D
//
//  Created by 刘博 on 14-2-13.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import "GroundOverlayViewController.h"

@interface GroundOverlayViewController ()

@property (nonatomic, strong) MAGroundOverlay *groundOverlay;

@end

@implementation GroundOverlayViewController

@synthesize groundOverlay = _groundOverlay;

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayRenderer *groundOverlayRenderer = [[MAGroundOverlayRenderer alloc] initWithGroundOverlay:overlay];
        [groundOverlayRenderer setAlpha:0.6];
        
        return groundOverlayRenderer;
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)initGroundOverlay
{
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake(39.939577, 116.388331),
        CLLocationCoordinate2DMake(39.935029, 116.384377));
    
    self.groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:[UIImage imageNamed:@"GWF"]];
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        [self initGroundOverlay];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView addOverlay:self.groundOverlay];
    
    [self.mapView setVisibleMapRect:self.groundOverlay.boundingMapRect animated:NO];
}

@end
