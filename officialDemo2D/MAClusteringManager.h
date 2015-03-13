//
//  MAClusteringManager.h
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/11.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTQuadTreeNode.h"
#import "MAAnnotationCluster.h"

@class MAClusteringManager;

@protocol MAClusteringManagerDelegate <NSObject>
@optional
/**
 Method that allows you to define factor for default size of cluster cells.
 @param coordinator An instance of MAClusterManager.
 
 @discussion Cell size factor will scale size of default cell size. With value smaller than 1.0 cell size will be smaller than default and you will see more clusters on the map. With factor larger than 1.0 cell size will be bigger than default and you will see less clusters on the map.
 */
- (CGFloat)cellSizeFactorForCoordinator:(MAClusteringManager *)coordinator;

@end



@interface MAClusteringManager : NSObject

@property (nonatomic, weak) id<MAClusteringManagerDelegate> delegate;



/**
 *  Designated Initializer.Creates a new instance of @c MAClusterManager with array of annotations.
 *
 *  @param annotations Custom annotation objects.
 *
 *  @return  An instance of MAClusterManager
 */
- (instancetype)initWithAnnotations:(NSArray *)annotations;



/**
 *  Replace current annotations new array of annotations.
 *
 *  @param annotations Custom annotation objects.
 */
- (void)setAnnotations:(NSArray *)annotations;


/**
 * Add array of annotations to current annotation collection. 
 * When the Quad Tree is empty, this will build it.
 *
 * @param annotations Custom annotation objects.
 */
- (void)addAnnotations:(NSArray *)annotations;




/**
 *   Method that return array of your custom annotations or annotation clusters.
 *
 *  @param rect      An instance of MAMapRect.
 *  @param zoomScale An instance of MAMapRect.
 *
 *  @return Array of annotations objects of type @c MAAnnotationCluster or your custom subclass of MAAnnotationCluster.
 */
- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect
                                 withZoomScale:(double)zoomScale;


/**
 All annotations in Quad tree.
 @returns Array of annotations of your custom class.
 */
- (NSArray *)allAnnotations;


/**
 Update map with new annotations.
 @param annotations Array of new annotation objects.
 @param mapView An instance of MKMapView
 
 @discussion In order to improve the performance of doing UI stuff on main queue, we calculate the set to remove 、set the add 、set to keep on a background queue, and then on the main queue only add the annotations that in the \c annotation array but not already on mapView. And, we will remove only the annotations that not in the \c annotation array but already on mapView.
  */
- (void)displayAnnotations:(NSArray *)annotations
                 onMapView:(MAMapView *)mapView;


@end
