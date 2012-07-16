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
    [[PKResManager getInstance] removeChangeStyleObject:self];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[PKResManager getInstance] addChangeStyleObject:self];
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

#pragma mark - delegate
- (void)changeStyle:(id)sender
{
    [NSThread sleepForTimeInterval:0.02f];
    if (self.backgroundColor != [UIColor blueColor]) {
        self.backgroundColor = [UIColor blueColor];
    }else {
        self.backgroundColor = [UIColor redColor];
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
