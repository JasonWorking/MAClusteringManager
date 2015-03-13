//
//  ScreenshotViewController.m
//  Category_demo
//
//  Created by songjian on 13-5-15.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "ScreenshotViewController.h"
#import "ScreenshotDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

#define Tips @"滑动屏幕重新设置截图区域"
#define StartupTitle(enabled) ((enabled) ? (@"Stop") : (@"Start"))

@interface ScreenshotViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) MAPointAnnotation *pointAnnotation;
@property (nonatomic, strong) MACircle *circle;

@property (nonatomic) BOOL started;

@end

@implementation ScreenshotViewController
@synthesize pan        = _pan;
@synthesize shapeLayer = _shapeLayer;
@synthesize started    = _started;

#pragma mark - Utility

- (void)transitionToDetailWithImage:(UIImage *)image
{
    ScreenshotDetailViewController *detailViewController = [[ScreenshotDetailViewController alloc] init];
    detailViewController.screenshotImage = image;
    detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [self presentModalViewController:navi animated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth   = 4;
        circleRenderer.strokeColor = [UIColor blueColor];
        circleRenderer.fillColor   = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        
        return circleRenderer;
    }
    
    return nil;
}

#pragma mark - Handle Action

- (void)captureAction
{
    if (self.shapeLayer.path == NULL)
    {
        return;
    }
    
    CGRect inRect = [self.view convertRect:CGPathGetPathBoundingBox(self.shapeLayer.path)
                                    toView:self.mapView];
    
    UIImage *screenshotImage = [self.mapView takeSnapshotInRect:inRect];
    
    [self transitionToDetailWithImage:screenshotImage];
}

- (void)startupAction
{
    self.started = !self.started;
    
    self.navigationItem.rightBarButtonItem.title = StartupTitle(self.started);
    
    [self.navigationController setToolbarHidden:!self.started animated:YES];
    
    self.mapView.scrollEnabled = !self.started;
    
    self.shapeLayer.hidden = !self.started;
}

#pragma mark - Handle Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.pan == gestureRecognizer)
    {
        return self.started;
    }
    
    return YES;
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    static CGPoint startPoint;
    
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        self.shapeLayer.path = NULL;
        
        startPoint = [panGesture locationInView:self.view];
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentPoint = [panGesture locationInView:self.view];
        CGPathRef path = CGPathCreateWithRect(CGRectMake(startPoint.x, startPoint.y, currentPoint.x - startPoint.x, currentPoint.y - startPoint.y), NULL);
        self.shapeLayer.path = path;
        CGPathRelease(path);
    }
}

#pragma mark - Initialization

- (void)initShapeLayer
{
    self.shapeLayer = [[CAShapeLayer alloc] init];
    self.shapeLayer.lineWidth   = 2;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapeLayer.fillColor   = [[UIColor grayColor] colorWithAlphaComponent:0.3f].CGColor;
    self.shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:5], nil];
    
    CGPathRef path = CGPathCreateWithRect(CGRectInset(self.view.bounds,
                                                      CGRectGetWidth(self.view.bounds)  / 4.f,
                                                      CGRectGetHeight(self.view.bounds) / 4.f),
                                          NULL);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
    [self.view.layer addSublayer:self.shapeLayer];
}

- (void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:StartupTitle(self.started)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(startupAction)];
}

- (void)initToolbar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    /* Create tip label. */
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor       = [UIColor whiteColor];
    tipLabel.text            = Tips;
    [tipLabel sizeToFit];
    
    /* Create tip item. */
    UIBarButtonItem *tipItem = [[UIBarButtonItem alloc] initWithCustomView:tipLabel];
    
    /* Create capture item. */
    UIBarButtonItem *captureItem = [[UIBarButtonItem alloc] initWithTitle:@"Capture"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(captureAction)];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, tipItem, flexbleItem, captureItem, flexbleItem, nil];
}

- (void)initGestureRecognizer
{
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.pan.delegate = self;
    self.pan.maximumNumberOfTouches = 1;
    
    [self.view addGestureRecognizer:self.pan];
}

- (void)initAnnotationAndOverlay
{
    self.pointAnnotation = [[MAPointAnnotation alloc] init];
    self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.911447, 116.406026);
    self.pointAnnotation.title      = @"Why Not!";
    
    self.circle = [MACircle circleWithCenterCoordinate:self.pointAnnotation.coordinate radius:5000];
}

#pragma mark - Override

- (void)returnAction
{
    [super returnAction];
    
    self.mapView.scrollEnabled = YES;
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        [self initAnnotationAndOverlay];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initToolbar];
    
    [self initGestureRecognizer];
    
    [self initShapeLayer];
    
    [self startupAction];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView addAnnotation:self.pointAnnotation];
    [self.mapView addOverlay:self.circle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
}

@end
