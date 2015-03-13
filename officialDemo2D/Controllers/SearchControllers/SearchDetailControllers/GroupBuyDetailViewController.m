//
//  GroupBuyDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "GroupBuyDetailViewController.h"

@interface GroupBuyDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GroupBuyDetailViewController
@synthesize groupBuy  = _groupBuy;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    switch (indexPath.row)
    {
        case 0   : title = @"团购分类代码";        break;
        case 1   : title = @"团购分类";           break;
        case 2   : title = @"团购详情";           break;
        case 3   : title = @"团购开始时间";        break;
        case 4   : title = @"团购结束时间";        break;
        case 5   : title = @"团购总量";           break;
        case 6   : title = @"已卖出数量";         break;
        case 7   : title = @"原价";              break;
        case 8   : title = @"团购价";            break;
        case 9   : title = @"折扣";              break;
        case 10  : title = @"取票地址";           break;
        case 11  : title = @"取票电话";           break;
        case 12  : title = @"图片信息";           break;
        case 13  : title = @"来源URL";           break;
        default  : title = @"来源标识";           break;
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    switch (indexPath.row)
    {
        case 0  : subTitle = self.groupBuy.typeCode;       break;
        case 1  : subTitle = self.groupBuy.type;           break;
        case 2  : subTitle = self.groupBuy.detail;         break;
        case 3  : subTitle = self.groupBuy.startTime;      break;
        case 4  : subTitle = self.groupBuy.endTime;        break;
        case 5  : subTitle = [NSString stringWithFormat:@"%ld", (long)self.groupBuy.num];              break;
        case 6  : subTitle = [NSString stringWithFormat:@"%ld", (long)self.groupBuy.soldNum];          break;
        case 7  : subTitle = [NSString stringWithFormat:@"%f", self.groupBuy.originalPrice];    break;
        case 8  : subTitle = [NSString stringWithFormat:@"%f", self.groupBuy.groupbuyPrice];    break;
        case 9  : subTitle = [NSString stringWithFormat:@"%f", self.groupBuy.discount];         break;
        case 10 : subTitle = self.groupBuy.ticketAddress;   break;
        case 11 : subTitle = self.groupBuy.ticketTel;       break;
        case 12 : subTitle = [NSString stringWithFormat:@"%lu张图", (unsigned long)self.groupBuy.photos.count];                     break;
        case 13 : subTitle = self.groupBuy.url;             break;
        default : subTitle = self.groupBuy.provider;        break;
    }
    
    return subTitle;
}

- (void)gotoDetailForURLString:(NSString *)urlString
{
    if (urlString.length == 0)
    {
        NSLog(@"%s: urlString is empty", __func__);
        
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:URL])
    {
        [[UIApplication sharedApplication] openURL:URL];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *groupBuyCellIdentifier = @"groupBuyCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:groupBuyCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:groupBuyCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Handle Action

- (void)htmlInforAction
{
    [self gotoDetailForURLString:self.groupBuy.url];
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

- (void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"网页信息"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(htmlInforAction)];
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
    
    [self initTitle:@"团购信息 (AMapGroupBuy)"];
    
    [self initTableView];
    
    [self initNavigationBar];
}

@end
