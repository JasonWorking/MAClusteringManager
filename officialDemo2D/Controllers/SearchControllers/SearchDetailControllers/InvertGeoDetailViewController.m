//
//  InvertGeoDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-26.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "InvertGeoDetailViewController.h"
#import "PoiDetailViewController.h"
#import "AddressComponentDetailViewController.h"
#import "RoadDetailViewController.h"
#import "RoadInterDetailViewController.h"

@interface InvertGeoDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation InvertGeoDetailViewController
@synthesize reGeocode = _reGeocode;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            title = @"格式化地址";
        }
        else
        {
            title = @"地址组成要素";
        }
    }
    else if (indexPath.section == 1)
    {
        AMapRoad *road = self.reGeocode.roads[indexPath.row];
        
        title = road.name;
    }
    else if (indexPath.section == 2)
    {   
        AMapRoadInter *roadInter = self.reGeocode.roadinters[indexPath.row];
        
        title = [roadInter description];
    }
    else
    {
        AMapPOI *poi = self.reGeocode.pois[indexPath.row];
        
        title = poi.name;
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            subTitle = self.reGeocode.formattedAddress;
        }
        else
        {
            subTitle = [self.reGeocode.addressComponent description];
        }
    }
    else
    {
        subTitle = nil;
    }
    
    return subTitle;
}

/* 跳转到POI页面. */
- (void)gotoDetailForPOI:(AMapPOI *)poi
{
    if (poi != nil)
    {
        PoiDetailViewController *poiDetailViewController = [[PoiDetailViewController alloc] init];
        
        poiDetailViewController.poi = poi;
        
        [self.navigationController pushViewController:poiDetailViewController animated:YES];
    }
}

/* 跳转到地址组成要素页面. */
- (void)gotoDetailForAddressComponent:(AMapAddressComponent *)addressComponent
{
    if (addressComponent != nil)
    {
        AddressComponentDetailViewController *addressComponentDetailViewController = [[AddressComponentDetailViewController alloc] init];
        
        addressComponentDetailViewController.addressComponent = addressComponent;
        
        [self.navigationController pushViewController:addressComponentDetailViewController animated:YES];
    }
}

/* 跳转到道路页面. */
- (void)gotoDetailForRoad:(AMapRoad *)road
{
    if (road != nil)
    {
        RoadDetailViewController *roadDetailViewController = [[RoadDetailViewController alloc] init];
        
        roadDetailViewController.road = road;
        
        [self.navigationController pushViewController:roadDetailViewController animated:YES];
    }
}

/* 跳转到道路交叉口页面. */
- (void)gotoDetailForRoadInter:(AMapRoadInter *)roadInter
{
    if (roadInter != nil)
    {
        RoadInterDetailViewController *roadInterDetailViewController = [[RoadInterDetailViewController alloc] init];
        
        roadInterDetailViewController.roadInter = roadInter;
        
        [self.navigationController pushViewController:roadInterDetailViewController animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            [self gotoDetailForAddressComponent:self.reGeocode.addressComponent];
        }
    }
    else if (indexPath.section == 1)
    {
        [self gotoDetailForRoad:self.reGeocode.roads[indexPath.row]];
    }
    else if (indexPath.section == 2)
    {
        [self gotoDetailForRoadInter:self.reGeocode.roadinters[indexPath.row                           ]];
    }
    else
    {
        [self gotoDetailForPOI:self.reGeocode.pois[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    
    switch (section)
    {
        case 0: number = 2; break;
        case 1: number = self.reGeocode.roads.count;        break;
        case 2: number = self.reGeocode.roadinters.count;   break;
        default:number = self.reGeocode.pois.count;         break;
    }
    
    return number;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleForHeader = nil;
    
    switch (section)
    {
        case 0: titleForHeader = @"基础信息"; break;
        case 1: titleForHeader = @"道路信息"; break;
        case 2: titleForHeader = @"道路路口信息"; break;
        default:titleForHeader = @"兴趣点信息";   break;
    }
    
    return titleForHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *invertGeoDetailCellIdentifier = @"invertGeoDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:invertGeoDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:invertGeoDetailCellIdentifier];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Initialization

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor whiteColor];
    titleLabel.text             = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTitle:@"逆地理编码 (AMapReGeocode)"];
    
    [self initTableView];
}

@end
