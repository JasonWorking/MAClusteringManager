//
//  RoadDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-26.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "RoadDetailViewController.h"

@interface RoadDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RoadDetailViewController
@synthesize road = _road;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    switch (indexPath.row)
    {
        case 0: title = @"道路ID";   break;
        case 1: title = @"道路名称";  break;
        case 2: title = @"距离";     break;
        case 3: title = @"方向";     break;
        case 4: title = @"坐标点";    break;
        case 5: title = @"城市编码";  break;
        case 6: title = @"道路宽度";  break;
        default:title = @"道路分类";  break;
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    switch (indexPath.row)
    {
        case 0: subTitle = self.road.uid;    break;
        case 1: subTitle = self.road.name;   break;
        case 2: subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.road.distance]; break;
        case 3: subTitle = self.road.direction; break;
        case 4: subTitle = [self.road.location description]; break;
        case 5: subTitle = self.road.citycode; break;
        case 6: subTitle = self.road.width;    break;
        default:subTitle = self.road.type;     break;
    }
    
    return subTitle;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *roadDetailCellIdentifier = @"roadDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:roadDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:roadDetailCellIdentifier];
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
    
    [self initTitle:@"道路 (AMapRoad)"];
    
    [self initTableView];
}

@end
