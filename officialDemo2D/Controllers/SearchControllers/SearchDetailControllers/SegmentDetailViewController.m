//
//  SegmentViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "SegmentDetailViewController.h"
#import "WalkingDetailViewController.h"
#import "BusLineDetailViewController.h"

@interface SegmentDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SegmentDetailViewController
@synthesize segment = _segment;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    switch (indexPath.row)
    {
        case 0: title = @"步行导航信息"; break;
        case 1: title = @"公交导航信息"; break;
        case 2: title = @"入口名称";    break;
        case 3: title = @"入口经纬度";  break;
        case 4: title = @"出口名称";    break;
        default:title = @"出口经纬度";  break;
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    switch (indexPath.row)
    {
        case 0: subTitle = nil; break;
        case 1: subTitle = [NSString stringWithFormat:@"%@-->%@", self.segment.busline.departureStop.name , self.segment.busline.arrivalStop.name]; break;
        case 2: subTitle = self.segment.enterName;                   break;
        case 3: subTitle = [self.segment.enterLocation description]; break;
        case 4: subTitle = self.segment.exitName;                    break;
        default:subTitle = [self.segment.exitLocation description];  break;
    }
    
    return subTitle;
}

- (void)gotoDetailForWalking:(AMapWalking *)walking
{
    WalkingDetailViewController *walkingDetailViewController = [[WalkingDetailViewController alloc] init];
    
    walkingDetailViewController.walking = walking;
    
    [self.navigationController pushViewController:walkingDetailViewController animated:YES];
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
    if (indexPath.row == 0)
    {
        [self gotoDetailForWalking:self.segment.walking];
    }
    else if (indexPath.row == 1)
    {
        [self gotoDetailForBusLine:self.segment.busline];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *segmentDetailCellIdentifier = @"segmentDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:segmentDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:segmentDetailCellIdentifier];
    }
    
    if (indexPath.row == 0 || indexPath.row == 1)
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
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
    
    [self initTitle:@"公交换乘路段 (AMapSegment)"];
    
    [self initTableView];
}

@end
