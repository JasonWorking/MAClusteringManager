//
//  GTQuadTreeNode.m
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/11.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "GTQuadTreeNode.h"

// The default node capacity .
#define kNodeCapacity 8

@implementation GTQuadTreeNode

- (id)init
{
    return [self initWithBoundingBox:MABoundingBoxMake(0, 0, 0, 0) capacity:kNodeCapacity];
}

- (instancetype)initWithBoundingBox:(MABoundingBox)box
{
    return [self initWithBoundingBox:box capacity:kNodeCapacity];
}

- (instancetype)initWithBoundingBox:(MABoundingBox)box capacity:(NSUInteger)capacity
{
    if (self = [super init]) {
        self.count = 0;
        self.northEast = nil;
        self.northWest = nil;
        self.southEast = nil;
        self.southWest = nil;
        self.annotations = [[NSMutableArray alloc] initWithCapacity:capacity];
        self.capacity = capacity;
        self.boundingBox = box;
    }
    
    return self;
}



- (BOOL)isLeaf
{
    return self.northEast ? NO : YES;
}

- (void)subdivide
{

    MABoundingBox box = self.boundingBox;
    CGFloat xMid = (box.xf + box.x0) / 2.0;
    CGFloat yMid = (box.yf + box.y0) / 2.0;
    
    self.northEast = [[GTQuadTreeNode alloc] initWithBoundingBox:MABoundingBoxMake(xMid, box.y0, box.xf, yMid)
                                                        capacity:self.capacity];
    
    self.northWest = [[GTQuadTreeNode alloc] initWithBoundingBox:MABoundingBoxMake(box.x0, box.y0, xMid, yMid)
                                                        capacity:self.capacity];
    
    self.southEast = [[GTQuadTreeNode alloc] initWithBoundingBox:MABoundingBoxMake(xMid, yMid, box.xf, box.yf)
                                                        capacity:self.capacity];
    
    self.southWest = [[GTQuadTreeNode alloc] initWithBoundingBox:MABoundingBoxMake(box.x0, yMid, xMid, box.yf)
                                                        capacity:self.capacity];
    
    
}



@end
