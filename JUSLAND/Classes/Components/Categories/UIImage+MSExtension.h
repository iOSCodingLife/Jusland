//
//  UIImage+MSExtension.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/13.
//  Copyright © 2016年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MSExtension)

/**
 *  生成一张纯色图片
 *
 *  @param color 图片颜色
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  图片渲染上色
 *
 *  @param tintColor 渲染色
 *
 *  @return 渲染后的图片
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

@end
