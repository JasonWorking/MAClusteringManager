//
//  RichContentViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "RichContentViewController.h"
#import "GroupBuyDetailViewController.h"

@interface RichContentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RichContentViewController
@synthesize richContent = _richContent;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        AMapGroupBuy *groupBuy = self.richContent.groupbuys[indexPath.row];
        
        title = groupBuy.detail;
    }
    else
    {
        AMapDiscount *discount = self.richContent.discounts[indexPath.row];
        
        title = discount.title;
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    if (indexPath.section == 0)
    {
        AMapGroupBuy *groupBuy = self.richContent.groupbuys[indexPath.row];
        
        subTitle = groupBuy.type;
    }
    else
    {
        AMapDiscount *discount = self.richContent.discounts[indexPath.row];
        subTitle = discount.detail;
    }
    
    return subTitle;
}

- (void)gotoDetailForGroupBuy:(AMapGroupBuy *)groupBuy
{
    if (groupBuy == nil)
    {
        NSLog(@"%s: groupBuy is empty", __func__);
        
        return;
    }
    
    GroupBuyDetailViewController *groupBuyViewController = [[GroupBuyDetailViewController alloc] init];
    groupBuyViewController.groupBuy = groupBuy;
    
    [self.navigationController pushViewController:groupBuyViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self gotoDetailForGroupBuy:self.richContent.groupbuys[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.richContent.groupbuys.count : self.richContent.discounts.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@(%lu个)",
            ((section == 0) ? (@"团购信息") : (@"优惠信息")),
            (unsigned long)((section == 0) ? (self.richContent.groupbuys.count) : (self.richContent.discounts.count))];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"richContentCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    [self initTitle:@"团购与优惠信息 (AMapRichContent)"];
    
    [self initTableView];
}

@end
