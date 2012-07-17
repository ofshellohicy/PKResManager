//
//  PKAllStyleViewController.m
//  PKResManager
//
//  Created by zhong sheng on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKAllStyleViewController.h"
#import "StyledView.h"

#define CUSTOM_STYLE @"customStyle"

@interface PKAllStyleViewController ()
- (void)customAction;
- (void)changeAction;
- (void)addTestBtn;
- (void)addAllStyleView;
- (void)addProgressView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIScrollView *scrollView;
@end

@implementation PKAllStyleViewController

@synthesize 
imageView = _imageView,
scrollView = _scrollView;

- (void)dealloc
{
    [[PKResManager getInstance] removeChangeStyleObject:self];
    self.scrollView = nil;
    self.imageView = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PKResManager getInstance] addChangeStyleObject:self];    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"all style";
    
    [self addAllStyleView];
    
    [self addProgressView];

    // button
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
- (void)addAllStyleView
{
    int rowCount = 300;
    
    CGRect frame = CGRectMake(0.0f, 30, self.view.bounds.size.width, self.view.bounds.size.height-120.0f);
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, rowCount*60)];
    [self.view addSubview:_scrollView];
    
    for (int row = 0; row < rowCount; row ++) {
        for (int col = 0; col < 2; col ++) {
            StyledView *view = [[StyledView alloc] initWithFrame:CGRectMake(col*160, row*60, 150, 50)];
            [_scrollView addSubview:view];
            [view release];            
        }
    }   
}
- (void)addProgressView
{
    // percent 
    UILabel *progressLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 50, 30)];
    progressLabel.text = @"0.0%%";
    progressLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:progressLabel];
    
    // time
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(270.0f, 0.0f, 50, 30)];
    timeLabel.text = @"0.00'";
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:timeLabel];
    
    // view
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    CGRect frame = progressView.frame;
    frame.origin.x = 80.0f;
    frame.origin.y = 10.0f;
    progressView.frame = frame;
    [progressView setProgress:0.0f];
    [self.view addSubview:progressView];
    __block NSDate *startDate = [NSDate date];
    __block BOOL needreset = YES;
    __block NSTimeInterval time = 0.0f;
    [[PKResManager getInstance] changeStyleOnProgress:^(double progress) {        
        if (needreset) {
            startDate = [NSDate date];
            needreset = NO;
        }
        progressLabel.text = [NSString stringWithFormat:@"%.1f%%",progress*100];
        
        [progressView setProgress:(float)progress];
        if (progress >= 1.0f) {
//            time = [[NSDate date] timeIntervalSinceDate:startDate];            
            timeLabel.text = [NSString stringWithFormat:@"%.2f'",time];
            timeLabel.text = [NSString stringWithFormat:@"%@",[NSDate date]];
            needreset = YES;
        }
    }];   
    
}
- (void)customAction
{
    [[PKResManager getInstance] swithToStyle:CUSTOM_STYLE];   
}
- (void)changeAction
{
    if ([[PKResManager getInstance].styleName isEqualToString:SYSTEM_STYLE_LIGHT]) 
    {
        [[PKResManager getInstance] swithToStyle:SYSTEM_STYLE_NIGHT];
    }
    else 
    {
        [[PKResManager getInstance] swithToStyle:SYSTEM_STYLE_LIGHT];
    }
}
- (void)resetAction
{
    [[PKResManager getInstance] resetStyle];
}
- (void)addTestBtn
{
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 380.0f, 80.0f, 30.0f)];
    [changeBtn setTitle:@"change" forState:UIControlStateNormal];
    changeBtn.backgroundColor = [UIColor redColor];
    [changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:changeBtn];
    [changeBtn release];
    
    
    UIButton *savedBtn = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 380.0f, 80.0f, 30.0f)];
    [savedBtn setTitle:@"custom" forState:UIControlStateNormal];
    savedBtn.backgroundColor = [UIColor blueColor];
    [savedBtn addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:savedBtn];
    [savedBtn release];
    
    
    UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(220.0f, 380.0f, 80.0f, 30.0f)];
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