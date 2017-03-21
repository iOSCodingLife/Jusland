////
////  MSFileLocationHelper.m
////  MIS
////
////  Created by LIUZHEN on 2016/12/20.
////  Copyright © 2016年 58. All rights reserved.
////
//
//#import "MSFileLocationHelper.h"
//// TODO: MIS4.0升级 更换
////#import "MSLoginDataManager.h"
//#import "MISLoginManager.h"
//
//@implementation MSFileLocationHelper
//
//+ (NSString *)getAppDocumentPath {
//    static NSString *appDocumentPath = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *appKey = kAppKey;
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        appDocumentPath = [[NSString alloc] initWithFormat:@"%@/%@", [paths objectAtIndex:0], appKey];
//        if (![[NSFileManager defaultManager] fileExistsAtPath:appDocumentPath]) {
//            [[NSFileManager defaultManager] createDirectoryAtPath:appDocumentPath
//                                      withIntermediateDirectories:NO
//                                                       attributes:nil
//                                                            error:nil];
//        }
//        NSError *error = nil;
//        NSURL *URL = [NSURL fileURLWithPath:appDocumentPath];
//        BOOL success = [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
//        if(!success) {
//            DDLogError(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
//        }
//    });
//    return appDocumentPath;
//}
//
//+ (NSString *)getUserDirectory {
//    NSString *documentPath = [MSFileLocationHelper getAppDocumentPath];
//    // TODO: MIS4.0升级 更换
//    NSString *userID = [MISLoginManager sharedManager].loginData.userId;
////    NSString *userID = [MSLoginDataManager sharedManager].loginData.account;
//    if ([userID length] == 0) {
//        DDLogError(@"Error: UserID为空，获取用户目录失败!");
//    }
//    
//    NSString *userDirectory = [NSString stringWithFormat:@"%@/%@", documentPath, userID];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory
//                                  withIntermediateDirectories:NO
//                                                   attributes:nil
//                                                        error:nil];
//        
//    }
//    return userDirectory;
//}
//
//+ (NSString *)getAppTempPath {
//    return NSTemporaryDirectory();
//}
//
//@end
//
