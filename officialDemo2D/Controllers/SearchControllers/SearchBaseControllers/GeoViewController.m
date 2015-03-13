//
//  GeoViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "GeoViewController.h"
#import "GeoDetailViewController.h"
#import "CommonUtility.h"
#import "GeocodeAnnotation.h"

#define GeoPlaceHolder @"名称"

@interface GeoViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;

@property (nonatomic, strong) NSMutableArray *tips;

@end

@implementation GeoViewController
@synthesize tips = _tips;
@synthesize searchBar = _searchBar;
@synthesize displayController = _displayController;

#pragma mark - Utility

/* 地理编码 搜索. */
- (void)searchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    
    if (adcode.length > 0)
    {
        geo.city = @[adcode];
    }
    
    [self.search AMapGeocodeSearch:geo];
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    [self.search AMapInputTipsSearch:tips];
}

/* 清除annotation. */
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)clearAndSearchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    /* 清除annotation. */
    [self clear];
    
    [self searchGeocodeWithKey:key adcode:adcode];
}

- (void)gotoDetailForGeocode:(AMapGeocode *)geocode
{
    if (geocode != nil)
    {
        GeoDetailViewController *geoDetailViewController = [[GeoDetailViewController alloc] init];
        geoDetailViewController.geocode = geocode;
        
        [self.navigationController pushViewController:geoDetailViewController animated:YES];
    }
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        [self gotoDetailForGeocode:[(GeocodeAnnotation*)view.annotation geocode]];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        static NSString *geoCellIdentifier = @"geoCellIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:geoCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:geoCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 地理编码回调.*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        
        [annotations addObject:geocodeAnnotation];
    }];
    
    if (annotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[annotations[0] coordinate] animated:YES];
    }
    else
    {
        [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:annotations]
                               animated:YES];
    }
    
    [self.mapView addAnnotations:annotations];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    
    [self.displayController.searchResultsTableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    
    [self clearAndSearchGeocodeWithKey:key adcode:nil];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = key;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchTipsWithKey:searchString];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.adcode;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *tip = self.tips[indexPath.row];
    
    [self clearAndSearchGeocodeWithKey:tip.name adcode:tip.adcode];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = tip.name;
}

#pragma mark - Initialization

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    self.searchBar.barStyle     = UIBarStyleBlack;
    self.searchBar.translucent  = YES;
	self.searchBar.delegate     = self;
    self.searchBar.placeholder  = GeoPlaceHolder;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:self.searchBar];
}

- (void)initSearchDisplay
{
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.delegate                = self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate   = self;
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSearchBar];
    
    [self initSearchDisplay];
}

@end
