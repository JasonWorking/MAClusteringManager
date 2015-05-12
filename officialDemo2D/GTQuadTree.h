//
//  GTQuadTree.h
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/11.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTQuadTreeNode.h"



/**
 *  
 
    Quad tree class, @see  http://en.wikipedia.org/wiki/Quadtree and http://www.cs.berkeley.edu/~demmel/cs267/lecture26/lecture26.html for more details. The MAMapKit has a implementation for quad tree called "MAQuadTree", but it's private. This class behaviors the same with the "MAQuadTree" but add some convinient methods. e.g. The "MAQuadTree" gives us "annotationsInBoudingBox:" , we change it to block enabeld : "- (void)enumerateAnnotationsInBox:(MABoundingBox)box usingBlock:(void (^)(id<MAAnnotation> obj))block; Also, we don't support "updateAnnotation:fromOldPosition:" that is supported in MAMapKit/MAQuadTree.
 
 
 */
@interface GTQuadTree : NSObject



/// Root node of the Quad tree,
@property (nonatomic, strong) GTQuadTreeNode *rootNode;


/**
 *  Insert new annotation into a QuadTree
 *
 *  @param annotation The annotation to insert
 *
 *  @return \c YES if insert success, otherwise returns NO.
 */
- (BOOL)insertAnnotation:(id<MAAnnotation>)annotation;


/**
 *  Enumerate annotations in a fix boundingBox.
 */
- (void)enumerateAnnotationsInBox:(MABoundingBox)box usingBlock:(void (^)(id<MAAnnotation> obj))block;


/**
 *  Enumerate all annotations.
 */
- (void)enumerateAnnotationsUsingBlock:(void (^)(id<MAAnnotation> obj))block;


@end
