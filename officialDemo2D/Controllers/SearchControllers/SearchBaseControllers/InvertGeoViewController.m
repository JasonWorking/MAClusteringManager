//
//  InvertGeoViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "InvertGeoViewController.h"
#import "InvertGeoDetailViewController.h"
#import "ReGeocodeAnnotation.h"
#import "CommonUtility.h"

@interface InvertGeoViewController ()<UIGestureRecognizerDelegate>

@end

@implementation InvertGeoViewController

- (void)gotoDetailForReGeocode:(AMapReGeocode *)reGeocode
{
    if (reGeocode != nil)
    {
        InvertGeoDetailViewController *invertGeoDetailViewController = [[InvertGeoDetailViewController alloc] init];
        
        invertGeoDetailViewController.reGeocode = reGeocode;
        
        [self.navigationController pushViewController:invertGeoDetailViewController animated:YES];
    }
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    [self.mapView selectAnnotation:view.annotation animated:YES];
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        [self gotoDetailForReGeocode:[(ReGeocodeAnnotation*)view.annotation reGeocode]];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        static NSString *invertGeoIdentifier = @"invertGeoIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:invertGeoIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:invertGeoIdentifier];
        }
        
        poiAnnotationView.animatesDrop   = YES;
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
                                                                                         reGeocode:response.regeocode];
        
        [self.mapView addAnnotation:reGeocodeAnnotation];
    }
}

#pragma mark - Handle Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[longPress locationInView:self.view]
                                                  toCoordinateFromView:self.mapView];
        
        [self searchReGeocodeWithCoordinate:coordinate];
    }
}

#pragma mark - Initialization

- (void)initGestureRecognizer
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleLongPress:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.5;
    
    [self.view addGestureRecognizer:longPress];
}

- (void)initToolBar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    UILabel *prompts = [[UILabel alloc] init];
    prompts.text            = @"长按添加标注";
    prompts.textAlignment   = UITextAlignmentCenter;
    prompts.backgroundColor = [UIColor clearColor];
    prompts.textColor       = [UIColor whiteColor];
    prompts.font            = [UIFont systemFontOfSize:20];
    [prompts sizeToFit];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:prompts];
    self.toolbarItems = [NSArray arrayWithObjects:flexble, item, flexble, nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initToolBar];
    
    [self initGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

@end
