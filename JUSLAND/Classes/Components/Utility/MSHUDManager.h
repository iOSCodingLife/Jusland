//
//  MSHUDManager.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/19.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHUDManager : NSObject

/**
 *  在当前View上显示提示信息
 */
+ (void)showToast:(NSString *)message;

/**
 *  在指定View上显示提示信息
 */
+ (void)showToast:(NSString *)message inView:(UIView *)view;

/**
 *  在当前View上显示loading视图（标题默认为加载中...）
 */
+ (void)showLoading;

/**
 *  在指定View上显示loading视图（标题默认为加载中...）
 */
+ (void)showLoadingInView:(UIView *)view;

/**
 *  在指定View上线显示指定标题的loading视图（标题默认为加载中...）
 */
+ (void)showLoadingInView:(UIView *)view withTitle:(NSString *)title;

/**
 *  隐藏当前视图上的loading视图
 */
+ (void)hideHUD;

/**
 *  隐藏指定View上的loading视图
 */
+ (void)hideHUDForView:(UIView *)view;

@end
