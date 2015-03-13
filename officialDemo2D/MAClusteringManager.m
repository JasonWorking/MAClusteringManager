//
//  MAClusteringManager.m
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/11.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "MAClusteringManager.h"
#import "GTQuadTree.h"


#pragma mark - Utility functions

NS_INLINE NSInteger MAZoomScaleToZoomLevel(MAZoomScale scale)
{
    double totalTilesAtMaxZoom = MAMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));
    
    return zoomLevel;
}

NS_INLINE CGFloat MACellSizeForZoomScale(MAZoomScale zoomScale)
{
    NSInteger zoomLevel = MAZoomScaleToZoomLevel(zoomScale);
    
    switch (zoomLevel) {
        case 13:
        case 14:
        case 15:
            return 64;
        case 16:
        case 17:
        case 18:
            return 32;
        case 19:
            return 16;
            
        default:
            return 88;
    }
}

#pragma mark - MAClusteringManager

static NSString * const kMAClusteringManagerLockName = @"com.tumblr.ihey-jason.recursiveLock";

@interface MAClusteringManager ()

@property (nonatomic, strong) GTQuadTree *tree;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation MAClusteringManager

- (instancetype)init
{
    return [self initWithAnnotations:nil];
}

- (instancetype)initWithAnnotations:(NSArray *)annotations
{
    self = [super init];
    if (self) {
        [self addAnnotations:annotations];
        _lock = [NSRecursiveLock new];
        _lock.name = kMAClusteringManagerLockName;
    }
    return self;
}

- (void)setAnnotations:(NSArray *)annotations
{
    self.tree = nil;
    [self addAnnotations:annotations];
}


- (void)addAnnotations:(NSArray *)annotations
{
    if (!self.tree) {
        self.tree = [[GTQuadTree alloc] init];
    } 
    
    [self.lock lock];
    for (id<MAAnnotation> annotation in annotations) {
        [self.tree insertAnnotation:annotation];
    }
    [self.lock unlock];
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect withZoomScale:(double)zoomScale
{
    double cellSize = MACellSizeForZoomScale(zoomScale);
    if ([self.delegate respondsToSelector:@selector(cellSizeFactorForCoordinator:)]) {
        cellSize *= [self.delegate cellSizeFactorForCoordinator:self];
    }
    double scaleFactor = zoomScale / cellSize;
    
    NSInteger minX = floor(MAMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MAMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MAMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MAMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    
    [self.lock lock];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            MAMapRect mapRect = MAMapRectMake(x/scaleFactor, y/scaleFactor, 1.0/scaleFactor, 1.0/scaleFactor);
            MABoundingBox mapBox = MABoundingBoxForMapRect(mapRect);
            
            __block double totalLatitude = 0;
            __block double totalLongitude = 0;
            
            NSMutableArray *annotations = [[NSMutableArray alloc] init];
            
            [self.tree enumerateAnnotationsInBox:mapBox usingBlock:^(id<MAAnnotation> obj) {
                totalLatitude += [obj coordinate].latitude;
                totalLongitude += [obj coordinate].longitude;
                [annotations addObject:obj];
            }];
            
            NSInteger count = [annotations count];
            if (count == 1) {
                [clusteredAnnotations addObjectsFromArray:annotations];
            }
            
            if (count > 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalLatitude/count, totalLongitude/count);
                MAAnnotationCluster *cluster = [[MAAnnotationCluster alloc] init];
                cluster.coordinate = coordinate;
                cluster.annotations = annotations;
                [clusteredAnnotations addObject:cluster];
            }
        }
    }
    [self.lock unlock];
    
    return [NSArray arrayWithArray:clusteredAnnotations];
}

- (NSArray *)allAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    [self.lock lock];
    [self.tree enumerateAnnotationsUsingBlock:^(id<MAAnnotation> obj) {
        [annotations addObject:obj];
    }];
    [self.lock unlock];
    
    return annotations;
}


- (void)displayAnnotations:(NSArray *)annotations onMapView:(MAMapView *)mapView
{
    NSMutableSet *before = [NSMutableSet setWithArray:mapView.annotations];
    [before removeObject:[mapView userLocation]];
    NSSet *after = [NSSet setWithArray:annotations];
    
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    // Get the main queue and do the UI stuff .
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [mapView addAnnotations:[toAdd allObjects]];
        [mapView removeAnnotations:[toRemove allObjects]];
    }];
}
@end
