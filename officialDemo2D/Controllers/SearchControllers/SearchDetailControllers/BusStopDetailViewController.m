//
//  BusStopDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BusStopDetailViewController.h"
#import "BusLineDetailViewController.h"

@interface BusStopDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BusStopDetailViewController
@synthesize busStop = _busStop;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: title = @"公交站ID";   break;
            case 1: title = @"站名";       break;
            case 2: title = @"公交站序号";  break;
            case 3: title = @"城市编码";    break;
            case 4: title = @"区域编码";    break;
            case 5: title = @"地理格ID";    break;
            case 6: title = @"经纬度";      break;
            default:title = @"时间戳";      break;
        }
    }
    else
    {
        AMapBusLine *busLine = self.busStop.buslines[indexPath.row];
        
        title = busLine.name;
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
            case 0: subTitle = self.busStop.uid;    break;
            case 1: subTitle = self.busStop.name;   break;
            case 2: subTitle = [NSString stringWithFormat:@"%ld", (long)self.busStop.sequence]; break;
            case 3: subTitle = self.busStop.citycode;        break;
            case 4: subTitle = self.busStop.adcode;          break;
            case 5: subTitle = TemporaryNotOpened;        break;
            case 6: subTitle = [self.busStop.location description]; break;
            default:subTitle = TemporaryNotOpened;       break;
        }
    }
    else
    {
        subTitle = nil;
    }
    
    return subTitle;
}

- (void)gotoDetailForBusLine:(AMapBusLine *)busLine
{
    BusLineDetailViewController *busLineDetailViewController = [[BusLineDetailViewController alloc] init];
    
    busLineDetailViewController.busLine = busLine;
    
    [self.navigationController pushViewController:busLineDetailViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self gotoDetailForBusLine:self.busStop.buslines[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 8 : self.busStop.buslines.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? @"基础信息" : @"途径此站的公交路线";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *busStopDetailCellIdentifier = @"busStopDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busStopDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:busStopDetailCellIdentifier];
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
    
    [self initTitle:@"公交站 (AMapBusStop)"];
    
    [self initTableView];
}

@end
