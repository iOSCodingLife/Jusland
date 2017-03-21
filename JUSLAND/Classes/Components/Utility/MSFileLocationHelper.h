//
//  MSFileLocationHelper.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/20.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSFileLocationHelper : NSObject

/**
 *  MIS 数据存储主目录
 *
 *  @return 主目录
 */
+ (nullable NSString *)getAppDocumentPath;

/**
 *  MIS 当前登录用户数据目录
 *
 *  @return 当前登录用户目录
 */
+ (nullable NSString *)getUserDirectory;

/**
 *  MIS 缓存数据目录
 *
 *  @return 缓存数据目录
 */
+ (nullable NSString *)getAppTempPath;

@end

NS_ASSUME_NONNULL_END

