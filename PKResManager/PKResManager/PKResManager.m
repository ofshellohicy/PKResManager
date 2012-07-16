//
//  PKResManager.m
//  TestResManager
//
//  Created by zhong sheng on 12-7-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "PKResManager.h"
#import "PKResManagerKit.h"

static const void* RetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void ReleaseNoOp(CFAllocatorRef allocator, const void *value) { }
NSMutableArray* CreateNonRetainingArray() {
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = RetainNoOp;
    callbacks.release = ReleaseNoOp;
    return (NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks);
}

static PKResManager *_instance = nil;

@interface PKResManager (/*private*/)
@property (nonatomic, retain) NSMutableArray *styleChangedHandlers;
@property (nonatomic, retain) NSBundle *styleBundle;
@property (nonatomic, retain) NSMutableArray *resObjectsArray;
@property (nonatomic, retain) NSMutableDictionary *resImageCache;
@property (nonatomic, retain) NSMutableDictionary *resOtherCache;
@property (nonatomic, retain) NSMutableArray *defaultStyleArray;
@property (nonatomic, retain) NSMutableArray *allStyleArray;
@property (nonatomic, retain) NSMutableArray *customStyleArray;

- (NSString *)getDocumentsDirectoryWithSubDir:(NSString *)subDir;
- (BOOL)isBundleURL:(NSString *)URL;
- (BOOL)isDocumentsURL:(NSString *)URL;
- (NSUInteger)styleTypeIndexByName:(NSString *)name;
- (void)saveCustomStyleArray;
- (NSMutableArray*)getSavedStyleArray;
@end

@implementation PKResManager

// public
@synthesize 
styleNameArray,
styleName = _styleName,
styleType = _styleType,
isLoading = _isLoading;

// private
@synthesize 
styleChangedHandlers = _styleChangedHandlers,
styleBundle = _styleBundle,
resObjectsArray = _resObjectsArray,
resImageCache = _resImageCache,
resOtherCache = _resOtherCache,
allStyleArray = _allStyleArray,
defaultStyleArray = _defaultStyleArray,
customStyleArray = _customStyleArray;

- (void)dealloc
{
    if (_styleName) {
        [_styleName release];
    }
    [self.styleChangedHandlers removeAllObjects];
    self.styleChangedHandlers = nil;
    self.styleBundle = nil;
    self.resObjectsArray = nil;
    self.resImageCache = nil;
    self.resOtherCache = nil;
    self.allStyleArray = nil;
    self.defaultStyleArray = nil;
    self.customStyleArray = nil;
    [super dealloc];
}

- (void)addChangeStyleObject:(id)object
{
    if (![_resObjectsArray containsObject:object]) 
    {
        [_resObjectsArray addObject:object];
    }
}

- (void)removeChangeStyleObject:(id)object
{
    if ([_resObjectsArray containsObject:object]) 
    {
        [_resObjectsArray removeObject:object];
    }
}

- (void)swithToStyle:(NSString *)name
{    
    if ([_styleName isEqualToString:name] 
        || name == nil 
        || _isLoading) 
    {
        return;
    }
    
    _isLoading = YES;
    
    _styleName = name;
    
    // get style index
    NSInteger index = [self styleTypeIndexByName:name];
    NSAssert(index != NSNotFound , @"error: index not found"); 
    
    NSDictionary *styleDict = [self.allStyleArray objectAtIndex:index];
    NSString *bundleName = [styleDict objectForKey:name];
    NSString *filePath = nil;
    NSString *bundlePath = nil;
    
    if ([self isBundleURL:bundleName]) 
    {
        _styleType = ResStyleType_System;
        filePath = [[NSBundle mainBundle] bundlePath];
        bundlePath = [NSString stringWithFormat:@"%@/%@",filePath,[bundleName substringFromIndex:BUNDLE_PREFIX.length]];
    }
    else if([self isDocumentsURL:bundleName])
    {
        _styleType = ResStyleType_Custom;
        filePath = [self getDocumentsDirectoryWithSubDir:CUSTOM_THEME_DIR];
        bundlePath = [NSString stringWithFormat:@"%@/%@",filePath,[bundleName substringFromIndex:DOCUMENTS_PREFIX.length]];
    }
    else 
    {
        NSLog(@"na ni !!! bundleName:%@",bundleName);
        _isLoading = NO;
        return;
    }
        
    NSLog(@"bundlePath:%@",bundlePath);
    
    // read resource bundle
    self.styleBundle = [NSBundle bundleWithPath:bundlePath];
    NSAssert(self.styleBundle != nil , @"error: _styleBundle == nil"); 
    
    // get plist dict
    NSString *plistPath=[self.styleBundle pathForResource:COLOR_AND_FONT ofType:@"plist"];    
    self.resOtherCache = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    // remove cache
    [_resImageCache removeAllObjects]; 
    [_resOtherCache removeAllObjects];    
    
    // change style
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        for (int i=0; i < [_resObjectsArray count];i++) 
        {
            id object = [_resObjectsArray objectAtIndex:i];
            if ([object respondsToSelector:@selector(changeStyle:)]) 
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [object changeStyle:self];
                });
            }
            else 
            {
                NSLog(@" change style failed ! => %@",object);
            }
            
            for(ResStyleProgressBlock progressBlock in self.styleChangedHandlers) 
            {            
                double progress = (double)(i+1) / (double)(_resObjectsArray.count);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    progressBlock(progress);
                });
                
            }
        }
        
    });

    _isLoading = NO;
}

