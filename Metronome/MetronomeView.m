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

@interface MetronomeView ()

@property(nonatomic,strong)MetronomeLayer *metronomeLayer;

@end

@implementation MetronomeView

- (void)awakeFromNib{
    _metronomeLayer = [MetronomeLayer layer];
    [_metronomeLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [[self layer]addSublayer:_metronomeLayer];
    [_metronomeLayer setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [[touches allObjects] objectAtIndex:0];
//    CGPoint location = [touch locationInView:self];
//    [_metronomeLayer touchesBegan:location.x :location.y];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}
- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
    CGPoint loc = [sender locationOfTouch:0 inView:self];
    [_metronomeLayer increment: loc.y];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateBegan) {
        CGPoint loc = [sender locationOfTouch:0 inView:self];
        [_metronomeLayer touchesBegan:loc.x :loc.y];
    } else if([sender state] == UIGestureRecognizerStateChanged) {
        CGPoint loc = [sender locationOfTouch:0 inView:self];
        [_metronomeLayer touchesMoved:loc.x :loc.y];
    } else if([sender state] ==UIGestureRecognizerStateEnded ) {
        [_metronomeLayer touchesEnded];
    }
    
    
    
//    CGPoint vel = [sender velocityInView:self];
//    if (vel.x > 0)
//    {
//        // user dragged towards the right
//        NSLog(@"user dragged right");
//    }
//    else
//    {
//        // user dragged towards the left
//        NSLog(@"user dragged left");
//    }
//    
//    if (vel.y > 0)
//    {
//        // user dragged towards the down
//        NSLog(@"user dragged down");
//    }
//    else
//    {
//        // user dragged towards the up
//        NSLog(@"user dragged up");
//    }
}

@end
