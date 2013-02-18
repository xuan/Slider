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
{
    bool shrinkBpmTextStopped;
}

@synthesize lineLayer, bpmTextLayer;

-(void) drawInContext:(CGContextRef)ctx
{
    //draw and hide line until user touches
    lineLayer = [CALayer layer];
    [lineLayer setBackgroundColor:[UIColor grayColor].CGColor];
    [lineLayer setFrame:CGRectMake(0, 60, 600, 40)];
    [lineLayer setOpacity:0.0f];
    [self addSublayer:lineLayer];
    
    bpmTextLayer = [CATextLayer layer];
    [bpmTextLayer setForegroundColor:[UIColor whiteColor].CGColor];
    [bpmTextLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [bpmTextLayer setFrame:CGRectMake(0, 0, 180, 60)];
    [bpmTextLayer setPosition:CGPointMake(150, 100)];
    [bpmTextLayer setContentsScale:[[UIScreen mainScreen]scale]];
    [bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", 100]];
    [bpmTextLayer setFontSize:48.0f];
    [self addSublayer:bpmTextLayer];
}

//use for tap gesture to increment/decrement small values
- (void)increment: (float) yPos
{
    if(yPos > [bpmTextLayer position].y){ //user taps on top of the bpm text
        [bpmTextLayer setPosition:CGPointMake([bpmTextLayer position].x, [bpmTextLayer position].y + 1)];
        [bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", (int)[bpmTextLayer position].y]];
    }else{ //user taps below the bpm text
        [bpmTextLayer setPosition:CGPointMake([bpmTextLayer position].x, [bpmTextLayer position].y - 1)];
        [bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", (int)[bpmTextLayer position].y]];
    }
}

- (void)touchesBegan: (float)xPos :(float) yPos
{
    shrinkBpmTextStopped = NO;
}

- (void)touchesEnded
{
    [bpmTextLayer setPosition:CGPointMake([self position].x, [bpmTextLayer position].y)];

    CABasicAnimation *scaleBpmText = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleBpmText setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [scaleBpmText setFromValue: [NSNumber numberWithFloat: 0.5f]];
    [scaleBpmText setToValue: [NSNumber numberWithFloat: 1.0f]];
    [scaleBpmText setFillMode:kCAFillModeForwards];
    [scaleBpmText setRemovedOnCompletion:NO];
    [bpmTextLayer addAnimation:scaleBpmText forKey:@"enlargeBpmText"];

    CABasicAnimation *fadeLine = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeLine setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [fadeLine setFromValue: [NSNumber numberWithFloat: 0.7f]];
    [fadeLine setToValue: [NSNumber numberWithFloat: 0.0f]];
    [fadeLine setFillMode:kCAFillModeForwards];
    [fadeLine setRemovedOnCompletion:NO];
    [lineLayer addAnimation:fadeLine forKey:@"fadeLineOut"];

    CABasicAnimation *scaleLine = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [scaleLine setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [scaleLine setFromValue: [NSNumber numberWithFloat: 1.0f]];
    [scaleLine setToValue: [NSNumber numberWithFloat: 4.0f]];
    [scaleLine setFillMode:kCAFillModeForwards];
    [scaleLine setRemovedOnCompletion:YES];
    [lineLayer addAnimation:scaleLine forKey:@"enlargeLine"];

    shrinkBpmTextStopped = NO;
    [bpmTextLayer removeAnimationForKey:@"shrinkBpmText"];
}



- (void)touchesMoved: (float)xPos :(float) yPos
{
    [bpmTextLayer removeAnimationForKey:@"enlargeBpmText"];
    [lineLayer removeAnimationForKey:@"fadeLineOut"];

    //help user to see the bpm depending on the location of their finger
    float displayPos = 80;
    if((int)xPos < 130){
        displayPos = 250;
    }

    //Since touchesMoved resets the animation, I have to get the previous transform scale to determine
    //the next animation
    CATransform3D prevBpmTextLayerTrans = [(CALayer *)[bpmTextLayer presentationLayer] transform];
    float scale = prevBpmTextLayerTrans.m11;
    if (scale > 0.5f){
        scale = scale  - 0.01f;
    }

    //rescale using the previous touchesMoved
    CABasicAnimation *scaleBpmText = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleBpmText setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [scaleBpmText setFromValue: [NSNumber numberWithFloat: scale]];
    [scaleBpmText setToValue: [NSNumber numberWithFloat: 0.5f]];
    [scaleBpmText setFillMode:kCAFillModeForwards];
    [scaleBpmText setRemovedOnCompletion:NO];
    [scaleBpmText setDelegate:self];
    [bpmTextLayer addAnimation:scaleBpmText forKey:@"shrinkBpmText"];


    NSLog(@"Shrink %s", shrinkBpmTextStopped?"YES":"NO");
    if (!shrinkBpmTextStopped)
    {
        [lineLayer setPosition:CGPointMake(30, yPos)];
        [bpmTextLayer setPosition:CGPointMake(displayPos, yPos)];
        [bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", (int)yPos]];
        [lineLayer setOpacity:0.7f];   // display line

    } else {
//      NSLog(@"yPos %d presentationLayer %d", (int)yPos, (int)[bpmPresentationLayer position].y);

        //remove animation to speed up performance
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        [lineLayer setPosition:CGPointMake(30, yPos)];
        [bpmTextLayer setPosition:CGPointMake(displayPos, yPos)];
        [bpmTextLayer setString:[NSString stringWithFormat:@"%dbpm", (int)yPos]];
        [CATransaction commit];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (theAnimation == [bpmTextLayer animationForKey:@"shrinkBpmText"])
    {
        NSLog(@"shrinkBpmText stopped ");
        shrinkBpmTextStopped = YES;
    }
}

@end
