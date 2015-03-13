//
//  TrafficViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "TrafficViewController.h"

@implementation TrafficViewController

#pragma mark - Action Handle

- (void)trafficAction:(UISwitch *)switcher
{
    self.mapView.showTraffic = switcher.on;
}

#pragma mark - Initialization

- (void)initNavigationBar
{
    UISwitch *trafficSwitch = [[UISwitch alloc] init];
    [trafficSwitch addTarget:self action:@selector(trafficAction:) forControlEvents:UIControlEventValueChanged];
    trafficSwitch.on = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:trafficSwitch];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.showTraffic = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /* Reset traffic. */
    self.mapView.showTraffic = NO;
}

@end
