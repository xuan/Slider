//
//  MetronomeLayer.h
//  Metronome
//
//  Created by Xuan Nguyen on 2/12/13.
//  Copyright (c) 2013 Xuan Nguyen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface MetronomeLayer : CALayer

@property(nonatomic, strong)CALayer *lineLayer;
@property(nonatomic, strong)CATextLayer *bpmTextLayer;

- (void)touchesBegan: (float)xPos :(float) yPos;
- (void)touchesEnded: (float)xPos :(float) yPos;
- (void)touchesMoved: (float)xPos :(float) yPos;
@end
