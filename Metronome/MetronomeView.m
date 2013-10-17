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
    MoveDirection direction;
    CGPoint originalCenter;
    BOOL configBtnTouchDown;
}

@property(nonatomic,strong)MetronomeLayer *metronomeLayer;
@property(nonatomic,strong)OnOffLayer *onOffLayer;
@property(nonatomic,strong)UIButton *configBtn;

@end

@implementation MetronomeView

@synthesize metronomeLayer, onOffLayer, configBtn;

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
    
    CGRect buttonFrame = CGRectMake( [self center].x - 100, [self center].y + 200, 200, 70 );
    configBtn = [[UIButton alloc] initWithFrame: buttonFrame];
    [configBtn setTitle: @"Config" forState: UIControlStateNormal];
    [configBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [configBtn setBackgroundColor:[UIColor grayColor]];
    [configBtn addTarget:self action:@selector(buttonUp) forControlEvents:UIControlEventTouchUpInside];
    [configBtn addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchDown];
    [self addSubview: configBtn];
    
    //Register gestures
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panRecognizer];
}

-(void)buttonUp
{
    configBtnTouchDown = NO;
}

-(void)buttonDown
{
    configBtnTouchDown = YES;
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
        direction = kDirectionNone;
        [metronomeLayer touchesBegan:loc.x :loc.y];
        originalCenter = [self center];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        if(configBtnTouchDown){
            CGPoint translation = [gesture translationInView:self];
            self.center = CGPointMake(originalCenter.x, originalCenter.y + translation.y);
        }else{
            direction = [self determineDirectionIfNeeded:translation];
            //handle pan up and down
            if (direction == kDirectionDown || direction == kDirectionUp) {
                [metronomeLayer touchesMoved:loc.x :loc.y];
            } else if (direction == kDirectionLeft || direction == kDirectionRight) { //handle left  and right pan
                
                // translate the center
                CGPoint translation = [gesture translationInView:self];
                self.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        configBtnTouchDown = NO;
        
        direction = [self determineDirectionIfNeeded:translation];
        if (direction == kDirectionDown || direction == kDirectionUp) {
            [metronomeLayer touchesEnded];
        }
        
        //snap to center when user lifts finger  when doing left and right pan
        
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, 0,
                                          self.bounds.size.width, self.bounds.size.height);
        
        //do snap frame animation to center
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = originalFrame;
                         } completion:nil];
        
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
