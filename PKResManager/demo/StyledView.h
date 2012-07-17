//
//  StyledView.h
//  PKResManager
//
//  Created by zhong sheng on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKResManagerKit.h"

@interface StyledView : UIView <PKResChangeStyleDelegate>
{
    BOOL _isDefault;
    UIImageView *_imageView;
    UILabel *_label;
}

@end
