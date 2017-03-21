//
//  MSSecurity.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/15.
//  Copyright © 2016年 58. All rights reserved.
//

#import "MSSecurity.h"
#import <CommonCrypto/CommonHMAC.h>
#import <SAMKeychain/SAMKeychain.h>

@implementation MSSecurity

#pragma mark - RSA

+ (NSString *)rsa_encrypt:(NSString *)plaintext publicKey:(NSString *)publicKey {
    // 将明文数据使用UTF-8编码
    NSData *plaintextData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    // 将十六进制的公钥解码
    NSData *publicKeyData = [MSSecurity hexDecode:publicKey];
    // 将解码后的公钥数据进行base64编码
    publicKey = [publicKeyData base64EncodedString];
    // RSA 加密
    NSData *ciphertextData = [RSA encryptData:plaintextData publicKey:publicKey];
    // 将RSA 加密数据进行十六进制转换
    NSString *ciphertext = [MSSecurity hexEncode:ciphertextData];
    return ciphertext;
}

+ (NSString *)rsa_decrypt:(NSString *)ciphertext publicKey:(NSString *)publicKey {
    // TODO: RSA 解密
    return nil;
}

#pragma mark - AES

+ (NSString *)generateAESKey {
    NSInteger length = 32;
    char data[length];
    for (int x = 0; x < length; data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *random32Bit = [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
    
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *aesKey = [NSString stringWithFormat:@"%@%@%ld", random32Bit, uuid, (long)timeInterval];
    // 对生成的AES Key 进行 MD5，后台约定为128bits 的Key。
    aesKey = [self md5:aesKey];
    
    // 保存AES Key 到钥匙串中
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *account = [NSString stringWithFormat:@"%@-AES-Key", bundleId];
    [SAMKeychain setPassword:aesKey forService:bundleId account:account];
    return aesKey;
}

+ (NSString *)AESKey {
    // TODO: MIS4.0升级 更换
    return @"";
//    return [MISLoginManager sharedManager].loginData.userKey;
    
//    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
//    NSString *account = [NSString stringWithFormat:@"%@-AES-Key", bundleId];
//    return [SAMKeychain passwordForService:bundleId account:account];
}

+ (NSString *)aes_encrypt:(NSString *)plaintext {
    NSString *key = [self AESKey];//@"0B88052C20A221B704E4254223D2891C";
    NSData *encryptData = [AES encrypt:plaintext key:key];
    return [encryptData base64EncodedString];
}

+ (NSString *)aes_decrypt:(NSString *)ciphertext {
    NSString *key = [self AESKey];//@"0B88052C20A221B704E4254223D2891C";
    return [AES decrypt:ciphertext key:key];
}

#pragma mark - Hex

// convert hex string to NSData
+ (NSData *)hexDecode:(NSString *)data {
    if (data.length == 0) return nil;
    
    static const unsigned char HexDecodeChars[] = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, // 49
        2, 3, 4, 5, 6, 7, 8, 9, 0, 0, // 59
        0, 0, 0, 0, 0, 10, 11, 12, 13, 14,
        15, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // 79
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 10, 11, 12,   // 99
        13, 14, 15
    };
    
    // convert data(NSString) to CString
    const char *source = [data cStringUsingEncoding:NSUTF8StringEncoding];
    // malloc buffer
    unsigned char *buffer;
    NSUInteger length = strlen(source) / 2;
    buffer = malloc(length);
    for (NSUInteger index = 0; index < length; index++) {
        buffer[index] = (HexDecodeChars[source[index * 2]] << 4) + (HexDecodeChars[source[index * 2 + 1]]);
    }
    // init result NSData
    NSData *result = [NSData dataWithBytes:buffer length:length];
    free(buffer);
    source = nil;
    
    return  result;
}

// convert NSData to hex string
+ (NSString *)hexEncode:(NSData *)data {
    if (data.length == 0) { return nil; }
    
    //    static const char HexEncodeChars[] = "0123456789ABCDEF";
    static const char HexEncodeChars[] = "0123456789abcdef";
    char *resultData;
    // malloc result data
    resultData = malloc([data length] * 2 +1);
    // convert imgData(NSData) to char[]
    unsigned char *sourceData = ((unsigned char *)[data bytes]);
    NSUInteger length = [data length];
    
    for (NSUInteger index = 0; index < length; index++) {
        // set result data
        resultData[index * 2] = HexEncodeChars[(sourceData[index] >> 4)];
        resultData[index * 2 + 1] = HexEncodeChars[(sourceData[index] % 0x10)];
    }
    resultData[[data length] * 2] = 0;
    
    // convert result(char[]) to NSString
    NSString *result = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    sourceData = nil;
    free(resultData);
    
    return result;
}

#pragma mark - MD5

+ (NSString *)md5:(NSString *)hashString {
    return [self md5WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)md5WithData:(NSData *)hashData {
    unsigned char *digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([hashData bytes], (CC_LONG)[hashData length], digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    free(digest);
    return result;
}

#pragma mark - SHA1

+ (NSString *)sha1:(NSString *)hashString {
    return [self sha1WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)sha1WithData:(NSData *)hashData {
    unsigned char *digest;
    digest = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CC_SHA1([hashData bytes], (CC_LONG)[hashData length], digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    free(digest);
    return result;
}

#pragma mark - SHA256

+ (NSString *)sha256:(NSString *)hashString {
    return [self sha256WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)sha256WithData:(NSData *)hashData {
    unsigned char *digest;
    digest = malloc(CC_SHA256_DIGEST_LENGTH);
    
    CC_SHA256([hashData bytes], (CC_LONG)[hashData length], digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    free(digest);
    
    return result;
}

@end
