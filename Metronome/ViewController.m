//
//  ViewController.m
//  Metronome
//
//  Created by Xuan Nguyen on 2/11/13.
//  Copyright (c) 2013 Xuan Nguyen. All rights reserved.
//

#import "ViewController.h"
#import "MetronomeView.h"

@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)MetronomeView *metronomeView;
@end

@implementation ViewController
@synthesize metronomeView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroll.delegate = self;
    scroll.pagingEnabled = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;

    metronomeView = [[MetronomeView alloc]initWithFrame:CGRectMake(0, 0, [[self view]frame].size.width, [[self view]frame].size.height)];
    [metronomeView setBackgroundColor:[UIColor blueColor]];
    [scroll addSubview:metronomeView];
    
    [[self view] addSubview:scroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.bounds.origin.y >500){
        CGPoint offset = scrollView.contentOffset;
        [scrollView setContentOffset:offset animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
