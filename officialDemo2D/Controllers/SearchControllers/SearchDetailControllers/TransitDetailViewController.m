//
//  TransitDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "TransitDetailViewController.h"
#import "SegmentDetailViewController.h"

@interface TransitDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TransitDetailViewController
@synthesize transit = _transit;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: title = @"方案价格";    break;
            case 1: title = @"预期时间";    break;
            case 2: title = @"是否是夜班车"; break;
            default:title = @"总步行距离";   break;
        }
    }
    else
    {
        AMapSegment *segment = self.transit.segments[indexPath.row];
        
        AMapBusLine *busline = segment.busline;
        
        if (busline != nil)
        {
            title = [NSString stringWithFormat:@"%@-->%@", busline.departureStop.name, busline.arrivalStop.name];
        }
        else
        {
            title = @"步行";
        }
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
            case 0: subTitle = [NSString stringWithFormat:@"%f(元)", self.transit.cost];     break;
            case 1: subTitle = [NSString stringWithFormat:@"%ld(秒)", (long)self.transit.duration]; break;
            case 2: subTitle = [NSString stringWithFormat:@"%@", self.transit.nightflag ? @"YES" : @"NO"]; break;
            default:subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.transit.walkingDistance]; break;
        }
    }
    else
    {
        
        subTitle = nil;
    }
    
    return subTitle;
}

- (void)gotoDetailForSegment:(AMapSegment *)segment
{
    SegmentDetailViewController *segmentDetailViewController = [[SegmentDetailViewController alloc] init];
    
    segmentDetailViewController.segment = segment;
    
    [self.navigationController pushViewController:segmentDetailViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self gotoDetailForSegment:self.transit.segments[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 4 : self.transit.segments.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? @"基础信息" : @"换乘路段";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *transitDetailCellIdentifier = @"transitDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:transitDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:transitDetailCellIdentifier];
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
    
    [self initTitle:@"公交方案 (AMapTransit)"];
    
    [self initTableView];
}

@end
