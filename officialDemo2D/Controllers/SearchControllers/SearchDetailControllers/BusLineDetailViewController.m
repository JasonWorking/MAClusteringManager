//
//  BusLineDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BusLineDetailViewController.h"
#import "BusStopDetailViewController.h"

@interface BusLineDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BusLineDetailViewController
@synthesize busLine = _busLine;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: title = @"公交线路ID"; break;
            case 1: title = @"线路名称";   break;
            case 2: title = @"公交类型";   break;
            case 3: title = @"坐标串";     break;
            case 4: title = @"城市编码";   break;
            case 5: title = @"地理格ID";   break;
            case 6: title = @"首发站";     break;
            default:title = @"终点站";     break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0: title = @"首班车时间";   break;
            case 1: title = @"末班车时间";   break;
            case 2: title = @"所属公交公司"; break;
            case 3: title = @"全程里程";     break;
            case 4: title = @"预计行驶时间"; break;
            case 5: title = @"起步价";      break;
            case 6: title = @"全程票价";    break;
            case 7: title = @"矩形区域";     break;
            case 8: title = @"途径公交站数";  break;
            case 9: title = @"起程站";       break;
            default:title = @"下车站";       break;
        }
    }
    else
    {
        AMapBusStop *busStop = self.busLine.busStops[indexPath.row];
        
        title = busStop.name;
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
            case 0: subTitle = self.busLine.uid;            break;
            case 1: subTitle = self.busLine.name;           break;
            case 2: subTitle = self.busLine.type;           break;
            case 3: subTitle = self.busLine.polyline;       break;
            case 4: subTitle = self.busLine.citycode;       break;
            case 5: subTitle = TemporaryNotOpened;          break;
            case 6: subTitle = self.busLine.startStop.name; break;
            default:subTitle = self.busLine.endStop.name;   break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0: subTitle = self.busLine.startTime;      break;
            case 1: subTitle = self.busLine.endTime;        break;
            case 2: subTitle = self.busLine.company;        break;
            case 3: subTitle = [NSString stringWithFormat:@"%f(千米)", self.busLine.distance]; break;
            case 4: subTitle = [NSString stringWithFormat:@"%ld(秒)", (long)self.busLine.duration];   break;
            case 5: subTitle = [NSString stringWithFormat:@"%f(元)", self.busLine.basicPrice]; break;
            case 6: subTitle = [NSString stringWithFormat:@"%f(元)", self.busLine.totalPrice]; break;
            case 7: subTitle = [self.busLine.bounds description];                              break;
            case 8: subTitle = [NSString stringWithFormat:@"%ld", (long)self.busLine.busStopsNum];    break;
            case 9: subTitle = self.busLine.departureStop.name;                                break;
            default:subTitle = self.busLine.arrivalStop.name;                                  break;
        }
    }
    else
    {
        subTitle = nil;
    }
    
    return subTitle;
}

- (void)gotoDetailForBusStop:(AMapBusStop *)busStop
{
    BusStopDetailViewController *busStopDetailViewController = [[BusStopDetailViewController alloc] init];
    
    busStopDetailViewController.busStop = busStop;
    
    [self.navigationController pushViewController:busStopDetailViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapBusStop *busStop = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 6)
        {
            busStop = self.busLine.startStop;
        }
        else if (indexPath.row == 7)
        {
            busStop = self.busLine.endStop;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 9)
        {
            busStop = self.busLine.departureStop;
        }
        else if (indexPath.row == 10)
        {
            busStop = self.busLine.arrivalStop;
        }
    }
    else
    {
        busStop = self.busLine.busStops[indexPath.row];
    }
    
    if (busStop != nil)
    {
        [self gotoDetailForBusStop:busStop];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 8;
    }
    else if (section == 1)
    {
        return 11;
    }
    else
    {
        return self.busLine.busStops.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"基础信息";
    }
    else if (section == 1)
    {
        return @"扩展信息";
    }
    else
    {
        return @"途径公交站";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *busLineDetailCellIdentifier = @"busLineDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busLineDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:busLineDetailCellIdentifier];
    }
    
    if (indexPath.section == 2 ||
        (indexPath.section == 0 && (indexPath.row == 6 || indexPath.row == 7)) ||
        (indexPath.section == 1 && (indexPath.row == 9 || indexPath.row == 10)))
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
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
	
    [self initTitle:@"公交线路 (AMapBusLine)"];
    
    [self initTableView];
}

@end
