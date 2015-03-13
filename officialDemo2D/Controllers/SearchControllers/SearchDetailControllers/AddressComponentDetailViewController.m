//
//  AddressComponentDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-26.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "AddressComponentDetailViewController.h"
#import "StreetNumberDetailViewController.h"

@interface AddressComponentDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@end

@implementation AddressComponentDetailViewController
@synthesize addressComponent = _addressComponent;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    return self.titleArray[indexPath.row];
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    return self.subTitleArray[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (void)gotoDetailForStreenNumber:(AMapStreetNumber *)streetNumber
{
    if (streetNumber != nil)
    {
        StreetNumberDetailViewController *streetNumberDetailViewController = [[StreetNumberDetailViewController alloc] init];
        
        streetNumberDetailViewController.streetNumber = streetNumber;
        
        [self.navigationController pushViewController:streetNumberDetailViewController animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6)
    {
        [self gotoDetailForStreenNumber:self.addressComponent.streetNumber];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *addressComponentDetailCellIdentifier = @"addressComponentDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressComponentDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:addressComponentDetailCellIdentifier];
    }
    
    if (indexPath.row == 6)
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

- (void)initTableData
{
    self.subTitleArray = @[self.addressComponent.province,
                           [NSString stringWithFormat:@"%@(%@)", self.addressComponent.city, self.addressComponent.citycode],
                           [NSString stringWithFormat:@"%@(%@)", self.addressComponent.district, self.addressComponent.adcode],
                           self.addressComponent.township,
                           self.addressComponent.neighborhood,
                           self.addressComponent.building,
                           [self.addressComponent.streetNumber description]];
    
    self.titleArray = @[@"省", @"市(citiCode)", @"地区(adCode)", @"乡镇", @"社区", @"建筑", @"门牌信息"];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTitle:@"地址组成要素 (AMapAddressComponent)"];
    
    [self initTableView];
    
    [self initTableData];
}

@end
