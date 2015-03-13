//
//  GTQuadTree.m
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/11.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "GTQuadTree.h"

@implementation GTQuadTree

- (id)init
{
    self = [super init];
    if (self) {
        self.rootNode = [[GTQuadTreeNode alloc] initWithBoundingBox:MABoundingBoxForMapRect(MAMapRectWorld)];
    }
    return self;
}

- (BOOL)insertAnnotation:(id<MAAnnotation>)annotation
{
    return [self insertAnnotation:annotation toNode:self.rootNode];
}

- (BOOL)insertAnnotation:(id<MAAnnotation>)annotation toNode:(GTQuadTreeNode *)node
{
    if (!MABoundingBoxContainsCoordinate(node.boundingBox, [annotation coordinate])) {
        return NO;
    }
    
    if (node.count < node.capacity) {
        node.annotations[node.count++] = annotation;
        return YES;
    }
    
    if ([node isLeaf]) {
        [node subdivide];
    }
    
    if ([self insertAnnotation:annotation toNode:node.northEast]) return YES;
    if ([self insertAnnotation:annotation toNode:node.northWest]) return YES;
    if ([self insertAnnotation:annotation toNode:node.southEast]) return YES;
    if ([self insertAnnotation:annotation toNode:node.southWest]) return YES;
    
    return NO;
}

- (void)enumerateAnnotationsInBox:(MABoundingBox)box usingBlock:(void (^)(id<MAAnnotation>))block
{
    [self enumerateAnnotationsInBox:box withNode:self.rootNode usingBlock:block];
}

- (void)enumerateAnnotationsUsingBlock:(void (^)(id<MAAnnotation>))block
{
    [self enumerateAnnotationsInBox:MABoundingBoxForMapRect(MAMapRectWorld) withNode:self.rootNode usingBlock:block];
}

- (void)enumerateAnnotationsInBox:(MABoundingBox)box withNode:(GTQuadTreeNode*)node usingBlock:(void (^)(id<MAAnnotation>))block
{
    if (!MABoundingBoxIntersectsBoundingBox(node.boundingBox, box)) {
        return;
    }
    
    NSArray *tempArray = [node.annotations copy];
    
    for (id<MAAnnotation> annotation in tempArray) {
        if (MABoundingBoxContainsCoordinate(box, [annotation coordinate])) {
            block(annotation);
        }
    }
    
    if ([node isLeaf]) {
        return;
    }
    
    [self enumerateAnnotationsInBox:box withNode:node.northEast usingBlock:block];
    [self enumerateAnnotationsInBox:box withNode:node.northWest usingBlock:block];
    [self enumerateAnnotationsInBox:box withNode:node.southEast usingBlock:block];
    [self enumerateAnnotationsInBox:box withNode:node.southWest usingBlock:block];
}


@end
