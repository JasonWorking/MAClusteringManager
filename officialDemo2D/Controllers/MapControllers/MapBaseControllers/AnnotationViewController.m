//
//  AnnotationViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "AnnotationViewController.h"
#import "MAAnnotationClustering.h"
#import "MAClusterAnnotationView.h"
#import "MAClusterAnimator.h"

enum {
    AnnotationViewControllerAnnotationTypeRed = 0,
    AnnotationViewControllerAnnotationTypeGreen,
    AnnotationViewControllerAnnotationTypePurple
};

@interface AnnotationViewController () < MAClusteringManagerDelegate>

@property (nonatomic, strong) MAClusteringManager *clusteringManager;

@property (nonatomic, strong) MAClusterAnimator *animator;
@end

@implementation AnnotationViewController

#define kNUMBER_OF_LOCATIONS 10000

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _animator = [MAClusterAnimator new];
    
    // Create fake datas.
    NSMutableArray *array = [self randomLocationsWithCount:kNUMBER_OF_LOCATIONS];

    // Create clustering manager
    self.clusteringManager = [[MAClusteringManager alloc] initWithAnnotations:array];
    self.clusteringManager.delegate = self;
    
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(-10.400160,0.633803);
    self.mapView.zoomLevel = self.mapView.minZoomLevel;
    
    //Perform a clustering
    [self mapView:self.mapView regionDidChangeAnimated:NO];
}





#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    // We add a new operation queue to do the clustering
    [[NSOperationQueue new] addOperationWithBlock:^{
        double scale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
        NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:mapView.visibleMapRect withZoomScale:scale];
        
        // The clusteringManager will get the main queue to do the UI stuff.
        [self.clusteringManager displayAnnotations:annotations onMapView:mapView];
    }];
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID";
    static NSString *const ClusterAnnotationReuseID = @"ClusterAnnotationReuseID";
    
    
    if ([annotation isKindOfClass:[MAAnnotationCluster class]]) {
        MAAnnotationCluster *cluster = (MAAnnotationCluster *)annotation;
        cluster.title = [NSString stringWithFormat:@"%zd items",[cluster.annotations count]];
        
        MAClusterAnnotationView *clusterView = (MAClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ClusterAnnotationReuseID];
        if (!clusterView) {
            clusterView = [[MAClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ClusterAnnotationReuseID];
            clusterView.canShowCallout = YES;
            clusterView.clusterColor = (arc4random()%10)/2 == 0 ? [UIColor colorWithRed: 0.021 green: 0.422 blue: 0.884 alpha: 1] : [UIColor colorWithRed:255.0/255.0 green:95/255.0 blue:42/255.0 alpha:1.0];
        }
        
        clusterView.count = [((MAAnnotationCluster *)annotation).annotations count];
        return clusterView;
        
    }else {
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
        
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotatioViewReuseID];
        }
        annotationView.pinColor = MAPinAnnotationColorRed;
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }

    
}



- (void)mapView:(MAMapView *)mapView
 annotationView:(MAAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"view :%@", view);
}

- (void)mapView:(MAMapView *)mapView
didAddAnnotationViews:(NSArray *)views
{
    
    __weak __typeof(self) weakSelf = self;
    [views  enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        __strong   __typeof(weakSelf) strongSelf = weakSelf;
        if ([obj isKindOfClass:[MAClusterAnnotationView class]]) {
            [strongSelf.animator addAnimationToView:obj];
        }
    }];
}


#pragma mark -  MAClusteringManagerDelegate

- (CGFloat)cellSizeFactorForCoordinator:(MAClusteringManager *)coordinator
{
    return 0.5;
}



#pragma mark - Utility

- (NSMutableArray *)randomLocationsWithCount:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        MAPointAnnotation *a = [[MAPointAnnotation alloc] init];
        a.coordinate = CLLocationCoordinate2DMake(drand48() * 40 - 20, drand48() * 80 - 40);
        [array addObject:a];
    }
    return array;
}



@end
