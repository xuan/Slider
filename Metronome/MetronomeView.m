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
#import "OnOffLayer.h"

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
    MoveDirection _direction;
    CGPoint _originalCenter;
}

@property(nonatomic,strong)MetronomeLayer *metronomeLayer;
@property(nonatomic,strong)OnOffLayer *onOffLayer;

@end

@implementation MetronomeView

@synthesize metronomeLayer, onOffLayer;

-(void)awakeFromNib
{
    [self baseInit];
}

- (void) baseInit
{
    // Drawing code
    metronomeLayer = [MetronomeLayer layer];
    //set metronomeLayer to fit whole screen
    [metronomeLayer setFrame:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
    [[self layer]addSublayer:metronomeLayer];
    [metronomeLayer setNeedsDisplay];
    
    onOffLayer = [OnOffLayer layer];
    [onOffLayer setFrame:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
    [[self layer] setMask:onOffLayer];
    [onOffLayer setNeedsDisplay];
    
    //Register gestures
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panRecognizer];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
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
        _direction = kDirectionNone;
        [metronomeLayer touchesBegan:loc.x :loc.y];
        _originalCenter = [self center];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        _direction = [self determineDirectionIfNeeded:translation];

        if (_direction == kDirectionDown || _direction == kDirectionUp) {
            [metronomeLayer touchesMoved:loc.x :loc.y];
        } else if (_direction == kDirectionLeft || _direction == kDirectionRight) {
            
            // translate the center
            CGPoint translation = [gesture translationInView:self];
            self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        _direction = [self determineDirectionIfNeeded:translation];
        if (_direction == kDirectionDown || _direction == kDirectionUp) {
            [metronomeLayer touchesEnded];
        }
        
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = originalFrame;
                         } completion:nil];
        
    }
}

-(CABasicAnimation *)bounceAnimationFrom:(NSValue *)from
                                      to:(NSValue *)to
                              forKeyPath:(NSString *)keypath
                            withDuration:(CFTimeInterval)duration
{
    CABasicAnimation * result = [CABasicAnimation animationWithKeyPath:keypath];
    [result setFromValue:from];
    [result setToValue:to];
    [result setDuration:duration];
    
    [result setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :.8 :0.8]];
    
    return  result;
}

- (MoveDirection)determineDirectionIfNeeded:(CGPoint)translation
{
    if (_direction != kDirectionNone)
        return _direction;
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

    return _direction;
}

@end
