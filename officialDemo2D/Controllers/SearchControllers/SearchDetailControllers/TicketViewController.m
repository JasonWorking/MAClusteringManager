//
//  TicketViewController.m
//  OfficialDemo3D
//
//  Created by xiaoming han on 13-12-9.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "TicketViewController.h"

@interface TicketViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@end

@implementation TicketViewController
@synthesize ticket = _ticket;

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
    static NSString *cellIdentifier = @"ticketCellIdentifier";
    
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
    self.subTitleArray = @[self.ticket.startTime,
                           self.ticket.screen,
                           self.ticket.lang,
                           [NSString stringWithFormat:@"%.2f元", self.ticket.price],
                           [NSString stringWithFormat:@"%d", self.ticket.seatOrdering],
                           self.ticket.orderingUrlWap,
                           self.ticket.orderingUrlWeb];
    
    self.titleArray = @[@"放映时间", @"屏幕信息", @"语言", @"价格", @"是否可选座", @"手机端选座网址", @"网页版选座网址"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTitle:@"场次信息 (AMapTicket)"];
    
    [self initTableView];
    
    [self initTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
