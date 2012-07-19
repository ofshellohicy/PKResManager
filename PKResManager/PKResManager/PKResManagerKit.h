//
//  PKResManager.h
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

#import "PKResManager.h"

#define BUNDLE_PREFIX @"bundle://"
#define DOCUMENTS_PREFIX @"documents://"

#define kAllResStyle @"kAllResStyle"
#define SAVED_STYLE_DIR @"SavedStyleDir"
#define TEMP_STYLE_DIR @"TempStyleDir" 

#define kStyleName     @"kStyleName"
#define kStyleVersion  @"kStyleVersion"
#define kStylePerview  @"kStylePerview" // e...
#define kStyleURL      @"kStyleURL"

#define SYSTEM_STYLE_LIGHT @"light"
#define SYSTEM_STYLE_NIGHT @"night"
#define SYSTEM_STYLE_LIGHT_URL @"bundle://skintype_light.bundle" 
#define SYSTEM_STYLE_NIGHT_URL @"bundle://skintype_night.bundle" 
#define SYSTEM_STYLE_VERSION @"SYSTEM_STYLE_VERSION"

#define COLOR_AND_FONT    @"#color_font"

#endif