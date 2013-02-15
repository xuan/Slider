//
//  MetronomeLayer.m
//  Metronome
//
//  Created by Xuan Nguyen on 2/12/13.
//  Copyright (c) 2013 Xuan Nguyen. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MetronomeLayer.h"

@implementation MetronomeLayer

-(void) drawInContext:(CGContextRef)ctx {
    _lineLayer = [CALayer layer];
    [_lineLayer setBackgroundColor:[UIColor grayColor].CGColor];
    [_lineLayer setFrame:CGRectMake(0, 60, 600, 40)];
    [_lineLayer setOpacity:0.7f];
    [_lineLayer setHidden:YES];
    [self addSublayer:_lineLayer];
    
    _bpmTextLayer = [CATextLayer layer];
    [_bpmTextLayer setForegroundColor:[UIColor whiteColor].CGColor];
    [_bpmTextLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [_bpmTextLayer setFrame:CGRectMake(0, 60, 180, 60)];
    [_bpmTextLayer setPosition:CGPointMake(200, 100)];
    [_bpmTextLayer setContentsScale:[[UIScreen mainScreen]scale]];
    [_bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", 100]];
    [_bpmTextLayer setFontSize:48.0f];
    [_bpmTextLayer setOpacity:1.0f];
    [self addSublayer:_bpmTextLayer];
}

- (void)increment: (float) yPos
{
    if(yPos > [_bpmTextLayer position].y){
        [_bpmTextLayer setPosition:CGPointMake([_bpmTextLayer position].x, [_bpmTextLayer position].y + 1)];
        [_bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", (int)[_bpmTextLayer position].y]];
    }else{
        [_bpmTextLayer setPosition:CGPointMake([_bpmTextLayer position].x, [_bpmTextLayer position].y - 1)];
        [_bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", (int)[_bpmTextLayer position].y]];
    }
}

- (void)touchesBegan: (float)xPos :(float) yPos
{
    [_lineLayer setHidden:NO];
    [_lineLayer setPosition:CGPointMake(xPos, yPos)];
    [_bpmTextLayer setPosition:CGPointMake(80, yPos)];
    [_bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", (int)yPos]];

    CABasicAnimation *scaleBpmText = [[CABasicAnimation alloc] init];
    [scaleBpmText setDuration:0.5f];
    [scaleBpmText setRemovedOnCompletion:NO];
    [scaleBpmText setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [scaleBpmText setFromValue: [NSNumber numberWithFloat: 1.0f]];
    [scaleBpmText setToValue: [NSNumber numberWithFloat: 0.5f]];
    [scaleBpmText setFillMode:kCAFillModeForwards];
    [scaleBpmText setRemovedOnCompletion:NO];
    [_bpmTextLayer addAnimation:scaleBpmText forKey:@"transform.scale"];

    CABasicAnimation *scaleLine = [[CABasicAnimation alloc] init];
    [scaleLine setDuration:0.5f];
    [scaleLine setRemovedOnCompletion:NO];
    [scaleLine setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [scaleLine setFromValue: [NSNumber numberWithFloat: 3.0f]];
    [scaleLine setToValue: [NSNumber numberWithFloat: 1.0f]];
    [_lineLayer addAnimation:scaleLine forKey:@"transform.scale.y"];

    CABasicAnimation *fadeLine = [[CABasicAnimation alloc] init];
    [fadeLine setDuration:0.5f];
    [fadeLine setRemovedOnCompletion:NO];
    [fadeLine setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [fadeLine setFromValue: [NSNumber numberWithFloat: 0.0f]];
    [fadeLine setToValue: [NSNumber numberWithFloat: 0.7f]];
    [_lineLayer addAnimation:fadeLine forKey:@"opacity"];

    NSMutableArray* animationsArray = [NSMutableArray arrayWithObjects:scaleLine, fadeLine,nil];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:animationsArray];
    [animationGroup setFillMode:kCAFillModeForwards];
    [_lineLayer addAnimation:animationGroup forKey:nil];
}

- (void)touchesEnded
{
    [_bpmTextLayer setPosition:CGPointMake([self position].x + 50, [_bpmTextLayer position].y)];
    
    CABasicAnimation *scaleBpmText = [[CABasicAnimation alloc] init];
    [scaleBpmText setDuration:0.5f];
    [scaleBpmText setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [scaleBpmText setFromValue: [NSNumber numberWithFloat: 0.5f]];
    [scaleBpmText setToValue: [NSNumber numberWithFloat: 1.0f]];
    [scaleBpmText setFillMode:kCAFillModeForwards];
    [scaleBpmText setRemovedOnCompletion:NO];
    [_bpmTextLayer addAnimation:scaleBpmText forKey:@"transform.scale"];
    
    CABasicAnimation *scaleLine = [[CABasicAnimation alloc] init];
    [scaleLine setDuration:0.5f];
    [scaleLine setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [scaleLine setFromValue: [NSNumber numberWithFloat: 1.0f]];
    [scaleLine setToValue: [NSNumber numberWithFloat: 0.0f]];
    [scaleLine setFillMode:kCAFillModeForwards];
    [scaleLine setRemovedOnCompletion:NO];
    [_lineLayer addAnimation:scaleLine forKey:@"transform.scale.y"];
    
    CABasicAnimation *fadeLine = [[CABasicAnimation alloc] init];
    [fadeLine setDuration:0.5f];
    [fadeLine setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [fadeLine setFromValue: [NSNumber numberWithFloat: 0.7f]];
    [fadeLine setToValue: [NSNumber numberWithFloat: 0.0f]];
    [fadeLine setFillMode:kCAFillModeForwards];
    [fadeLine setRemovedOnCompletion:NO];
    [_lineLayer addAnimation:fadeLine forKey:@"opacity"];
    
    NSMutableArray* animationsArray = [NSMutableArray arrayWithObjects:scaleBpmText, scaleLine, fadeLine,nil];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:animationsArray];
    [_lineLayer addAnimation:animationGroup forKey:nil];
}

- (void)touchesMoved: (float)xPos :(float) yPos
{
    float displayPos = 80;

    if((int)xPos < 130){
        displayPos = 250;
    }

    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    [_lineLayer setPosition:CGPointMake(30, yPos)];
    [_bpmTextLayer setPosition:CGPointMake(displayPos, yPos)];
    [_bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", (int)yPos]];
    [CATransaction commit];
}

@end
