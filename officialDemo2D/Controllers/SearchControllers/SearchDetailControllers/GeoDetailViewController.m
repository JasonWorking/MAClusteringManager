//
//  GeoDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-23.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "GeoDetailViewController.h"

@interface GeoDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GeoDetailViewController
@synthesize tableView = _tableView;
@synthesize geocode = _geocode;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    switch (indexPath.row)
    {
        case 0: title = @"格式化地址";  break;
        case 1: title = @"所在省";     break;
        case 2: title = @"城市名";     break;
        case 3: title = @"区域名称";   break;
        case 4: title = @"所在乡镇";   break;
        case 5: title = @"社区";      break;
        case 6: title = @"楼";        break;
        case 7: title = @"区域编码";   break;
        case 8: title = @"坐标点";     break;
        default:title = @"匹配的等级";  break;
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    switch (indexPath.row)
    {
        case 0: subTitle = self.geocode.formattedAddress;   break;
        case 1: subTitle = self.geocode.province;           break;
        case 2: subTitle = self.geocode.city;               break;
        case 3: subTitle = self.geocode.district;           break;
        case 4: subTitle = self.geocode.township;           break;
        case 5: subTitle = self.geocode.neighborhood;       break;
        case 6: subTitle = self.geocode.building;           break;
        case 7: subTitle = self.geocode.adcode;             break;
        case 8: subTitle = [self.geocode.location description]; break;
        default:subTitle = [self.geocode.level componentsJoinedByString:@","]; break;
    }
    
    return subTitle;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *geoDetailCellIdentifier = @"geoDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:geoDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:geoDetailCellIdentifier];
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
    
    [self initTitle:@"地理编码 (AMapGeocode)"];
    
    [self initTableView];
}

@end
