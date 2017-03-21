//
//  MSRequestManager.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/8.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

/**
 请求结果Code
 
 - MSRequestCodeNoData: 请求成功 无数据
 - MSRequestCodeSucceed: 请求成功
 - MSRequestCodeError: 请求失败、服务器错误
 - MSRequestCodeErrorNeedSyncTime: 请求失败、需要同步服务器时间
 */
typedef NS_ENUM(NSInteger, MSRequestCode) {
    MSRequestCodeNoData            = 0,
    MSRequestCodeSucceed           = 1,
    MSRequestCodeError             = -1,
    MSRequestCodeErrorNeedSyncTime = 5,
    // TODO: 无网络状态码
};

/**
 请求类型
 
 - MSRequestMethodGET: GET请求
 - MSRequestMethodPOST: POST请求
 - MSRequestMethodHEAD: HEAD请求
 - MSRequestMethodPUT: PUT请求
 - MSRequestMethodDELETE: DELETE请求
 - MSRequestMethodPATCH: PATCH请求
 */
typedef NS_ENUM(NSUInteger, MSRequestMethod) {
    MSRequestMethodGET = 0,
    MSRequestMethodPOST,
    MSRequestMethodHEAD,
    MSRequestMethodPUT,
    MSRequestMethodDELETE,
    MSRequestMethodPATCH
};

/**
 * 请求完成回调处理
 *
 * @param error 错误信息
 * @param result 响应数据
 */
typedef void (^MSRequestCompletionHandler)(id _Nullable result, NSError * _Nullable error);

typedef void (^MSRequestConstructingBodyHandler)(id <AFMultipartFormData> formData);

@interface MSRequestManager : NSObject

+ (instancetype)manager;

//@property (nonatomic, assign) MSReponseDataType dataType;

/**
 *  请求超时时间、默认30s
 */
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

/**
 *  请求头信息、默认为nil
 */
@property (nonatomic, strong, readonly) NSDictionary <NSString *, NSString *> *HTTPRequestHeaders;

/**
 * GET 请求
 *
 * @param URLString URL
 * @param parameters 请求参数
 * @param completionHandler 请求完成的回调处理
 */
- (void)GET:(NSString *)URLString
 parameters:(nullable NSDictionary *)parameters
 completion:(nullable MSRequestCompletionHandler)completionHandler;

/**
 * POST 请求
 *
 * @param URLString URL
 * @param parameters 请求参数
 * @param completionHandler 请求完成的回调处理
 */
- (void)POST:(NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
  completion:(nullable MSRequestCompletionHandler)completionHandler;

/**
 * POST 请求，自动进行模型转换
 *
 * @param URLString URL
 * @param parameters 请求参数
 * @param clazz 映射模型类型
 * @param completionHandler 请求完成后的回调处理
 */
- (void)POST:(NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
 resultClass:(nullable Class)clazz
  completion:(nullable MSRequestCompletionHandler)completionHandler;

/**
 * 指定请求类型
 *
 * @param method 请求类型
 * @param URLString URL
 * @param parameters 参数
 * @param constructingBodyHandler 构建表单数据的回调处理
 * @param completionHandler 请求完成的回调处理
 */
- (void)requestWithMethod:(MSRequestMethod)method
                URLString:(nullable NSString *)URLString
               parameters:(nullable NSDictionary *)parameters
  constructingBodyHandler:(nullable MSRequestConstructingBodyHandler)constructingBodyHandler
               completion:(nullable MSRequestCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
