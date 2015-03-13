//
//  MAClusterAnnotationView.m
//  officialDemo2D
//
//  Created by Jason-autonavi on 15/3/13.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "MAClusterAnnotationView.h"

CGPoint MARectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect MACenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

static CGFloat const MAScaleFactorAlpha = 0.3;
static CGFloat const MAScaleFactorBeta = 0.4;

CGFloat MAScaledValueForValue(CGFloat value)
{
    return 1.0 / (1.0 + expf(-1 * MAScaleFactorAlpha * powf(value, MAScaleFactorBeta)));
}




@interface MAClusterAnnotationView ()

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation MAClusterAnnotationView

#pragma mark - Init
- (instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        _count        = 1;
        _clusterColor = [UIColor colorWithRed:255.0/255.0 green:95/255.0 blue:42/255.0 alpha:1.0];
        _textColor    = UIColor.whiteColor;
        self.backgroundColor = UIColor.clearColor;
        [self setupLabel];
    }
    
    return self;
}


- (void)setupLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:self.frame];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = self.textColor;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    _countLabel.shadowOffset = CGSizeMake(0, -1);
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_countLabel];
}

#pragma mark - Setter 

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    CGRect newBounds = CGRectMake(0, 0, roundf(44 * MAScaledValueForValue(count)), roundf(44 * MAScaledValueForValue(count)));
    self.frame = MACenterRect(newBounds, self.center);
    
    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
    self.countLabel.frame = MACenterRect(newLabelBounds, MARectCenter(newBounds));
    self.countLabel.text = [@(_count) stringValue];
    
    [self setNeedsDisplay];
    
    
}



#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    
    UIColor *outerCircleStrokeColor = [UIColor colorWithWhite:0 alpha:0.25];
    UIColor *innerCircleStrokeColor = [UIColor whiteColor];
    UIColor *innerCircleFillColor = self.clusterColor;
    
    CGRect circleFrame = CGRectInset(rect, 4, 4);
    
    [outerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 4);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleFillColor setFill];
    CGContextFillEllipseInRect(context, circleFrame);
    
}


#pragma mark - Reuse

- (void)prepareForReuse
{
    [super prepareForReuse];
}




@end
