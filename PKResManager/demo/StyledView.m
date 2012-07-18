//
//  StyledView.m
//  PKResManager
//
//  Created by zhong sheng on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StyledView.h"

@implementation StyledView

- (void)dealloc
{
//    NSLog(@" dealloc :%@",[self description]);
    [[PKResManager getInstance] removeChangeStyleObject:self];
    [_imageView release];    
    [_label release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[PKResManager getInstance] addChangeStyleObject:self];
        self.backgroundColor = [[PKResManager getInstance] colorForKey:@"DemoModule-styleView"];
        _isDefault = YES;
        UIImage *image = [[PKResManager getInstance] imageForKey:@"sendbutton"];
        _imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 80, 30)];
        _label.backgroundColor = [UIColor clearColor];
        _label.text = @"Font Test";
        _label.font = [[PKResManager getInstance] fontForKey:@"DemoModule-label"];
        [_label setTextColor:[[PKResManager getInstance] colorForKey:@"DemoModule-label"]];
        [self addSubview:_label];
    }
    return self;
}

#pragma mark - delegate
- (void)changeStyle:(id)sender
{
//    NSLog(@" change :%@",[self description]);
    self.backgroundColor = [[PKResManager getInstance] colorForKey:@"DemoModule-styleView"];
    UIImage *image = [[PKResManager getInstance] imageForKey:@"sendbutton"];
    _imageView.image = image;
    _label.font = [[PKResManager getInstance] fontForKey:@"DemoModule-label"];
    [_label setTextColor:[[PKResManager getInstance] colorForKey:@"DemoModule-label"]];
    
    [self setNeedsLayout];
}

@end
