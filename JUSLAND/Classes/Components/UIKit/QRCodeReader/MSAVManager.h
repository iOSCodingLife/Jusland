//
//  MSAVManager.h
//  MIS
//
//  Created by LIUZHEN on 2017/2/18.
//  Copyright © 2017年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSAVManager : NSObject

#pragma mark -相机、相册权限

/**
 *  校验相机权限
 *
 *  @return YES: 拥有权限 NO: 没有权限
 */
+ (BOOL)checkCameraAuthorization;

/**
 *  校验相册权限
 *
 *  @return YES: 拥有权限 NO: 没有权限
 */
+ (BOOL)checkPhotoAuthorization;

/**
 *  开启关闭闪光灯
 *
 *  @param bOpen YES:开启，NO：关闭
 */
- (void)openFlash:(BOOL)status;


/**
 *  开启或关闭闪光灯
 *  之前是开启，则这次是关闭
 *  之前是关闭，则这次是开启
 */
- (void)openOrCloseFlash;

#pragma mark- 震动、声音效果

/**
 *  识别成功震动提醒
 */
+ (void)systemVibrate;

/**
 *  扫码成功声音提醒
 */
+ (void)systemSound;

/**
 *  获取摄像机最大拉远镜头
 *  @return 放大系数
 */
- (CGFloat)getVideoMaxScale;

/**
 * 拉近拉远镜头
 *  @param scale 系数
 */
- (void)setVideoScale:(CGFloat)scale;

@end
