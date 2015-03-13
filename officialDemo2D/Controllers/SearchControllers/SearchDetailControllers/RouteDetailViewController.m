//
//  RouteDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-19.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "RouteDetailViewController.h"
#import "PathDetailViewController.h"
#import "TransitDetailViewController.h"

@interface RouteDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RouteDetailViewController
@synthesize tableView   = _tableView;
@synthesize route       = _route;
@synthesize searchType  = _searchType;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: title = @"起点坐标";  break;
            case 1: title = @"终点坐标";  break;
            default:title = @"出租车费用"; break;
        }
    }
    else
    {
        title = [NSString stringWithFormat:@"方案 %ld", (long)indexPath.row];
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: subTitle = [self.route.origin description];      break;
            case 1: subTitle = [self.route.destination description]; break;
            default:subTitle = [NSString stringWithFormat:@"%f(元)", self.route.taxiCost]; break;
        }
    }
    else
    {
        subTitle = nil;
    }
    
    return subTitle;
}

- (void)gotoDetailForPath:(AMapPath *)path
{
    PathDetailViewController *pathDetailViewController = [[PathDetailViewController alloc] init];
    pathDetailViewController.path = path;
    
    [self.navigationController pushViewController:pathDetailViewController animated:YES];
}

- (void)gotoDetailForTransit:(AMapTransit *)transit
{
    TransitDetailViewController *transitDetailViewController = [[TransitDetailViewController alloc] init];
    transitDetailViewController.transit = transit;
    
    [self.navigationController pushViewController:transitDetailViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        /* 公交换乘方案. */
        if (self.searchType == AMapSearchType_NaviBus)
        {
            [self gotoDetailForTransit:self.route.transits[indexPath.row]];
        }
        /* 步行, 驾车方案. */
        else
        {
            [self gotoDetailForPath:self.route.paths[indexPath.row]];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else
    {
        /* 公交换乘方案. */
        if (self.searchType == AMapSearchType_NaviBus)
        {
            return self.route.transits.count;
        }
        /* 步行, 驾车方案. */
        else
        {
            return self.route.paths.count;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"基础信息";
    }
    else
    {
        /* 公交换乘方案. */
        if (self.searchType == AMapSearchType_NaviBus)
        {
            return @"公交 路线方案列表";
        }
        /* 步行, 驾车方案. */
        else
        {
            return @"步行/驾车 路线方案列表";
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *routeDetailCellIdentifier = @"routeDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:routeDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:routeDetailCellIdentifier];
    }
    
    if (indexPath.section == 0)
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

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTitle:@"导航方案 (AMapRoute)"];
    
    [self initTableView];
}

@end
