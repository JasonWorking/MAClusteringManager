//
//  CustomOverlayViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomOverlayViewController.h"
#import "CustomOverlay.h"
#import "CustomOverlayRenderer.h"

@interface CustomOverlayViewController ()

@property (nonatomic, strong) CustomOverlay *customOverlay;

@end

@implementation CustomOverlayViewController

@synthesize customOverlay = _customOverlay;

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[CustomOverlay class]])
    {
        CustomOverlayRenderer *renderer = [[CustomOverlayRenderer alloc] initWithOverlay:overlay];
        
        return renderer;
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)initOverlay
{
    self.customOverlay = [[CustomOverlay alloc] initWithCenter:CLLocationCoordinate2DMake(39.929641, 116.431025) radius:10000];
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        [self initOverlay];  
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView addOverlay:self.customOverlay];
}

@end
