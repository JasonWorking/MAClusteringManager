//
//  AddGestureViewController.m
//  OfficialDemo3D
//
//  Created by songjian on 13-10-31.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "AddGestureViewController.h"

@interface AddGestureViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@property (nonatomic, strong) UILabel *tip;

@end

@implementation AddGestureViewController
@synthesize singleTap = _singleTap;
@synthesize doubleTap = _doubleTap;

@synthesize tip       = _tip;

#pragma mark - Utility

- (void)showLabelWithText:(NSString *)text atPoint:(CGPoint)centerPoint
{
    if (self.tip == nil)
    {
        self.tip = [[UILabel alloc] init];
        self.tip.backgroundColor = [UIColor clearColor];
        self.tip.textColor       = [UIColor redColor];
        self.tip.font            = [UIFont systemFontOfSize:80];
        
        [self.view addSubview:self.tip];
    }
    
    self.tip.text   = text;
    [self.tip sizeToFit];
    self.tip.alpha  = 1.f;
    self.tip.center = centerPoint;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.singleTap && ([touch.view isKindOfClass:[UIControl class]] || [touch.view isKindOfClass:[MAAnnotationView class]]))
    {
        return NO;
    }
    
    if (gestureRecognizer == self.doubleTap && [touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - Handle Gestures

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{
	[self showLabelWithText:@"Tap" atPoint:[theSingleTap locationInView:self.view]];
	
	[UIView animateWithDuration:0.5 animations:^{
        self.tip.alpha = 0.0;
    }];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap
{
	[self showLabelWithText:@"2Tap" atPoint:[theDoubleTap locationInView:self.view]];
	
	[UIView animateWithDuration:0.5 animations:^{
        self.tip.alpha = 0.0;
    }];
}

#pragma mark - Initialization

- (void)setupGestures
{
    // 需要额外添加一个双击手势，以避免当执行mapView的双击动作时响应两次单击手势。
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.doubleTap.delegate = self;
    self.doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:self.doubleTap];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.singleTap.delegate = self;
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    [self.view addGestureRecognizer:self.singleTap];
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupGestures];
}

@end
