//
//  MSSecurity.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/15.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSA.h"
#import "AES.h"
#import "Base64.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  MIS 数据加密解密
 *
 *  MIS 登录接口数据和密码传输采用RSA加密方式。（登录之前需要调用公钥接口获取公钥）
 *  其他接口数据采用AES加密方式。
 *  AES Key 生成规则：md5(32位随机数+UUID+当前时间) (必须是128bits 位)
 */
@interface MSSecurity : NSObject

#pragma mark - RSA

/**
 *  MIS 数据RSA加密
 *
 *  @param plaintext 明文
 *  @param publicKey 公钥
 *
 *  @return 密文 十六进制编码暗文
 */
+ (nullable NSString *)rsa_encrypt:(NSString *)plaintext publicKey:(NSString *)publicKey;

/**
 *  MIS 数据RSA解密
 *
 *  @param ciphertext 密文
 *  @param publicKey  公钥
 *
 *  @return 明文
 */
+ (nullable NSString *)rsa_decrypt:(NSString *)ciphertext publicKey:(NSString *)publicKey;

#pragma mark - AES

/**
 *  生成AES Key，此Key用作与服务器数据进行加解密操作 （每一次重新登录，重新生成一次AES Key）
 *  AES Key 生成规则：md5(32位字符 + UUID + 当前时间戳)
 *
 *  @return AES Key
 */
+ (nullable NSString *)generateAESKey;

/**
 *  从钥匙串中获取AES Key
 *
 *  @return AES Key
 */
+ (nullable NSString *)AESKey;

/**
 *  MIS 数据AES加密，加密Key为用户的AES Key
 *
 *  @param plaintext 明文
 *  @return 密文 base64 encoded string
 */
+ (nullable NSString *)aes_encrypt:(NSString *)plaintext;

/**
 *  MIS 数据AES解密，解密Key为用户的AES Key
 *
 *  @param ciphertext 密文
 *  @return 明文 base64 encoded string
 */
+ (nullable NSString *)aes_decrypt:(NSString *)ciphertext;

//#pragma mark - Key Chain
//
///**
// *  保存密码到钥匙串
// *
// *  @param password    密码
// *  @param serviceName <#serviceName description#>
// *  @param account     <#account description#>
// *
// *  @return <#return value description#>
// */
//+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account;
//
//+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account;

#pragma mark - Hex

/**
 *  NSData 转 二进制串
 *
 *  @param data 数据源
 *  @return 二进制串
 */
+ (nullable NSString *)hexEncode:(NSData *)data;

/**
 *  二进制串 转 NSData
 *
 *  @param data 二进制串
 *  @return NSData
 */
+ (nullable NSData *)hexDecode:(NSString *)data;

#pragma mark - MD5

/**
 *  md5 加密
 *
 *  @param hashString 待加密的字符串
 *  @return 加密串
 */
+ (nullable NSString *)md5:(NSString *)hashString;
+ (nullable NSString *)md5WithData:(NSData *)hashData;

#pragma mark - SHA1

/**
 *  SHA1 加密
 *
 *  @param hashString 待加密的字符串
 *  @return 加密串
 */
+ (nullable NSString *)sha1:(NSString *)hashString;
+ (nullable NSString *)sha1WithData:(NSData *)hashData;

#pragma mark - SHA256

/**
 *  SHA256 加密
 *
 *  @param hashString 待加密的字符串
 *  @return 加密串
 */
+ (nullable NSString *)sha256:(NSString *)hashString;
+ (nullable NSString *)sha256WithData:(NSData *)hashData;

@end

NS_ASSUME_NONNULL_END
