//
//  MSServerTimeHelper.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/21.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSServerTimeHelper : NSObject

/**
 *  保存服务端时间
 *
 *  @param timeInterval 服务端时间戳
 */
+ (void)saveServerTimeInterval:(NSTimeInterval)timeInterval;

/**
 *  获取设备时间与服务端时间的偏移量
 *
 *  @return NSTimeInterval
 */
+ (NSTimeInterval)timeIntervalOffset;

/**
 *  获取服务端时间戳
 *
 *  @return NSTimeInterval
 */
+ (NSTimeInterval)serverTimeInterval;

@end

NS_ASSUME_NONNULL_END

