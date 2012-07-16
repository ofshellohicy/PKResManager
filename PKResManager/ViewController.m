//
//  ViewController.m
//  PKResManager
//
//  Created by zhong sheng on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
//#import "TestView.h"

#define CUSTOM_STYLE @"customStyle"

@interface ViewController ()
- (void)customAction;
- (void)changeAction;
- (void)addTestBtn;
@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation ViewController
@synthesize imageView = _imageView;

- (void)dealloc
{
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
    [[PKResManager getInstance] swithToStyle:CUSTOM_STYLE];   
}
- (void)changeAction
{
    if ([[PKResManager getInstance].styleName isEqualToString:SYSTEM_STYLE_LIGHT]) {
        [[PKResManager getInstance] swithToStyle:SYSTEM_STYLE_NIGHT];
    }else {
        [[PKResManager getInstance] swithToStyle:SYSTEM_STYLE_LIGHT];
    }
}
- (void)addTestBtn
{
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50.0f, 300.0f, 60.0f, 30.0f)];
    [changeBtn setTitle:@"change" forState:UIControlStateNormal];
    changeBtn.backgroundColor = [UIColor redColor];
    [changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:changeBtn];
    [changeBtn release];
    
    
    UIButton *savedBtn = [[UIButton alloc] initWithFrame:CGRectMake(200.0f, 300.0f, 60.0f, 30.0f)];
    [savedBtn setTitle:@"custom" forState:UIControlStateNormal];
    savedBtn.backgroundColor = [UIColor blueColor];
    [savedBtn addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:savedBtn];
    [savedBtn release];
    
    [[PKResManager getInstance] changeStyleOnProgress:^(double progress) {
        NSLog(@" progress:%.1f",progress);
    }];
    
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