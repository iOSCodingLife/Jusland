//
//  AES.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/14.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES : NSObject

/**
 *  AES 加密 kCCOptionPKCS5Padding 加密方式
 *
 *  @param data 明文
 *  @param key AES Key
 *  @return 密文
 */
+ (NSData *)encrypt:(NSString *)data key:(NSString *)key;

/**
 *  AES 解密 kCCOptionPKCS5Padding 解密方式
 *
 *  @param data 密文
 *  @param key AES Key
 *  @return 明文
 */
+ (NSString *)decrypt:(NSString *)data key:(NSString *)key;

@end
