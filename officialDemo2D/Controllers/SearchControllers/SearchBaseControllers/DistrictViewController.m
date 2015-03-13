//
//  DistrictViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 14/11/26.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "DistrictViewController.h"
#import "CommonUtility.h"


#define kDefaultDistrictName        @"北京市市辖区" //市辖区

@interface DistrictViewController ()

@end

@implementation DistrictViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self searchDistrictWithName:kDefaultDistrictName];
}

#pragma mark - Helpers

- (void)handleDistrictResponse:(AMapDistrictSearchResponse *)response
{
    if (response == nil)
    {
        return;
    }
    
    for (AMapDistrict *dist in response.districts)
    {
        MAPointAnnotation *poiAnnotation = [[MAPointAnnotation alloc] init];
        
        poiAnnotation.coordinate = CLLocationCoordinate2DMake(dist.center.latitude, dist.center.longitude);
        poiAnnotation.title      = dist.name;
        poiAnnotation.subtitle   = dist.adcode;
        
        [self.mapView addAnnotation:poiAnnotation];
        
        if (dist.polylines.count > 0)
        {
            MAMapRect bounds = MAMapRectZero;
            
            for (NSString *polylineStr in dist.polylines)
            {
                MAPolyline *polyline = [CommonUtility polylineForCoordinateString:polylineStr];
                [self.mapView addOverlay:polyline];
                
                bounds = MAMapRectUnion(bounds, polyline.boundingMapRect);
            }
            
            [self.mapView setVisibleMapRect:bounds animated:YES];
        }
        
        // sub
        for (AMapDistrict *subdist in dist.districts)
        {
            MAPointAnnotation *subAnnotation = [[MAPointAnnotation alloc] init];
            
            subAnnotation.coordinate = CLLocationCoordinate2DMake(subdist.center.latitude, subdist.center.longitude);
            subAnnotation.title      = subdist.name;
            subAnnotation.subtitle   = subdist.adcode;
            
            [self.mapView addAnnotation:subAnnotation];
            
        }
        
    }
    
}

- (void)searchDistrictWithName:(NSString *)name
{
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = name;
    dist.requireExtension = YES;
    
    [self.search AMapDistrictSearch:dist];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *busStopIdentifier = @"districtIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:busStopIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:busStopIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        return poiAnnotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4.f;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    NSLog(@"response: %@", response);
    [self handleDistrictResponse:response];
}

@end
