//
//  PKResManager.h
//  TestResManager
//
//  Created by zhong sheng on 12-7-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ResStyleProgressBlock) (double progress);

typedef enum {
    ResStyleType_System,
    ResStyleType_Custom,
    ResStyleType_Unknow
}ResStyleType;


@protocol PKResChangeStyleDelegate <NSObject>
@optional
- (void)changeStyle:(id)sender;
@end

@interface PKResManager : NSObject
/*!
 * All style name
 */
@property (nonatomic, readonly) NSMutableArray *styleNameArray;
/*!
 * Current style name
 */
@property (nonatomic, readonly) NSString *styleName;
/*!
 * Current style type
 */
@property (nonatomic, readonly) ResStyleType styleType;
/*!
 * is loading?
 */
@property (nonatomic, readonly) BOOL isLoading;
// Add style Object
- (void)addChangeStyleObject:(id)object;
// Object dealloc invoke this method!!!
- (void)removeChangeStyleObject:(id)object;
/*!
 * Switch to style by name
 */
- (void)swithToStyle:(NSString *)name;
/*!
 * get change progress
 */
- (void)changeStyleOnProgress:(ResStyleProgressBlock)progressBlock;

/*!
 * save in custom file path
 */
- (BOOL)saveStyle:(NSString *)name withBundle:(NSBundle *)bundle;
/*!
 * delete style
 */
- (BOOL)deleteStyle:(NSString *)name;

/*!
 * clear image cache
 */
- (void)clearImageCache;
/*!
 * reset
 */
- (void)resetStyle;

/*!
 *   @method
 *   @abstract get image by key 
 *   @param needCache , will cached
 */
- (UIImage *)imageForKey:(id)key cache:(BOOL)needCache;
- (UIImage *)imageForKey:(id)key;

// 这些都存着么
- (UIFont *)fontForKey:(id)key;

- (UIColor *)colorForKey:(id)key;

+ (PKResManager*)getInstance;

@end
