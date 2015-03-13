//
//  DiningDeepViewController.m
//  OfficialDemo3D
//
//  Created by xiaoming han on 13-12-9.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "DiningDeepViewController.h"

@interface DiningDeepViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;
@end

@implementation DiningDeepViewController
@synthesize deepDining = _deepDining;

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
    static NSString *cellIdentifier = @"diningDeepCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.subTitleArray = @[self.deepDining.cuisines,
                           self.deepDining.tag,
                           [NSString stringWithFormat:@"%.2f", self.deepDining.cpRating],
                           [NSString stringWithFormat:@"%.2f", self.deepDining.tasteRating],
                           [NSString stringWithFormat:@"%.2f", self.deepDining.environmentRating],
                           [NSString stringWithFormat:@"%.2f", self.deepDining.serviceRating],
                           [NSString stringWithFormat:@"%.2f", self.deepDining.cost],
                           self.deepDining.recommend,
                           self.deepDining.atmosphere,
                           self.deepDining.addition,
                           [self.deepDining.appUrl description],
                           self.deepDining.orderingUrlWap,
                           self.deepDining.orderingUrlWeb,
                           self.deepDining.opentimeGDF,
                           self.deepDining.opentime];
    
    self.titleArray = @[@"菜系", @"标签", @"评分", @"口味评分", @"环境评分", @"服务评分", @"人均消费", @"特色菜", @"氛围", @"餐厅特色", @"手机应用网址", @"手机端订餐网址", @"网页端订餐网址", @"规范格式营业时间", @"非规范格式营业时间"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTitle:@"餐饮行业深度信息 (AMapDiningDeepContent)"];
    
    [self initTableView];
    
    [self initTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
