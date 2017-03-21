//
//  AES.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/14.
//  Copyright © 2016年 58. All rights reserved.
//

#import "AES.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Base64.h"
#import "MSSecurity.h"

@implementation AES

+ (NSData *)encrypt:(NSString *)data key:(NSString *)key {
    NSData *plainTextData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [MSSecurity hexDecode:key];
    
    NSUInteger dataLength = [plainTextData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t encryptedSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,                                   // 加密
                                          kCCAlgorithmAES128,                           // AES128 解密算法
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,     // MIS后台加密方式为kCCOptionPKCS5Padding
                                          [keyData bytes],                              // Key 二进制数据
                                          [keyData length], // kCCKeySizeAES128,        // kCCKeySizeAES Key的长度
                                          NULL, // [iv bytes], // 如果采用kCCOptionECBMode加密方式，除了密钥之外，加解密初始化向量也必须一致
                                          [plainTextData bytes],                        // 明文 二进制数据
                                          dataLength,                                   // 明文数据长度
                                          buffer,                                       // 加密数据的缓冲区
                                          bufferSize,                                   // 加密数据的缓冲区大小
                                          &encryptedSize);                              // 加密数据的大小
    
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
        return encryptData;
    }
    
    free(buffer);
    return nil;
}

+ (NSString *)decrypt:(NSString *)data key:(NSString *)key {
    NSData *ciphertextBase64Data = [data base64DecodedData];
    NSData *keyData = [MSSecurity hexDecode:key];
    
    NSUInteger dataLength = [ciphertextBase64Data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t decryptedSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,                                   // 解密
                                          kCCAlgorithmAES128,                           // AES128 解密算法
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,     // MIS后台加密方式为kCCOptionPKCS5Padding
                                          [keyData bytes],                              // Key 二进制数据
                                          [keyData length], // kCCKeySizeAES128,        // kCCKeySizeAES Key的长度
                                          NULL, // [iv bytes], // 如果采用kCCOptionECBMode加密方式，除了密钥之外，加解密初始化向量也必须一致
                                          [ciphertextBase64Data bytes],                 // 密文 二进制数据
                                          dataLength,                                   // 密文数据长度
                                          buffer,                                       // 解密数据的缓冲区
                                          bufferSize,                                   // 解密数据的缓冲区大小
                                          &decryptedSize);                              // 解密数据的大小
    
    
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
        return [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
    }
    
//    DDLogInfo(@"AES 解密失败。");
    free(buffer); // free the buffer;
    return nil;
}

@end
