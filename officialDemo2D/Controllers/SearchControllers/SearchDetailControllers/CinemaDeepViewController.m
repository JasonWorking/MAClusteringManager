//
//  CinemaDeepViewController.m
//  OfficialDemo3D
//
//  Created by xiaoming han on 13-12-9.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CinemaDeepViewController.h"
#import "MovieInfoViewController.h"

@interface CinemaDeepViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@property (nonatomic, strong) NSMutableArray *movieArray;

@end

@implementation CinemaDeepViewController
@synthesize deepCinema = _deepCinema;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.titleArray[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        return self.movieArray[indexPath.row];
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
        AMapMovie *movie = self.deepCinema.movies[indexPath.row];
        if (movie)
        {
            MovieInfoViewController *detailViewController = [[MovieInfoViewController alloc] init];
            detailViewController.movie = movie;
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
        return self.movieArray.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"基础信息" : @"影片信息";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cinemaDeepCellIdentifier";
    
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
    self.subTitleArray = @[[NSString stringWithFormat:@"%d",
                           self.deepCinema.is3D],
                           self.deepCinema.parking,
                           self.deepCinema.opentimeGDF,
                           self.deepCinema.opentime];
    
    
    self.titleArray = @[@"是否支持3D", @"停车场设施", @"规范格式营业时间", @"非规范格式营业时间"];
}

- (void)initMovieList
{
    self.movieArray = [NSMutableArray array];
    [self.deepCinema.movies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         AMapMovie *movie = (AMapMovie *)obj;
         if (movie)
         {
             [self.movieArray addObject:[NSString stringWithFormat:@"%@(主演：%@)", movie.name, movie.actors]];
         }
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTitle:@"电影行业深度信息 (AMapCinemaDeepContent)"];
    
    [self initTableView];
    
    [self initTableData];
    
    [self initMovieList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
