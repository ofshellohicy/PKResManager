//
//  ResManagerKit.h
//  TestResManager
//
//  Created by zhong sheng on 12-7-16.
//  Copyright (c) 2012年 . All rights reserved.
//

#ifndef PKResManagerKit_PKResManagerKit_h
#define PKResManagerKit_PKResManagerKit_h

#ifndef __IPHONE_4_0
#error "PKResManager uses features only available in iOS SDK 4.0 and later."
#endif

#import "PKResManagerKit.h"

#define BUNDLE_PREFIX @"bundle://"
#define DOCUMENTS_PREFIX @"documents://"

#define kAllResStyle @"kAllResStyle"
#define CUSTOM_THEME_DIR @"CustomStyleDir"
#define TEMP_CUSTOM_THEME_DIR @"TempCustomStyleDir" 

#define SYSTEM_STYLE_LIGHT @"light"
#define SYSTEM_STYLE_NIGHT @"night"
#define SYSTEM_STYLE_LIGHT_URL @"bundle://skintype_light.bundle" 
#define SYSTEM_STYLE_NIGHT_URL @"bundle://skintype_night.bundle" 

#define COLOR_AND_FONT    @"color_font"

#endif