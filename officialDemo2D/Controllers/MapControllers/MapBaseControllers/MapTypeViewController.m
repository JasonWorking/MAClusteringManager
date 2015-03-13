//
//  MapTypeViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "MapTypeViewController.h"

@implementation MapTypeViewController

#pragma mark - Action Handlers

- (void)mapTypeAction:(UISegmentedControl *)segmentedControl
{
    self.mapView.mapType = segmentedControl.selectedSegmentIndex;
}

#pragma mark - Initialization

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    UISegmentedControl *mapTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:
                                                   [NSArray arrayWithObjects:
                                                    @"标准(Standard)",
                                                    @"卫星(Satellite)",
                                                    nil]];
    mapTypeSegmentedControl.selectedSegmentIndex  = self.mapView.mapType;
    mapTypeSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [mapTypeSegmentedControl addTarget:self action:@selector(mapTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *mayTypeItem = [[UIBarButtonItem alloc] initWithCustomView:mapTypeSegmentedControl];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, mayTypeItem, flexbleItem, nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.mapView.mapType = MAMapTypeStandard;
}

@end
