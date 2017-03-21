//
//  MSAVManager.m
//  MIS
//
//  Created by LIUZHEN on 2017/2/18.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSAVManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation MSAVManager

#pragma mark -相机、相册权限
+ (BOOL)checkCameraAuthorization {
    BOOL isCameraValid = YES;
    // ios7之前系统默认拥有权限
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied) {
            isCameraValid = NO;
        }
    }
    return isCameraValid;
}

+ (BOOL)checkPhotoAuthorization {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if ( author == ALAuthorizationStatusDenied) {
            return NO;
        }
        return YES;
    }
    
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (void)openFlash:(BOOL)status {
    
}

- (void)openOrCloseFlash {
    
}

#pragma mark- 震动、声音效果

+ (void)systemVibrate {
    
}

+ (void)systemSound {
    
}

- (CGFloat)getVideoMaxScale {
    return 0.0f;
}

- (void)setVideoScale:(CGFloat)scale {
    
}

@end