- (void)changeStyleOnProgress:(ResStyleProgressBlock)progressBlock
{
    [self.styleChangedHandlers addObject:[progressBlock copy]];
}

- (BOOL)deleteStyle:(NSString *)name
{
    NSUInteger index = [self styleTypeIndexByName:name];
    // default style ,can not delete
    if (index < self.defaultStyleArray.count 
        || index == NSNotFound) 
    {
        return NO;
    }

    NSDictionary *styleDict = [self.allStyleArray objectAtIndex:index];
    NSString *bundleName = [(NSString *)[styleDict.allValues objectAtIndex:0] 
                            substringFromIndex:DOCUMENTS_PREFIX.length];
    BOOL isDir=NO;
    NSError *error = nil;
    NSString *stylePath = [[self getDocumentsDirectoryWithSubDir:CUSTOM_THEME_DIR] 
                           stringByAppendingFormat:@"/%@",bundleName];
    NSFileManager *fileManager = [NSFileManager defaultManager];    
    if (![fileManager fileExistsAtPath:stylePath isDirectory:&isDir] && isDir)
    {
        NSLog(@" file unexitsts");
        return NO;
    }
    if (![fileManager removeItemAtPath:stylePath error:&error]) 
    {
        NSLog(@" delete file error:%@",error);
        return NO;
    }

    [self.allStyleArray removeObjectAtIndex:index];
    
    [self saveCustomStyleArray];
    
    NSLog(@" %@",self.allStyleArray);

    return YES;    
}

- (BOOL)saveStyle:(NSString *)name withBundle:(NSBundle *)bundle
{    
    NSString *bundlePath = bundle.resourcePath;
    NSArray *elementArray = [bundlePath componentsSeparatedByString:@"/"];
    NSString *bundleName = [elementArray lastObject];
    if (bundleName != nil) 
    {
        NSUInteger index = [self styleTypeIndexByName:name];
        NSDictionary *styleDict = nil;
        if (index != NSNotFound) 
        {
            styleDict = [self.allStyleArray objectAtIndex:index];
            if (![[styleDict.allValues objectAtIndex:0] isEqualToString:bundleName]) 
            {
                NSDictionary *newStyleDict = [NSDictionary dictionaryWithObject:
                                              [NSString stringWithFormat:@"%@%@",DOCUMENTS_PREFIX,bundleName]
                                                                         forKey:name];
                [self.allStyleArray replaceObjectAtIndex:index withObject:newStyleDict];                
                [self saveCustomStyleArray];
            }
        }
        if (styleDict == nil) {
            styleDict = [NSDictionary dictionaryWithObject:
                         [NSString stringWithFormat:@"%@%@",DOCUMENTS_PREFIX,bundleName]
                                                    forKey:name];
            [self.allStyleArray addObject:styleDict];                    
            [self saveCustomStyleArray];
        }
        
        // file operation
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *customStylePath = [[self getDocumentsDirectoryWithSubDir:CUSTOM_THEME_DIR] stringByAppendingFormat:@"/%@",bundleName];
        // if exist , overwrite 
        if ([fileManager fileExistsAtPath:customStylePath]) 
        {
            NSError *updateError = nil;
            NSLog(@" exist <%@>",name);
            if (![fileManager removeItemAtPath:customStylePath error:&updateError]) 
            {
                NSLog(@"updateError:%@",updateError);
            }
        }
        if (![fileManager copyItemAtPath:bundlePath toPath:customStylePath error:&error]) 
        {
            NSLog(@"error :%@",error);
            return NO;
        }        
        NSLog(@"after delete %@",self.allStyleArray);
        return YES;
    }
    return NO;
}

