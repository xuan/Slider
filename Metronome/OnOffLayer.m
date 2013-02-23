//
//  OnOffLayer.m
//  Metronome
//
//  Created by Xuan Nguyen on 2/18/13.
//  Copyright (c) 2013 Xuan Nguyen. All rights reserved.
//

#import "OnOffLayer.h"

@interface OnOffLayer()

@property (nonatomic, weak)CAShapeLayer *mask;

@end

@implementation OnOffLayer
@synthesize mask;

-(void) drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    mask = [self templateDrawMask];
    [self addSublayer:mask];
    UIGraphicsPopContext();
}

-(CAShapeLayer *)templateDrawMask
{
    float width = [self frame].size.width;
    float height = [self frame].size.height; 
    
    float top = 215.0;
    float down = 266.0;
    float arrowIn = top + 25;
    
    CAShapeLayer* arrowPath = [CAShapeLayer layer];
    //// Color Declarations
    //// Arrow Drawing
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0.0, 0.0)];
    [path addLineToPoint: CGPointMake(width, 0.0)];
    [path addLineToPoint: CGPointMake(width, top)];
    [path addLineToPoint: CGPointMake(arrowIn + 48, arrowIn)];
    [path addLineToPoint: CGPointMake(width, down)];
    [path addLineToPoint: CGPointMake(width, height)];
    [path addLineToPoint: CGPointMake(0.0, height)];
    [path addLineToPoint: CGPointMake(0.0, down)]; 
    [path addLineToPoint: CGPointMake(down - arrowIn, arrowIn)];
    [path addLineToPoint: CGPointMake(0.0, top)];
    [path addLineToPoint: CGPointMake(0.0, 0.0)];
    
    [arrowPath setPath:path.CGPath];
    [arrowPath setPosition:CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]))];
    [arrowPath setBounds:[self bounds]];
    
    return arrowPath;
}
@end
