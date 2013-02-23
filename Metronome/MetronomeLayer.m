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
}

@synthesize lineLayer, bpmTextLayer;

-(void) drawInContext:(CGContextRef)ctx
{
    //draw and hide line until user touches
    lineLayer = [CALayer layer];
    [lineLayer setBackgroundColor:[UIColor grayColor].CGColor];
    [lineLayer setFrame:CGRectMake(0.0, 0.0, 600.5, 40.5)];
    [lineLayer setOpacity:0.0f];
    [self addSublayer:lineLayer];
    
    bpmTextLayer = [CATextLayer layer];
    [bpmTextLayer setForegroundColor:[UIColor whiteColor].CGColor];
    [bpmTextLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [bpmTextLayer setFrame:CGRectMake(0, 0, 180.5, 60.5)];
    [bpmTextLayer setPosition:CGPointMake(150.5, 100.5)];
    [bpmTextLayer setContentsScale:[[UIScreen mainScreen]scale]];
    [bpmTextLayer setString:[NSString stringWithFormat:@"%d", 100]];
    [bpmTextLayer setFontSize:48.0f];
    [self addSublayer:bpmTextLayer];
    
    CATextLayer *bpmText = [CATextLayer layer];
    [bpmText setForegroundColor:[UIColor redColor].CGColor];
    [bpmText setBackgroundColor:[UIColor clearColor].CGColor];
    [bpmText setFrame:CGRectMake(0, 0, 50.5, 30.5)];
    [bpmText setPosition:CGPointMake(105.5, 39.5)];
    [bpmText setContentsScale:[[UIScreen mainScreen]scale]];
    [bpmText setString:[NSString stringWithFormat:@"bpm"]];
    [bpmText setFontSize:24.0f];
    [bpmText setOpacity:0.7f];
    [bpmTextLayer addSublayer:bpmText];
}

//use for tap gesture to increment/decrement small values
- (void)increment: (float) yPos
{
    if(yPos > [bpmTextLayer position].y){ //user taps on top of the bpm text
        [bpmTextLayer setPosition:CGPointMake([bpmTextLayer position].x, [bpmTextLayer position].y + 1)];
        [bpmTextLayer setString:[NSString stringWithFormat:@"%d", (int)[bpmTextLayer position].y]];
    }else{ //user taps below the bpm text
        [bpmTextLayer setPosition:CGPointMake([bpmTextLayer position].x, [bpmTextLayer position].y - 1)];
        [bpmTextLayer setString:[NSString stringWithFormat:@"%d", (int)[bpmTextLayer position].y]];
    }
}

- (void)touchesBegan: (float)xPos :(float) yPos
{
}

- (void)touchesEnded
{
    [bpmTextLayer setPosition:CGPointMake([self position].x, [bpmTextLayer position].y)];

    CABasicAnimation *enlargeBpmText = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [enlargeBpmText setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [enlargeBpmText setFromValue:[NSNumber numberWithFloat:0.5f]];
    [enlargeBpmText setToValue:[NSNumber numberWithFloat:1.0f]];
    [enlargeBpmText setFillMode:kCAFillModeForwards];
    [enlargeBpmText setRemovedOnCompletion:NO];
    [bpmTextLayer addAnimation:enlargeBpmText forKey:@"enlargeBpmText"];

    CABasicAnimation *fadeLineOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeLineOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [fadeLineOut setFromValue:[NSNumber numberWithFloat:0.7f]];
    [fadeLineOut setToValue:[NSNumber numberWithFloat:0.0f]];
    [fadeLineOut setFillMode:kCAFillModeForwards];
    [fadeLineOut setRemovedOnCompletion:NO];
    [lineLayer addAnimation:fadeLineOut forKey:@"fadeLineOut"];

    CABasicAnimation *enlargeLine = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [enlargeLine setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [enlargeLine setFromValue:[NSNumber numberWithFloat:1.0f]];
    [enlargeLine setToValue:[NSNumber numberWithFloat:4.0f]];
    [enlargeLine setFillMode:kCAFillModeForwards];
    [enlargeLine setRemovedOnCompletion:YES];
    [lineLayer addAnimation:enlargeLine forKey:@"enlargeLine"];

    [bpmTextLayer removeAnimationForKey:@"shrinkBpmText"];
}



- (void)touchesMoved: (float)xPos :(float) yPos
{
    [bpmTextLayer removeAnimationForKey:@"enlargeBpmText"];
    [lineLayer removeAnimationForKey:@"fadeLineOut"];

    //help user to see the bpm depending on the location of their finger
    float displayPos = 80.5;
    if((int)xPos < 130.5){
        displayPos = 250.5;
    }

    //Since touchesMoved resets the animation, I have to get the previous transform scale to determine
    //the next animation
    CATransform3D prevBpmTextLayerTrans = [(CALayer *)[bpmTextLayer presentationLayer] transform];
    float scale = prevBpmTextLayerTrans.m11;
    if (scale > 0.5f){
        scale = scale  - 0.03f;
    }

    //rescale using the previous touchesMoved
    CABasicAnimation *shrinkBpmText = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [shrinkBpmText setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [shrinkBpmText setFromValue:[NSNumber numberWithFloat:scale]];
    [shrinkBpmText setToValue:[NSNumber numberWithFloat:0.5f]];
    [shrinkBpmText setFillMode:kCAFillModeForwards];
    [shrinkBpmText setRemovedOnCompletion:NO];
    [shrinkBpmText setDelegate:self];
    [bpmTextLayer addAnimation:shrinkBpmText forKey:@"shrinkBpmText"];

    [CATransaction setAnimationDuration:0.1f];
    [CATransaction begin];
    [lineLayer setPosition:CGPointMake(30.5, yPos)];
    [bpmTextLayer setPosition:CGPointMake(displayPos, yPos)];
    [bpmTextLayer setString:[NSString stringWithFormat:@"%d", (int)yPos]];
    [lineLayer setOpacity:0.7f];   // display line
    [CATransaction commit];
    
}

@end
