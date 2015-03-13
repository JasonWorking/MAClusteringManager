//
//  HotelDeepViewController.m
//  OfficialDemo3D
//
//  Created by xiaoming han on 13-12-9.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "HotelDeepViewController.h"
#import "RoomInfoViewController.h"

@interface HotelDeepViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@property (nonatomic, strong) NSMutableArray *roomArray;

@end

@implementation HotelDeepViewController
@synthesize deepHotel = _deepHotel;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.titleArray[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        return self.roomArray[indexPath.row];
    }
    return nil;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.subTitleArray[indexPath.row];
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        AMapRoom *room = self.deepHotel.rooms[indexPath.row];
        if (room)
        {
            RoomInfoViewController *detailViewController = [[RoomInfoViewController alloc] init];
            detailViewController.room = room;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }

    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.titleArray.count;
    }
    else if (section == 1)
    {
        return self.roomArray.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"基础信息" : @"房型信息";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"hotelDeepCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 1)
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
    self.subTitleArray = @[[NSString stringWithFormat:@"%ld", (long)self.deepHotel.star],
                           [NSString stringWithFormat:@"%.2f", self.deepHotel.lowestPrice],
                           [NSString stringWithFormat:@"%.2f", self.deepHotel.faciRating],
                           [NSString stringWithFormat:@"%.2f", self.deepHotel.healthRating],
                           [NSString stringWithFormat:@"%.2f", self.deepHotel.environmentRating],
                           [NSString stringWithFormat:@"%.2f", self.deepHotel.serviceRating],
                           self.deepHotel.traffic,
                           self.deepHotel.addition];
    
    self.titleArray = @[@"星级", @"最低价", @"设施评分", @"卫生评分", @"环境评分", @"服务评分", @"交通提示", @"特色服务"];
}

- (void)initRoomList
{
    self.roomArray = [NSMutableArray array];
    [self.deepHotel.rooms enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        AMapRoom *room = (AMapRoom *)obj;
        if (room)
        {
            [self.roomArray addObject:[NSString stringWithFormat:@"%@(%.2f元)", room.name, room.price]];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTitle:@"酒店行业深度信息 (AMapHotelDeepContent)"];
    
    [self initTableView];
    
    [self initTableData];
    
    [self initRoomList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
