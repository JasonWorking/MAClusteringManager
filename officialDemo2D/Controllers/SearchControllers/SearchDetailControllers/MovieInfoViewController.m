//
//  MovieInfoViewController.m
//  OfficialDemo3D
//
//  Created by xiaoming han on 13-12-9.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "MovieInfoViewController.h"
#import "TicketViewController.h"

@interface MovieInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@property (nonatomic, strong) NSMutableArray *ticketArray;

@end

@implementation MovieInfoViewController
@synthesize movie = _movie;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.titleArray[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        return self.ticketArray[indexPath.row];
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
        AMapTicket *ticket = self.movie.tickets[indexPath.row];
        if (ticket)
        {
            TicketViewController *detailViewController = [[TicketViewController alloc] init];
            detailViewController.ticket = ticket;
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
        return self.ticketArray.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"基础信息" : @"场次信息";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"movieInfoCellIdentifier";
    
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
    self.titleArray = @[@"影片名称", @"影片id", @"演员", @"导演", @"类型", @"片长"];
    
    self.subTitleArray = @[self.movie.name,
                           self.movie.uid,
                           self.movie.actors,
                           self.movie.director,
                           self.movie.type,
                           [NSString stringWithFormat:@"%ld 分钟", (long)self.movie.length]];

}

- (void)initTicketList
{
    self.ticketArray = [NSMutableArray array];
    [self.movie.tickets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         AMapTicket *ticket = (AMapTicket *)obj;
         if (ticket)
         {
             [self.ticketArray addObject:[NSString stringWithFormat:@"放映时间:%@", ticket.startTime]];
         }
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTitle:@"电影信息 (AMapMovie)"];
    
    [self initTableView];
    
    [self initTableData];
    
    [self initTicketList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

