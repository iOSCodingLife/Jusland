//
//  MSRequestManager.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/8.
//  Copyright © 2016年 58. All rights reserved.
//

//#import "MSRequestManager.h"
//#import "MJExtension.h"
//#import "MSSecurity.h"
//#import "MSUtility.h"
//// TODO: MIS4.0升级 更换
//#import "MISLoginManager.h"
////#import "MSLoginDataManager.h"
//#import "MSResponseData.h"
//#import "MSServerTimeHelper.h"
//
//@interface MSRequestManager ()
//
//@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
//@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *HTTPRequestHeaders;
//
//@property (nonatomic, assign) MSRequestMethod method;
//@property (nonatomic, strong) Class resultClass;
//@property (nonatomic, copy) MSRequestCompletionHandler completionHandler;
//
//@end
//
//@implementation MSRequestManager
//
//+ (instancetype)manager {
//    return [[self alloc] init];
//}
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
//        _sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
//        _requestTimeoutInterval = 20.0f;
//    }
//    return self;
//}
//
//- (void)GET:(NSString *)URLString
// parameters:(NSDictionary *)parameters
// completion:(MSRequestCompletionHandler)completionHandler {
//    [self requestWithMethod:MSRequestMethodGET
//                  URLString:URLString
//                 parameters:parameters
//    constructingBodyHandler:nil
//                 completion:completionHandler];
//}
//
//- (void)POST:(NSString *)URLString
//  parameters:(NSDictionary *)parameters
//  completion:(MSRequestCompletionHandler)completionHandler {
//    return [self POST:URLString
//           parameters:parameters
//          resultClass:nil
//           completion:completionHandler];
//}
//
//- (void)POST:(NSString *)URLString
//  parameters:(nullable NSDictionary *)parameters
// resultClass:(Class)clazz
//  completion:(nullable MSRequestCompletionHandler)completionHandler {
//    self.resultClass = clazz;
//    [self requestWithMethod:MSRequestMethodPOST
//                  URLString:URLString
//                 parameters:parameters
//    constructingBodyHandler:nil
//                 completion:completionHandler];
//}
//
//- (NSMutableDictionary *)MSRequestHeaders:(NSString *)URLString {
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
//    NSString *versionHeader = [NSString stringWithFormat:@"%@(%@)", appVersion, appBuild];
//    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *deviceModel = [MSUtility deviceModel];
//    MSNetworkReachabilityStatus state = [MSUtility currentNetWorkStates];
//    NSString *stateString = @"未知网络";
//    if (state == MSNetworkReachabilityStatusNotReachable) {
//        stateString = @"无网络";
//    } else if (state == MSNetworkReachabilityStatusWiFi) {
//        stateString = @"WIFI";
//    } else if (state >= MSNetworkReachabilityStatusWWAN2G || state <= MSNetworkReachabilityStatusWWAN4G) {
//        stateString = [NSString stringWithFormat:@"%ldG", (long) state];
//    }
//    
//    NSMutableDictionary *misAPIRequestHeaders = [[NSMutableDictionary alloc] init];
//    [misAPIRequestHeaders addEntriesFromDictionary:@{ @"clientType": @"mobile",
//                                                      @"version": versionHeader ?: @"",
//                                                      @"imei": uuid ?: @"",
//                                                      @"clientModel": deviceModel ?: @"",
//                                                      @"nettype": stateString ?: @"" }];
//    
//    // TODO: MIS4.0升级 更换
//    if (![URLString isEqualToString:MIS_GetPuKey]) { // 获取公钥接口不需要以下3个头
//        MISLoginData *loginData = [MISLoginManager sharedManager].loginData;
//        [misAPIRequestHeaders addEntriesFromDictionary:@{ @"userName": loginData.userName ?: @"" }];
//        if (![URLString isEqualToString:MIS_Login]) { // 登录接口不需要以下2个头
//            NSInteger length = 5;
//            char data[length];
//            for (int x = 0; x < length; data[x++] = (char) ('A' + (arc4random_uniform(26)))) {
//            }
//            
//            NSString *random = [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
//            NSTimeInterval timeInterval = [MSServerTimeHelper serverTimeInterval];
//            NSString *token = [NSString stringWithFormat:@"%@%.0f%@", random, timeInterval, loginData.token];
//            NSString *aesToken = [MSSecurity aes_encrypt:token];
//            aesToken = [self urlEncode:aesToken];
//            
//            CFStringRef CFURLCreateStringByAddingPercentEscapes(CFAllocatorRef allocator, CFStringRef originalString, CFStringRef charactersToLeaveUnescaped, CFStringRef legalURLCharactersToBeEscaped, CFStringEncoding encoding);
//            if (token == nil || token.length == 0) {
//                DDLogError(@"AES 解密Token失败。AES KEY:%@\nToken:%@", [MSSecurity AESKey], token);
//            }
//            [misAPIRequestHeaders addEntriesFromDictionary:@{ @"userTag": loginData.userId ?: @"",
//                                                              @"userKey": aesToken ?: @"" }];
//        }
//    }
//    
//    //    if (![URLString isEqualToString:API_GetPublicKey]) { // 获取公钥接口不需要以下3个头
//    //        MSLoginData *loginData = [MSLoginDataManager sharedManager].loginData;
//    //        [misAPIRequestHeaders addEntriesFromDictionary:@{@"userName" : loginData.account ?: @""}];
//    //        if (![URLString isEqualToString:API_Login]) {// 登录接口不需要以下2个头
//    //            NSInteger length = 5;
//    //            char data[length];
//    //            for (int x = 0; x < length; data[x++] = (char)('A' + (arc4random_uniform(26))));
//    //            NSString *random = [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
//    //            NSTimeInterval timeInterval = [MSServerTimeHelper serverTimeInterval];
//    //            NSString *token = [NSString stringWithFormat:@"%@%.0f%@", random, timeInterval, loginData.token];
//    //            NSString *aesToken = [MSSecurity aes_encrypt:token];
//    //            aesToken =  [self urlEncode:aesToken];
//    //
//    //            CFStringRef CFURLCreateStringByAddingPercentEscapes(CFAllocatorRef allocator, CFStringRef originalString, CFStringRef charactersToLeaveUnescaped, CFStringRef legalURLCharactersToBeEscaped, CFStringEncoding encoding);
//    //            if (token == nil || token.length == 0) {
//    //                DDLogError(@"AES 解密Token失败。AES KEY:%@\nToken:%@", [MSSecurity AESKey], token);
//    //            }
//    //            [misAPIRequestHeaders addEntriesFromDictionary:@{@"userTag" : loginData.userId ?: @"",
//    //                                                             @"userKey" : aesToken ?: @""}];
//    //        }
//    //    }
//    return misAPIRequestHeaders;
//}
//
//- (NSString *)urlEncode:(NSString *)aString {
//    NSString *charactersToBeEscaped = @"!$&'()*+,-./:;=?@_~%#[]";
//    NSString *encodedString = (NSString *)
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef) aString,
//                                                              NULL,
//                                                              (CFStringRef) charactersToBeEscaped,
//                                                              kCFStringEncodingUTF8));
//    return encodedString;
//}
//
//- (AFHTTPRequestSerializer *)requestSerializer:(NSString *)URLString {
//    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
//    requestSerializer.timeoutInterval = self.requestTimeoutInterval;
//    
//    // 添加MIS请求头
//    NSMutableDictionary *headerFieldValueDictionary = [self MSRequestHeaders:URLString];
//    
//    // 添加请求头
//    if (self.HTTPRequestHeaders) {
//        [headerFieldValueDictionary addEntriesFromDictionary:self.HTTPRequestHeaders];
//    }
//    
//    if (headerFieldValueDictionary != nil) {
//        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
//            NSString *value = headerFieldValueDictionary[httpHeaderField];
//            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
//        }
//    }
//    return requestSerializer;
//}
//
//- (void)requestWithMethod:(MSRequestMethod)method
//                URLString:(NSString *)URLString
//               parameters:(NSDictionary *)parameters
//  constructingBodyHandler:(MSRequestConstructingBodyHandler)constructingBodyHandler
//               completion:(MSRequestCompletionHandler)completionHandler {
//    NSError *__autoreleasing requestSerializationError = nil;
//    AFHTTPRequestSerializer *requestSerializer = [self requestSerializer:URLString];
//    
//    NSURLSessionTask *dataTask = nil;
//    switch (method) {
//        case MSRequestMethodGET: {
//            dataTask = [self dataTaskWithMethod:@"GET"
//                              requestSerializer:requestSerializer
//                                      URLString:URLString
//                                     parameters:parameters
//                        constructingBodyHandler:nil
//                                          error:&requestSerializationError];
//            break;
//        }
//        case MSRequestMethodPOST: {
//            dataTask = [self dataTaskWithMethod:@"POST"
//                              requestSerializer:requestSerializer
//                                      URLString:URLString
//                                     parameters:parameters
//                        constructingBodyHandler:constructingBodyHandler
//                                          error:&requestSerializationError];
//            break;
//        }
//        case MSRequestMethodHEAD: {
//            dataTask = [self dataTaskWithMethod:@"HEAD"
//                              requestSerializer:requestSerializer
//                                      URLString:URLString
//                                     parameters:parameters
//                        constructingBodyHandler:nil
//                                          error:&requestSerializationError];
//            break;
//        }
//        case MSRequestMethodPUT: {
//            dataTask = [self dataTaskWithMethod:@"PUT"
//                              requestSerializer:requestSerializer
//                                      URLString:URLString
//                                     parameters:parameters
//                        constructingBodyHandler:nil
//                                          error:&requestSerializationError];
//            break;
//        }
//        case MSRequestMethodDELETE: {
//            dataTask = [self dataTaskWithMethod:@"DELETE"
//                              requestSerializer:requestSerializer
//                                      URLString:URLString
//                                     parameters:parameters
//                        constructingBodyHandler:nil
//                                          error:&requestSerializationError];
//            break;
//        }
//        case MSRequestMethodPATCH: {
//            dataTask = [self dataTaskWithMethod:@"PATCH"
//                              requestSerializer:requestSerializer
//                                      URLString:URLString
//                                     parameters:parameters
//                        constructingBodyHandler:nil
//                                          error:&requestSerializationError];
//            break;
//        }
//    }
//    
//    if (requestSerializationError) {
//        if (completionHandler) {
//            completionHandler(requestSerializationError, nil);
//        }
//        return;
//    }
//    
//    //    self.method = method;
//    //    self.URLString = URLString;
//    //    self.parameters = parameters;
//    //    self.constructingBodyHandler = constructingBodyHandler;
//    self.completionHandler = completionHandler;
//    [dataTask resume];
//}
//
//- (NSURLSessionDataTask *)dataTaskWithMethod:(NSString *)method
//                           requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
//                                   URLString:(NSString *)URLString
//                                  parameters:(id)parameters
//                     constructingBodyHandler:(MSRequestConstructingBodyHandler)constructingBodyHandler
//                                       error:(NSError *_Nullable __autoreleasing *)error {
//    NSMutableURLRequest *request = nil;
//    if (constructingBodyHandler) {
//        request = [requestSerializer multipartFormRequestWithMethod:method
//                                                          URLString:URLString
//                                                         parameters:parameters
//                                          constructingBodyWithBlock:constructingBodyHandler
//                                                              error:error];
//    } else {
//        request = [requestSerializer requestWithMethod:method
//                                             URLString:URLString
//                                            parameters:parameters
//                                                 error:error];
//    }
//    
//    //    if (error == nil) return nil;
//    __block NSURLSessionDataTask *dataTask = nil;
//    dataTask = [self.sessionManager dataTaskWithRequest:request
//                                      completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *_error) {
//                                          [self handleRequestResult:dataTask responseObject:responseObject error:_error];
//                                      }];
//    
//    return dataTask;
//}
//
//- (void)handleRequestResult:(NSURLSessionDataTask *)dataTask responseObject:(id)responseObject error:(NSError *)error {
//    if (self.completionHandler) {
//        id responseData = nil;
//        // TODO: MIS4.0升级 更换
//        if ([dataTask.response.URL.absoluteString containsString:@"192.168.178.48:8229"]) {
//            if (responseObject && error == nil) {
//                NSString *code = [responseObject objectForKey:@"res_code"];
//                NSNumber *serverTime = [responseObject objectForKey:@"timeMillis"];
//                
//                [MSServerTimeHelper saveServerTimeInterval:serverTime.doubleValue];
//                if (code.integerValue == 0) {
//                    // 模拟服务端加密
//                    NSString *ciphertextData = [responseObject mj_JSONString];
//                    responseData = [MSSecurity aes_encrypt:ciphertextData];
//                    
//                    // 如果为加密数据，先解密
//                    NSNumber *ciphertext = @2;//[responseObject objectForKey:@"ciphertext"];
//                    BOOL isEncrypted = ([ciphertext isEqual:@2]);
//                    if (isEncrypted) {
//                        NSString *jsonDataString = [MSSecurity aes_decrypt:responseData];
//                        responseData = [jsonDataString mj_JSONObject];
//                    }
//                    
//                    if (self.resultClass) {
//                        id extData = [responseObject objectForKey:@"extData"];
//                        if (!extData || [extData isKindOfClass:[NSNull class]]) {
//                            // 如果指定映射模型，进行数据转换
//                            responseData = [responseObject objectForKey:@"data"];
//                            if (responseData && (self.method == MSRequestMethodGET || self.method == MSRequestMethodPOST)) {
//                                if ([responseData isKindOfClass:[NSArray class]]) {
//                                    responseData = [self.resultClass mj_objectArrayWithKeyValuesArray:responseData];
//                                } else if ([responseData isKindOfClass:[NSDictionary class]]) {
//                                    responseData = [self.resultClass mj_objectWithKeyValues:responseData];
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    NSInteger statusCode = [code integerValue];
//                    statusCode = (statusCode == 0) ? 1 : statusCode;
//                    NSString *msg = [responseObject objectForKey:@"res_message"] ?: @"";
//                    error = [NSError errorWithDomain:@"MSServiceError"
//                                                code:statusCode
//                                            userInfo:@{NSLocalizedDescriptionKey : msg}];
//                }
//            }
//            
//            if (error) {
//                DDLogDebug(@"%@", error);
//                if (error.code == -2) { // Token过期、退出登录
//                    // TODO: MIS4.0升级 更换
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserlogoutNotification object:nil];
//                    //                [[NSNotificationCenter defaultCenter] postNotificationName:kMSKickedNotification object:nil];
//                    return ;
//                } else if (error.code == -5) { // 与服务端时间不同步、重新请求。
//                    // TODO: 重新请求
//                }
//            } else {
//                DDLogDebug(@"%@ \n接口数据: %@ \n解密结果: %@", dataTask.response, responseObject, [responseData mj_JSONObject]);
//            }
//            self.completionHandler(responseData, error);
//        } else {
//            if (responseObject && error == nil) {
//                NSString *code = [responseObject objectForKey:@"code"];
//                NSNumber *serverTime = [responseObject objectForKey:@"ctime"];
//                
//                [MSServerTimeHelper saveServerTimeInterval:serverTime.doubleValue];
//                if (code.integerValue == MSRequestCodeSucceed) {
//                    responseData = [responseObject objectForKey:@"data"];
//                    // 如果为加密数据，先解密
//                    NSNumber *ciphertext = [responseObject objectForKey:@"ciphertext"];
//                    
//                    // TODO: MIS4.0升级 更换，CRM 迁移接口 模拟服务端加密
//                    if ([dataTask.response.URL.absoluteString containsString:AppCenter_HOST]) {
//                        ciphertext = @2;
//                        NSString *ciphertextData = [responseObject mj_JSONString];
//                        responseData = [MSSecurity aes_encrypt:ciphertextData];
//                    }
//                    
//                    BOOL isEncrypted = ([ciphertext isEqual:@2]);
//                    if (isEncrypted) {
//                        NSString *jsonDataString = [MSSecurity aes_decrypt:responseData];
//                        responseData = [jsonDataString mj_JSONObject];
//                    }
//                    
//                    // 如果指定结果类型，进行模型映射
//                    if (self.resultClass) {
//                        // 1.结果类型为列表数据
//                        if ([self.resultClass isSubclassOfClass:[MSResponseData class]]) {
//                            NSDictionary *extData = [responseData objectForKey:@"extData"];
//                            NSDictionary *listData = [responseData objectForKey:@"data"];
//                            
//                            NSMutableDictionary *data = [NSMutableDictionary dictionary];
//                            if ([extData isKindOfClass:[NSDictionary class]]) {
//                                [data setObject:extData forKey:@"extData"];
//                            }
//                            if ([listData isKindOfClass:[NSDictionary class]]) {
//                                NSNumber *total = [listData objectForKey:@"total"];
//                                NSArray *list = [listData objectForKey:@"data"];
//                                
//                                if (total) {
//                                    [data setObject:total forKey:@"total"];
//                                }
//                                if ([list isKindOfClass:[NSArray class]]) {
//                                    [data setObject:list forKey:@"list"];
//                                }
//                            }
//                            responseData = [self.resultClass mj_objectWithKeyValues:data];
//                        } else { // 2.结果类型为单条数据
//                            NSDictionary *data = [responseData objectForKey:@"data"];
//                            if ([data isKindOfClass:[NSDictionary class]]) {
//                                if ([data isKindOfClass:[NSArray class]]) {
//                                    responseData = [self.resultClass mj_objectArrayWithKeyValuesArray:responseData];
//                                } else if ([data isKindOfClass:[NSDictionary class]]) {
//                                    responseData = [self.resultClass mj_objectWithKeyValues:responseData];
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    NSString *msg = [responseObject objectForKey:@"msg"] ?: @"";
//                    error = [NSError errorWithDomain:@"MSServiceError"
//                                                code:code.integerValue
//                                            userInfo:@{NSLocalizedDescriptionKey : msg}];
//                }
//            }
//            
//            if (error) {
//                DDLogDebug(@"%@", error);
//                if (error.code == -2) { // Token过期、退出登录
//                    // TODO: MIS4.0升级 更换
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserlogoutNotification object:nil];
//                    //                [[NSNotificationCenter defaultCenter] postNotificationName:kMSKickedNotification object:nil];
//                    return ;
//                } else if (error.code == -5) { // 与服务端时间不同步、重新请求。
//                    // TODO: 重新请求
//                }
//            } else {
//                DDLogDebug(@"%@ \n接口数据: %@ \n解密结果: %@", dataTask.response, responseObject, [responseData mj_JSONObject]);
//            }
//            self.completionHandler(responseData, error);
//        }
//    }
//}
//
//@end
