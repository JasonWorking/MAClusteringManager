//
//  PoiViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "PoiViewController.h"
#import "POIAnnotation.h"
#import "PoiDetailViewController.h"
#import "CommonUtility.h"

@interface PoiViewController ()

@property (nonatomic) AMapSearchType searchType;

@end

@implementation PoiViewController
@synthesize searchType = _searchType;

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
        
        PoiDetailViewController *detail = [[PoiDetailViewController alloc] init];
        detail.poi = poiAnnotation.poi;
        
        /* 进入POI详情页面. */
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* POI 搜索回调. */
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
    if (request.searchType != self.searchType)
    {
        return;
    }
    
    if (respons.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:respons.pois.count];
    
    [respons.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        self.mapView.centerCoordinate = [poiAnnotations[0] coordinate];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:NO];
    }
}

#pragma mark - Utility

/* 根据ID来搜索POI. */
- (void)searchPoiByID
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    //    B000A80WBJ    hotel
    //    B00141IEZK    dining
    //    B000A876EH    cinema
    //    B000A7O1CU    scenic
    request.searchType          = AMapSearchType_PlaceID;
    request.uid                 = @"B000A07060";
    request.requireExtension    = YES;
    
    [self.search AMapPlaceSearch:request];
    
}

/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType          = AMapSearchType_PlaceKeyword;
    request.keywords            = @"肯德基";
    request.city                = @[@"010"];
    request.requireExtension    = YES;
    [self.search AMapPlaceSearch:request];
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType          = AMapSearchType_PlaceAround;
    request.location            = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.keywords            = @"餐饮";
    /* 按照距离排序. */
    request.sortrule            = 1;
    request.requireExtension    = YES;
    
    /* 添加搜索结果过滤 */
    AMapPlaceSearchFilter *filter = [[AMapPlaceSearchFilter alloc] init];
    filter.costFilter = @[@"100", @"200"];
    filter.requireFilter = AMapRequireGroupbuy;
    request.searchFilter = filter;
    
    [self.search AMapPlaceSearch:request];
}

/* 在指定的范围内搜索POI. */
- (void)searchPoiByPolygon
{
    NSArray *points = [NSArray arrayWithObjects:
                       [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476],
                       [AMapGeoPoint locationWithLatitude:39.890459 longitude:116.581476],
                       nil];
    AMapGeoPolygon *polygon = [AMapGeoPolygon polygonWithPoints:points];
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType          = AMapSearchType_PlacePolygon;
    request.polygon             = polygon;
    request.keywords            = @"Apple";
    request.requireExtension    = YES;
    
    [self.search AMapPlaceSearch:request];
}

- (void)searchPoiWithType:(AMapSearchType)searchType
{
    /* 清除存在的annotation. */
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    switch (searchType)
    {
        case AMapSearchType_PlaceID:
        {
            [self searchPoiByID];
            
            break;
        }
        case AMapSearchType_PlaceKeyword:
        {
            [self searchPoiByKeyword];
            
            break;
        };
        case AMapSearchType_PlaceAround:
        {
            [self searchPoiByCenterCoordinate];
            
            break;
        }
        default:
        {
            [self searchPoiByPolygon];
            
            break;
        }
    }
}

#pragma mark - Handle Action

- (void)searchTypeAction:(UISegmentedControl *)segmentedControl
{
    self.searchType = segmentedControl.selectedSegmentIndex + 1;
    
    [self searchPoiWithType:self.searchType];
}

#pragma mark - Initialization

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    UISegmentedControl *searchTypeSegCtl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             @"POI的ID",
                                             @"关键字",
                                             @"周边",
                                             @"多边形",
                                             nil]];
    searchTypeSegCtl.selectedSegmentIndex  = self.searchType - 1;
    searchTypeSegCtl.segmentedControlStyle = UISegmentedControlStyleBar;
    [searchTypeSegCtl addTarget:self action:@selector(searchTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchTypeSegCtl];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, item, flexbleItem, nil];
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        self.searchType = AMapSearchType_PlaceID;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initToolBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self searchPoiWithType:self.searchType];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    
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
