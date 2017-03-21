//
//  MSUtility.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/11.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MSNetworkReachabilityStatus) {
    MSNetworkReachabilityStatusUnknown         = 0,
    MSNetworkReachabilityStatusNotReachable    = 1,
    MSNetworkReachabilityStatusWWAN2G          = 2,
    MSNetworkReachabilityStatusWWAN3G          = 3,
    MSNetworkReachabilityStatusWWAN4G          = 4,
    MSNetworkReachabilityStatusWiFi            = 5
};

@interface MSUtility : NSObject

/**
 *  获取头像圆角
 *
 *  @param size 头像size
 *
 *  @return 头像圆角
 */
+ (CGFloat)avatarRadius:(CGSize)size;

// TODO: MIS4.0升级 更换
///**
// *  设置头像
// *
// *  @param imageView 头像视图
// *  @param user 用户数据
// */
//+ (void)setAvatar:(UIImageView *)imageView forUser:(MSUser *)user;

/**
 *  设备唯一标识
 *
 *  @return NSString
 */
+ (NSString *)UUID;

/**
 *  设备版本
 *
 *  @return e.g. iPhone 7 Plus
 */
+ (NSString *)deviceModel;

/**
 *  获取设备当前网络状态，仅在设置接口头信息时使用。其他地方要获取网络状态不要使用该方法
 *
 *  @return NetworkReachabilityStatus
 */
+ (MSNetworkReachabilityStatus)currentNetWorkStates;

@end
