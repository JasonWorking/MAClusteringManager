 //
//  DeepContentViewController.m
//  OfficialDemo3D
//
//  Created by xiaoming han on 13-11-27.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "DeepContentViewController.h"

#import "DiningDeepViewController.h"
#import "HotelDeepViewController.h"
#import "ScenicDeepViewController.h"
#import "CinemaDeepViewController.h"

@interface DeepContentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@end

@implementation DeepContentViewController
@synthesize deepContent = _deepContent;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    return self.titleArray[indexPath.row];
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    return self.subTitleArray[indexPath.row];
}

- (NSString *)getTypeTitle
{
    NSString *type = nil;
    if ([self.deepContent.type isEqualToString:AMapDeepContentTypeDining])
    {
        type = @"餐饮";
    }
    else if ([self.deepContent.type isEqualToString:AMapDeepContentTypeHotel])
    {
        type = @"酒店";
    }
    else if ([self.deepContent.type isEqualToString:AMapDeepContentTypeScenic])
    {
        type = @"景点";
    }
    else if ([self.deepContent.type isEqualToString:AMapDeepContentTypeCinema])
    {
        type = @"电影";
    }
    return [NSString stringWithFormat:@"%@行业(%@)", type, self.deepContent.type];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle != UITableViewCellSelectionStyleNone)
    {
        UIViewController *detailViewController = nil;
        
        if ([self.deepContent.type isEqualToString:AMapDeepContentTypeDining])
        {
            detailViewController = [[DiningDeepViewController alloc] init];
            ((DiningDeepViewController *)detailViewController).deepDining = self.deepContent.deepDining;
        }
        else if ([self.deepContent.type isEqualToString:AMapDeepContentTypeHotel])
        {
            detailViewController = [[HotelDeepViewController alloc] init];
            ((HotelDeepViewController *)detailViewController).deepHotel = self.deepContent.deepHotel;
        }
        else if ([self.deepContent.type isEqualToString:AMapDeepContentTypeScenic])
        {
            detailViewController = [[ScenicDeepViewController alloc] init];
            ((ScenicDeepViewController *)detailViewController).deepScenic = self.deepContent.deepScenic;
        }
        else if ([self.deepContent.type isEqualToString:AMapDeepContentTypeCinema])
        {
            detailViewController = [[CinemaDeepViewController alloc] init];
            ((CinemaDeepViewController *)detailViewController).deepCinema = self.deepContent.deepCinema;
        }
        
        if (detailViewController)
        {
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    static NSString *cellIdentifier = @"deepContentcellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([cell.detailTextLabel.text isEqualToString:self.deepContent.type])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
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
    self.titleArray = @[@"行业类型", @"简介", @"综合评分", @"信息来源", @"图片信息", @"餐饮行业的深度信息", @"酒店行业的深度信息", @"景点行业的深度信息", @"电影行业的深度信息"];
    
    self.subTitleArray = @[[self getTypeTitle],
                           self.deepContent.intro,
                           [NSString stringWithFormat:@"%.2f", self.deepContent.rating],
                           self.deepContent.provider,
                           [NSString stringWithFormat:@"共 %lu 张图片", (unsigned long)self.deepContent.photos.count],
                           AMapDeepContentTypeDining,
                           AMapDeepContentTypeHotel,
                           AMapDeepContentTypeScenic,
                           AMapDeepContentTypeCinema];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTitle:@"行业深度信息 (AMapDeepContent)"];
    
    [self initTableView];
    
    [self initTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