- (void)clearImageCache
{
    [_resImageCache removeAllObjects];
//    [_resOtherCache removeAllObjects];
}
- (void)resetStyle
{
    if (!_styleChangedHandlers) {
        _styleChangedHandlers = [[NSMutableArray alloc] init];
    }
    if (!_resObjectsArray) {
        _resObjectsArray = CreateNonRetainingArray(); // 不retain的数组                
    }
    if (!_resImageCache) {
        _resImageCache = [[NSMutableDictionary alloc] init];        
    }    
    if (!_resOtherCache) {
        _resOtherCache = [[NSMutableDictionary alloc] init];        
    }    
    
    [_resImageCache removeAllObjects];
    [_resOtherCache removeAllObjects];
    
    // get all style
    self.allStyleArray = [self getSavedStyleArray];

    // swith to default style
    _isLoading = NO;
    NSString *styleName = [self.styleNameArray objectAtIndex:0];    
    [self swithToStyle:styleName];
}
- (NSMutableArray *)styleNameArray
{
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:self.allStyleArray.count];
    [self.allStyleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *styleDict = (NSDictionary*)obj;
        [retArray addObject:[styleDict.allKeys objectAtIndex:0]];
    }];
    return retArray;
}
- (UIImage *)imageForKey:(id)key cache:(BOOL)needCache
{
    if (key == nil) {
        NSLog(@" imageForKey:cache: key = nil");
        return nil;
    }
    UIImage *image = [_resImageCache objectForKey:key];
    
    if (image == nil) 
    {
        NSString *imagePath = [self.styleBundle pathForResource:key ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:imagePath];
        
        if (image == nil) 
        {
            imagePath = [[NSBundle mainBundle] pathForResource:key ofType:@"png"];
            image = [UIImage imageWithContentsOfFile:imagePath];
        }

        if (image != nil && needCache) 
        {
            [_resImageCache setObject:image forKey:key];
        }
        //NSLog(@"imagePath:%@",imagePath);
    }
    // TODO:if error ,get default resource
    if (image == nil) {
        NSLog(@" will get default style => %@",key);
        return nil;
    }
    
    return image;
}
- (UIImage *)imageForKey:(id)key
{
    return [self imageForKey:key cache:YES];
}

- (UIFont *)fontForKey:(id)key
{
    // TODO:
    // 需不需要nil时给个默认值
    return nil;    
}

- (UIColor *)colorForKey:(id)key
{
    // TODO:
    // 需不需要nil时给个默认值    
    return nil;    
}
#pragma mark - Private

- (BOOL)isBundleURL:(NSString *)URL
{
    return [URL hasPrefix:BUNDLE_PREFIX];
}
- (BOOL)isDocumentsURL:(NSString *)URL
{
    return [URL hasPrefix:DOCUMENTS_PREFIX];
}
- (void)saveCustomStyleArray
{
    self.customStyleArray = [NSMutableArray arrayWithArray:self.allStyleArray];
    NSRange range;
    range.location = 0;
    range.length = self.defaultStyleArray.count;
    [self.customStyleArray removeObjectsInRange:range];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.customStyleArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAllResStyle];
}
- (NSMutableArray*)getSavedStyleArray
{
    if (!_defaultStyleArray) {
        _defaultStyleArray = [[NSMutableArray alloc] initWithObjects:
                              [NSDictionary dictionaryWithObject:SYSTEM_STYLE_LIGHT_URL
                                                          forKey:SYSTEM_STYLE_LIGHT],
                              [NSDictionary dictionaryWithObject:SYSTEM_STYLE_NIGHT_URL
                                                          forKey:SYSTEM_STYLE_NIGHT],
                              nil];
    }
    NSMutableArray *retArray = [NSMutableArray arrayWithArray:self.defaultStyleArray];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kAllResStyle];
    NSArray *customStyleArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [retArray addObjectsFromArray:customStyleArray];
    return retArray;
}

- (NSUInteger)styleTypeIndexByName:(NSString *)name
{
    __block NSUInteger styleIndex = NSNotFound;
    [self.allStyleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
    {
        NSDictionary *styleDict = (NSDictionary *)obj;
        NSString *styleName = [styleDict.allKeys objectAtIndex:0];
        if ([styleName isEqualToString:name]) 
        {
            styleIndex = idx;
            return;
        }
    }];
    
    return styleIndex;
}
// 
- (NSString *)getDocumentsDirectoryWithSubDir:(NSString *)subDir
{
    NSString *newDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) 
                              objectAtIndex:0];
    if (subDir) 
    {
        newDirectory = [newDirectory stringByAppendingPathComponent:subDir];
    }

    BOOL isDir = NO;
	BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:newDirectory isDirectory:&isDir];
    NSError *error;
	if(!isDir){
		[[NSFileManager defaultManager] removeItemAtPath:newDirectory error:nil];
	}
	if(!isExist || !isDir){
        if(![[NSFileManager defaultManager] createDirectoryAtPath:newDirectory 
                                      withIntermediateDirectories:NO attributes:nil error:&error])
        {
            NSLog(@"create file error：%@",error);
        }   
	}
    return newDirectory;
}


#pragma mark - Singeton
- (id)init{
    self = [super init];
    if (self) {
        [self resetStyle];
    }
    return self;
}

+ (PKResManager*)getInstance{
    @synchronized(self) { 
		if (_instance == nil) {
            [[self alloc] init];
		}
	}
	return _instance; 
}

+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) { 
		if (_instance == nil) {
			_instance = [super allocWithZone:zone];  // assignment and return on first allocation
			return _instance;
		}
	}
	return nil;
}
- (id) copyWithZone:(NSZone*) zone {
	return _instance;
}

- (id) retain {
	return _instance;
}

- (unsigned) retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (id) autorelease {
	return self;
}
- (oneway void)release
{
    return;
}

@end
