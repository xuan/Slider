//
//  MetronomeView.m
//  Metronome
//
//  Created by Xuan Nguyen on 2/11/13.
//  Copyright (c) 2013 Xuan Nguyen. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MetronomeView.h"
#import "MetronomeLayer.h"

CGFloat const gestureMinimumTranslation = 10.0;

typedef enum : NSInteger {
    kDirectionNone,
    kDirectionUp,
    kDirectionDown,
    kDirectionRight,
    kDirectionLeft
} MoveDirection;

@interface MetronomeView ()
{
    MoveDirection direction;
}

@property(nonatomic,strong)MetronomeLayer *metronomeLayer;

@end

@implementation MetronomeView

@synthesize metronomeLayer;

- (void)awakeFromNib
{
    //Add layers
    metronomeLayer = [MetronomeLayer layer];
    //set metronomeLayer to fit whole screen
    [metronomeLayer setFrame:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
    [[self layer]addSublayer:metronomeLayer];
    [metronomeLayer setNeedsDisplay];

    //Register gestures
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panRecognizer];
}

#pragma mark - Gesture handlers

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint loc = [gesture locationOfTouch:0 inView:self];
    [metronomeLayer increment: loc.y];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self];
    CGPoint loc = [gesture locationInView:self];


    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        direction = kDirectionNone;
        [metronomeLayer touchesBegan:loc.x :loc.y];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        direction = [self determineDirectionIfNeeded:translation];

        if (direction == kDirectionDown || direction == kDirectionUp) {
            [metronomeLayer touchesMoved:loc.x :loc.y];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        direction = [self determineDirectionIfNeeded:translation];
        if (direction == kDirectionDown || direction == kDirectionUp) {
            [metronomeLayer touchesEnded];
        }
    }
}

- (MoveDirection)determineDirectionIfNeeded:(CGPoint)translation
{
    if (direction != kDirectionNone)
        return direction;
    // determine if horizontal swipe only if you meet some minimum velocity

    if (fabs(translation.x) > gestureMinimumTranslation)
    {
        BOOL gestureHorizontal = NO;

        if (translation.y == 0.0)
        {
            gestureHorizontal = YES;
        } else
        {
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0);
        }

        if (gestureHorizontal)
        {
            if (translation.x > 0.0)
                return kDirectionRight;
            else
                return kDirectionLeft;
        }
    }
            // determine if vertical swipe only if you meet some minimum velocity

    else if (fabs(translation.y) > gestureMinimumTranslation)
    {
        BOOL gestureVertical = NO;

        if (translation.x == 0.0)
            gestureVertical = YES;
        else
            gestureVertical = (fabs(translation.y / translation.x) > 5.0);

        if (gestureVertical)
        {
            if (translation.y > 0.0)
                return kDirectionDown;
            else
                return kDirectionUp;
        }
    }

    return direction;
}

@end
