//
//  BizExtenViewController.m
//  OfficialDemo3D
//
//  Created by xiaoming han on 13-12-9.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BizExtenViewController.h"

@interface BizExtenViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@end

@implementation BizExtenViewController

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *poiDetailCellIdentifier = @"bizExtentionCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:poiDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:poiDetailCellIdentifier];
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

- (void)initTableData
{
    self.titleArray = @[@"评分", @"人均消费", @"最低价格", @"酒店星级", @"是否可订餐", @"是否可选座", @"是否可订票", @"是否有团购", @"是否有优惠"];
    
    self.subTitleArray = @[[NSString stringWithFormat:@"%.2f", self.extention.rating],
                           [NSString stringWithFormat:@"%.2f", self.extention.cost],
                           [NSString stringWithFormat:@"%.2f", self.extention.lowestPriceForHotel],
                           [NSString stringWithFormat:@"%lu", (unsigned long)self.extention.starForHotel],
                           [NSString stringWithFormat:@"%d", self.extention.mealOrderingForDining],
                           [NSString stringWithFormat:@"%d", self.extention.seatOrderingForCinema],
                           [NSString stringWithFormat:@"%d", self.extention.ticketOrderingForScenic],
                           [NSString stringWithFormat:@"%d", self.extention.hasGroupbuy],
                           [NSString stringWithFormat:@"%d", self.extention.hasDiscount]];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTitle:@"扩展信息 (AMapBizExtention)"];
    
    [self initTableView];
    
    [self initTableData];
}

@end
