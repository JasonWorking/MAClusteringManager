//
//  StepDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "StepDetailViewController.h"

@interface StepDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation StepDetailViewController
@synthesize tableView = _tableView;
@synthesize step = _step;

#pragma mark - Utility

/* 解析路况状态信息. */
- (NSString *)tmcStatusDescriptionForStatus:(NSInteger)status
{
    NSString *des = nil;
    
    switch (status)
    {
        case 1: des = @"畅通"; break;
        case 2: des = @"缓行"; break;
        case 3: des = @"拥堵"; break;
        default:des = @"未知"; break;
    }
    
    return des;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: title = @"行走指示";           break;
            case 1: title = @"方向";              break;
            case 2: title = @"道路名称";           break;
            case 3: title = @"路段长度";           break;
            case 4: title = @"预计耗时";           break;
            case 5: title = @"坐标点串";           break;
            case 6: title = @"导航主要动作";        break;
            case 7: title = @"导航辅助动作";        break;
            case 8: title = @"收费";               break;
            case 9: title = @"收费路段长度";        break;
            default:title = @"主要收费路段";        break;
        }
    }
    else if (indexPath.section == 1)
    {
        AMapCity *city = self.step.cities[indexPath.row];
        title = [NSString stringWithFormat:@"%@(%@)", city.city, city.adcode];
    }
    else
    {
        AMapTMC *tmc = self.step.tmcs[indexPath.row];
        
        NSString *statusStr = [self tmcStatusDescriptionForStatus:tmc.status];
        
        title = [NSString stringWithFormat:@"%ld米 %@", (long)tmc.distance, statusStr];
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    __block NSString *subTitle = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: subTitle = self.step.instruction;   break;
            case 1: subTitle = self.step.orientation;   break;
            case 2: subTitle = self.step.road;          break;
            case 3: subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.step.distance]; break;
            case 4: subTitle = [NSString stringWithFormat:@"%ld(秒)", (long)self.step.duration]; break;
            case 5: subTitle = self.step.polyline;      break;
            case 6: subTitle = self.step.action;        break;
            case 7: subTitle = self.step.assistantAction; break;
            case 8: subTitle = [NSString stringWithFormat:@"%f(元)", self.step.tolls]; break;
            case 9: subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.step.tollDistance]; break;
            default:subTitle = self.step.tollRoad;      break;
        }
    }
    else if (indexPath.section == 1)
    {
        subTitle = @"区域:";
        AMapCity *city = self.step.cities[indexPath.row];
        [city.districts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AMapDistrict *dis = (AMapDistrict *)obj;
            
            subTitle = [NSString stringWithFormat:@"%@-%@", subTitle, dis.name];
        }];
    }
    else
    {
        AMapTMC *tmc = self.step.tmcs[indexPath.row];
        
        subTitle = [@"location code = " stringByAppendingString:tmc.lcode];
    }
    
    return subTitle;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retVal;
    switch (section)
    {
        case 0: retVal = 11;   break;
        case 1: retVal = self.step.cities.count;   break;
        case 2: retVal = self.step.tmcs.count;  break;
    }
    return retVal;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *retVal = nil;
    switch (section)
    {
        case 0: retVal = @"基础信息";   break;
        case 1: retVal = @"途径城市区域";   break;
        case 2: retVal = @"实时路况信息";  break;
    }
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *stepDetailCellIdentifier = @"stepDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stepDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:stepDetailCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Initialization

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
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
    
    [self initTitle:@"导航路段 (AMapStep)"];
    
    [self initTableView];
}

@end
