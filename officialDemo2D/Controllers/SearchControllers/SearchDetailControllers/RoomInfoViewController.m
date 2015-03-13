//
//  RoomInfoViewController.m
//  OfficialDemo3D
//
//  Created by xiaoming han on 13-12-9.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "RoomInfoViewController.h"

@interface RoomInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@end

@implementation RoomInfoViewController
@synthesize room = _room;

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
    static NSString *cellIdentifier = @"roomInfoCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Initialization

- (void)initRoomData
{
    self.titleArray = @[@"客房id", @"房型类别", @"房型名称", @"房价", @"早餐供应", @"提供网络", @"是否需要预订担保", @"预订电话", @"手机端预定网址", @"网页版预定网址", @"房型价格来源"];
    
    self.subTitleArray = @[self.room.uid,
                           self.room.type,
                           self.room.name,
                           [NSString stringWithFormat:@"%.2f", self.room.price],
                           self.room.breakfast,
                           self.room.network,
                           [NSString stringWithFormat:@"%d", self.room.guarantee],
                           self.room.tel,
                           self.room.orderingUrlWap,
                           self.room.orderingUrlWeb,
                           self.room.provider];
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTitle:[NSString stringWithFormat:@"%@-%@", self.room.uid, self.room.name]];
    
    [self initRoomData];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
