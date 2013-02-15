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


CGFloat const gestureMinimumTranslation = 20.0;

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

- (void)awakeFromNib
{
    _metronomeLayer = [MetronomeLayer layer];
    [_metronomeLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [[self layer]addSublayer:_metronomeLayer];
    [_metronomeLayer setNeedsDisplay];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint loc = [gesture locationOfTouch:0 inView:self];
    [_metronomeLayer increment: loc.y];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self];
    direction = [self determineCameraDirectionIfNeeded:translation];

    if (gesture.state == UIGestureRecognizerStateChanged && (direction == kDirectionDown || direction == kDirectionUp))
    {
        CGPoint loc = [gesture locationOfTouch:0 inView:self];
        [_metronomeLayer touchesBegan:loc.x :loc.y];
    } else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint loc = [gesture locationOfTouch:0 inView:self];
        // ok, now initiate movement in the direction indicated by the user's gesture
        switch (direction)
        {
            case kDirectionDown:
                [_metronomeLayer touchesMoved:loc.x :loc.y];
                break;
                
            case kDirectionUp:
                [_metronomeLayer touchesMoved:loc.x :loc.y];
                break;
                
            case kDirectionRight:
                NSLog(@"Start moving right");
                break;
                
            case kDirectionLeft:
                NSLog(@"Start moving left");
                break;
                
            default:
                break;
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [_metronomeLayer touchesEnded];
        direction = kDirectionNone;
        NSLog(@"Stop");
    }
}

- (MoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation
{
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
