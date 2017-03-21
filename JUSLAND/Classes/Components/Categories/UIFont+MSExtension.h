//
//  UIFont+MSExtension.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/19.
//  Copyright © 2016年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (MSExtension)

#pragma mark - MIS UI Font

/**
 *  Size:12 px:24
 */
+ (UIFont *)ms_extraSmallFont;

/**
 *  Size:12 px:24
 */
+ (UIFont *)ms_extraSmallBoldFont;

/**
 *  Size:14 px:28
 */
+ (UIFont *)ms_smallFont;

/**
 *  Size:14 px:28
 */
+ (UIFont *)ms_smallBoldFont;

/**
 *  Size:16 px:32
 */
+ (UIFont *)ms_normalFont;

/**
 *  Size:16 px:32
 */
+ (UIFont *)ms_normalBoldFont;

/**
 *  Size:18 px:36
 */
+ (UIFont *)ms_largeFont;

/**
 *  Size:18 px:36
 */
+ (UIFont *)ms_largeBoldFont;

/**
 *  Size:20 px:40
 */
+ (UIFont *)ms_extraLargeFont;

/**
 *  Size:20 px:40
 */
+ (UIFont *)ms_extraLargeBoldFont;

@end
