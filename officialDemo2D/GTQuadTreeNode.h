//
//  GTQuadTreeNode.h
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/11.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>


typedef struct {
    CGFloat x0;
    CGFloat y0;
    CGFloat xf;
    CGFloat yf;
} MABoundingBox;

#pragma mark - Bounding box functions

NS_INLINE MABoundingBox MABoundingBoxMake(CGFloat x0, CGFloat y0, CGFloat xf, CGFloat yf)
{
    MABoundingBox box;
    box.x0 = x0;
    box.y0 = y0;
    box.xf = xf;
    box.yf = yf;
    return box;
}

NS_INLINE MABoundingBox MABoundingBoxForMapRect(MAMapRect mapRect)
{
    CLLocationCoordinate2D topLeft  = MACoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MACoordinateForMapPoint(MAMapPointMake(MAMapRectGetMaxX(mapRect),
                                                                             MAMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    
    return MABoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

NS_INLINE MAMapRect MAMapRectForBoundingBox(MABoundingBox boundingBox)
{
    MAMapPoint topLeft  = MAMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.x0, boundingBox.y0));
    MAMapPoint botRight = MAMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.xf, boundingBox.yf));

    return MAMapRectMake(topLeft.x, botRight.y,
                         fabs(botRight.x - topLeft.x),
                         fabs(botRight.y - topLeft.y));
}

NS_INLINE BOOL MABoundingBoxContainsCoordinate(MABoundingBox box, CLLocationCoordinate2D coordinate)
{
    BOOL containsX = box.x0 <= coordinate.latitude && coordinate.latitude <= box.xf;
    BOOL containsY = box.y0 <= coordinate.longitude && coordinate.longitude <= box.yf;
    return containsX && containsY;
}

NS_INLINE BOOL MABoundingBoxIntersectsBoundingBox(MABoundingBox box1, MABoundingBox box2)
{
    return (box1.x0 <= box2.xf && box1.xf >= box2.x0 && box1.y0 <= box2.yf && box1.yf >= box2.y0);
}




@interface GTQuadTreeNode : NSObject

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, assign) NSUInteger capacity;

@property (nonatomic, assign) MABoundingBox boundingBox;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, strong) GTQuadTreeNode *northEast;
@property (nonatomic, strong) GTQuadTreeNode *northWest;
@property (nonatomic, strong) GTQuadTreeNode *southEast;
@property (nonatomic, strong) GTQuadTreeNode *southWest;




/**
 *  Convenient Initializer
 *
 *  @param box Bounding box of node.
 *
 *  @return An instance of \c GTQuadTreeNode, use the \c box as its boudingBox and use default node capacity = 8 .
 */
- (instancetype)initWithBoundingBox:(MABoundingBox)box;



/**
 *  Designated Initializer
 *
 *  @param box      Bouding box of node
 *  @param capacity The node's capacity of data points
 *
 *  @return An instance of \c GTQuadTreeNode
 */
- (instancetype)initWithBoundingBox:(MABoundingBox)box
                           capacity:(NSUInteger)capacity;


/**
 *  Check if node is leaf in tree .
 *
 *  @return \c YES if node is leaf, otherwise returns \v NO
 */
- (BOOL)isLeaf;



/**
 *  Create new child nodes.
 */
- (void)subdivide;
@end
