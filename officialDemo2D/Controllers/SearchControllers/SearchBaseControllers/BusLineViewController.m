//
//  BusLineViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BusLineViewController.h"
#import "BusLineDetailViewController.h"
#import "CommonUtility.h"
#import "BusStopAnnotation.h"
#import "BusStopDetailViewController.h"

#define BusLinePlaceHolder @"北京/上海/深圳公交线路名称"

@interface BusLineViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;
@property (nonatomic, strong) UIBarButtonItem *detailItem;

@property (nonatomic, strong) NSMutableArray *busLines;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation BusLineViewController
@synthesize searchBar    = _searchBar;
@synthesize previousItem = _previousItem;
@synthesize nextItem     = _nextItem;
@synthesize detailItem   = _detailItem;

@synthesize busLines = _busLines;

#pragma mark - Utility

/* 更新"上一个", "下一个"按钮状态. */
- (void)updateCourseUI
{
    /* 上一个. */
    self.previousItem.enabled = (self.currentIndex > 0);
    
    /* 下一个. */
    self.nextItem.enabled = (self.currentIndex < (NSInteger)self.busLines.count - 1);
}

/* 更新"详情"按钮状态. */
- (void)updateDetailUI
{
    self.detailItem.enabled = self.busLines.count != 0;
}

/* 清空地图上的overlay, annotation. */
- (void)clear
{
    [self.mapView removeOverlays:self.mapView.overlays];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (AMapBusLine *)currentBusLine
{
    if (self.busLines.count == 0)
    {
        return nil;
    }
    
    if (self.currentIndex < 0 || self.currentIndex >= self.busLines.count)
    {
        return nil;
    }
    
    return self.busLines[self.currentIndex];
}

- (void)presentCurrentBusLine
{
    AMapBusLine *busLine = [self currentBusLine];
    
    if (busLine == nil)
    {
        return;
    }
    
    NSMutableArray *busStopAnnotations = [NSMutableArray array];
    
    [busLine.busStops enumerateObjectsUsingBlock:^(AMapBusStop *busStop, NSUInteger idx, BOOL *stop) {
        BusStopAnnotation *annotation = [[BusStopAnnotation alloc] initWithBusStop:busStop];
        
        [busStopAnnotations addObject:annotation];
    }];
    
    [self.mapView addAnnotations:busStopAnnotations];
    
    MAPolyline *polyline = [CommonUtility polylineForBusLine:busLine];
    
    [self.mapView addOverlay:polyline];
    
    self.mapView.visibleMapRect = polyline.boundingMapRect;
}

- (void)gotoDetailForBusLine:(AMapBusLine *)busLine
{
    if (busLine != nil)
    {
        BusLineDetailViewController *busLineDetailViewController = [[BusLineDetailViewController alloc] init];
        
        busLineDetailViewController.busLine = busLine;
        
        [self.navigationController pushViewController:busLineDetailViewController animated:YES];
    }
}

- (void)gotoDetailForBusStop:(AMapBusStop *)busStop
{
    if (busStop != nil)
    {
        BusStopDetailViewController *busStopDetailViewController = [[BusStopDetailViewController alloc] init];
        
        busStopDetailViewController.busStop = busStop;
        
        [self.navigationController pushViewController:busStopDetailViewController animated:YES];
    }
}

/* 根据key搜索公交路线. */
- (void)searchLineByKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapBusLineSearchRequest *line = [[AMapBusLineSearchRequest alloc] init];
    line.keywords           = key;
    line.city               = @[@"beijing", @"shanghai", @"shenzhen"];
    line.requireExtension   = YES;
    
    [self.search AMapBusLineSearch:line];
}

#pragma mark - AMapSearchDelegate

/* 公交路线回调*/
- (void)onBusLineSearchDone:(AMapBusLineSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    if (response.buslines.count != 0)
    {
        [self.busLines setArray:response.buslines];
        self.currentIndex = 0;
        [self updateCourseUI];
        [self updateDetailUI];
        
        [self presentCurrentBusLine];
    }
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[BusStopAnnotation class]])
    {
        [self gotoDetailForBusStop:[(BusStopAnnotation*)view.annotation busStop]];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BusStopAnnotation class]])
    {
        static NSString *busStopIdentifier = @"busStopIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:busStopIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:busStopIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
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

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar resignFirstResponder];
    
    [self clear];
    [self.busLines removeAllObjects];
    self.currentIndex = 0;
    
    [self updateCourseUI];
    [self updateDetailUI];
    
    [self searchLineByKey:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar resignFirstResponder];
}

#pragma mark - Handle Action

/* 上一条公交路线. */
- (void)previousAction
{
    [self clear];
    
    self.currentIndex--;
    
    [self presentCurrentBusLine];
    
    [self updateCourseUI];
}

/* 下一条公交路线. */
- (void)nextAction
{
    [self clear];
    
    self.currentIndex++;
    
    [self presentCurrentBusLine];
    
    [self updateCourseUI];
}

/* 详情. */
- (void)detailAction
{
    AMapBusLine *busLine = [self currentBusLine];
    
    if (busLine != nil)
    {
        [self gotoDetailForBusLine:busLine];
    }
}

#pragma mark - Initialization

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    /* 上一个. */
    UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithTitle:@"上一个"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(previousAction)];
    self.previousItem = previousItem;
    
    /* 下一个. */
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"下一个"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(nextAction)];
    self.nextItem = nextItem;
    
    /* 详情. */
    UIBarButtonItem *detailItem = [[UIBarButtonItem alloc] initWithTitle:@"路线详情"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(detailAction)];
    self.detailItem = detailItem;
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, previousItem, flexbleItem, nextItem, flexbleItem, detailItem, flexbleItem, nil];
}

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.searchBar.barStyle     = UIBarStyleBlack;
	self.searchBar.delegate     = self;
    self.searchBar.placeholder  = BusLinePlaceHolder;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    self.navigationItem.titleView = self.searchBar;
    
    [self.searchBar sizeToFit];
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.busLines = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSearchBar];
    
    [self initToolBar];
    
    [self updateCourseUI];
    
    [self updateDetailUI];
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
