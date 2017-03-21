//
//  MSQRCodeReaderView.h
//  MIS
//
//  Created by LIUZHEN on 2017/2/19.
//  Copyright © 2017年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSQRCodeReaderMaskView.h"

@interface MSQRCodeReaderView : UIView

/**
 *  支持识别码的类型，
 *  默认支持iOS识别的全部类型 AVMetadataFaceObject
 */
@property (nonatomic, strong) NSArray *metaDataObjectTypes;

/** 扫码视图 */
@property (nonatomic, weak, readonly) MSQRCodeReaderMaskView *maskView;

/** 扫码成功的回调 */
@property (nonatomic, copy) void (^scanCompletionHandler)(NSString *result);

/**
 *  开始扫描
 */
- (void)startScanning;

/**
 *  停止扫描
 */
- (void)stopScanning;

@end
