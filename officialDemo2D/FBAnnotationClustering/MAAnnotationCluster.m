//
//  MAAnnotationCluster.m
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/11.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "MAAnnotationCluster.h"

@implementation MAAnnotationCluster

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@" MAAnnotationCluster : %p, coordinate: (%f,%f) \n"
                                        "title: %@, subTitle: %@  \n "
                                        "annotations: %@",  self,self.coordinate.latitude, self.coordinate.longitude,
                                                            self.title, self.subtitle,
                                                            self.annotations];
}

@end
