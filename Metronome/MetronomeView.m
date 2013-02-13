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
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint location = [touch locationInView:self];
    [_metronomeLayer touchesBegan:location.x :location.y];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint location = [touch locationInView:self];
    [_metronomeLayer touchesEnded:location.x :location.y];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint location = [touch locationInView:self];
    [_metronomeLayer touchesMoved:location.x :location.y];
}

@end
