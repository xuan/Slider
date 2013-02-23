//
//  ViewController.m
//  Metronome
//
//  Created by Xuan Nguyen on 2/11/13.
//  Copyright (c) 2013 Xuan Nguyen. All rights reserved.
//

#import "ViewController.h"
#import "MetronomeView.h"

@interface ViewController ()
@property(nonatomic,strong)MetronomeView *metronomeView;
@end

@implementation ViewController
@synthesize metronomeView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    metronomeView = [[MetronomeView alloc]initWithFrame:CGRectMake(0, 0, [[self view]frame].size.width, [[self view]frame].size.height)];
    [metronomeView setBackgroundColor:[UIColor blueColor]];
    [[self view] addSubview:metronomeView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
