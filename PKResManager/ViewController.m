//
//  ViewController.m
//  PKResManager
//
//  Created by zhong sheng on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "StyledView.h"

#define CUSTOM_STYLE @"customStyle"

@interface ViewController ()
- (void)customAction;
- (void)changeAction;
- (void)addTestBtn;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIProgressView *progressView;
@end

@implementation ViewController
@synthesize imageView = _imageView;
@synthesize progressView = _progressView;

- (void)dealloc
{
    self.progressView = nil;
    self.imageView = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 
    [[PKResManager getInstance] addChangeStyleObject:self];
    
    UIImage *image = [[PKResManager getInstance] imageForKey:@"sendbutton"];
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.frame = CGRectMake(120.0f, 100.0f, image.size.width, image.size.height);
    [self.view addSubview:self.imageView];
    
    for (int index = 0; index < 160; index ++) {
        StyledView *view = [[StyledView alloc] initWithFrame:CGRectMake(index*2, 130.0, 1, 20)];
        [self.view addSubview:view];
        [view release];
    }
    
    __block UILabel *progressLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0f, 50, 30)];
    [self.view addSubview:progressLabel];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    CGRect frame = _progressView.frame;
    frame.origin.x  = 80.0f;
    frame.origin.y = 20.0f;
    _progressView.frame = frame;
    [_progressView setProgress:0.0f];
    [self.view addSubview:_progressView];

    
    [[PKResManager getInstance] changeStyleOnProgress:^(double progress) {
        NSLog(@" progress:%.1f",progress);
        progressLabel.text = [NSString stringWithFormat:@"%.1f",progress];
        [progressLabel setNeedsLayout];
        [progressLabel setNeedsDisplay];
        [_progressView setProgress:(float)progress];
        [_progressView setNeedsLayout];
        [_progressView setNeedsDisplay];
        
    }];    
    


    
    [self addTestBtn];
        
    // test save custom style
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"testSave" ofType:@"bundle"]];    
    [[PKResManager getInstance] saveStyle:CUSTOM_STYLE withBundle:bundle];
    //[[PKResManager getInstance] deleteStyle:CUSTOM_STYLE];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Private
- (void)customAction
{
    [_progressView setProgress:0.0f];
    [[PKResManager getInstance] swithToStyle:CUSTOM_STYLE];   
}
- (void)changeAction
{
    [_progressView setProgress:0.0f];
    if ([[PKResManager getInstance].styleName isEqualToString:SYSTEM_STYLE_LIGHT]) {
        [[PKResManager getInstance] swithToStyle:SYSTEM_STYLE_NIGHT];
    }else {
        [[PKResManager getInstance] swithToStyle:SYSTEM_STYLE_LIGHT];
    }
}
- (void)resetAction
{
    [[PKResManager getInstance] resetStyle];
}
- (void)addTestBtn
{
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50.0f, 300.0f, 65.0f, 30.0f)];
    [changeBtn setTitle:@"change" forState:UIControlStateNormal];
    changeBtn.backgroundColor = [UIColor redColor];
    [changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:changeBtn];
    [changeBtn release];
    
    
    UIButton *savedBtn = [[UIButton alloc] initWithFrame:CGRectMake(200.0f, 300.0f, 65.0f, 30.0f)];
    [savedBtn setTitle:@"custom" forState:UIControlStateNormal];
    savedBtn.backgroundColor = [UIColor blueColor];
    [savedBtn addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:savedBtn];
    [savedBtn release];

    
    UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 350.0f, 65.0f, 30.0f)];
    [resetBtn setTitle:@"reset" forState:UIControlStateNormal];
    resetBtn.backgroundColor = [UIColor blackColor];
    [resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:resetBtn];
    [resetBtn release];    
}
#pragma mark - PKResChangeStyleDelegate
- (void)changeStyle:(id)sender
{
    UIImage *image = [[PKResManager getInstance] imageForKey:@"sendbutton"];
    _imageView.image = image;
    [_imageView setNeedsDisplay];
    [_imageView setNeedsLayout];
}

@end