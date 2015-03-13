//
//  RoadInterDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-26.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "RoadInterDetailViewController.h"

@interface RoadInterDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RoadInterDetailViewController
@synthesize roadInter = _roadInter;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    switch (indexPath.row)
    {
        case 0: title = @"距离";          break;
        case 1: title = @"方向";          break;
        case 2: title = @"坐标点";        break;
        case 3: title = @"第一条道路ID";   break;
        case 4: title = @"第一条道路名称";  break;
        case 5: title = @"第二条道路ID";   break;
        default:title = @"第二条道路名称";  break;
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    switch (indexPath.row)
    {
        case 0: subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.roadInter.distance]; break;
        case 1: subTitle = self.roadInter.direction;   break;
        case 2: subTitle = [self.roadInter.location description]; break;
        case 3: subTitle = self.roadInter.firstId;      break;
        case 4: subTitle = self.roadInter.firstName;    break;
        case 5: subTitle = self.roadInter.secondId;     break;
        default:subTitle = self.roadInter.secondName;   break;
    }
    
    return subTitle;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *roadInterDetailCellIdentifier = @"roadInterDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:roadInterDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:roadInterDetailCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [self initTitle:@"道路交叉口 (AMapRoadinter)"];
    
    [self initTableView];
}

@end
