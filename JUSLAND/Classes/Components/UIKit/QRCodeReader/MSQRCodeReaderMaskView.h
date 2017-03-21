//
//  MSQRCodeScanView.h
//  MIS
//
//  Created by LIUZHEN on 2017/2/18.
//  Copyright © 2017年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 扫码区域动画效果

 - MSRQCodeScanViewAnimationStyleLineMove: 线条动画
 - MSRQCodeScanViewAnimationStyleLineStill: 线条停止在扫码区域中央
 - MSRQCodeScanViewAnimationStyleNone: 无动画
 */
typedef NS_ENUM(NSUInteger, MSRQCodeScanViewAnimationStyle) {
    MSRQCodeScanViewAnimationStyleLineMove,
    MSRQCodeScanViewAnimationStyleLineStill,
    MSRQCodeScanViewAnimationStyleNone
    
};

/**
 扫码区域4个角位置类型

 - MSRQCodeScanViewPhotoframeAngleStyleInner: 内嵌，一般不显示矩形框情况下
 - MSRQCodeScanViewPhotoframeAngleStyleOuter: 外嵌，包围在矩形框的4个角
 - MSRQCodeScanViewPhotoframeAngleStyleOn: 覆盖，在矩形框的4个角上
 */
typedef NS_ENUM(NSUInteger, MSRQCodeScanViewPhotoframeAngleStyle) {
    MSRQCodeScanViewPhotoframeAngleStyleInner,
    MSRQCodeScanViewPhotoframeAngleStyleOuter,
    MSRQCodeScanViewPhotoframeAngleStyleOn
};

@interface MSQRCodeReaderMaskView : UIView

/** 是否需要绘制扫码矩形框，默认YES */
@property (nonatomic, assign, getter=isNeedDrawRetangle) BOOL needDrawRetangle;

/** 默认扫码区域为正方形，如果扫码区域不是正方形，设置宽高比 */
@property (nonatomic, assign) CGFloat whRatio;

/** 矩形框(视频显示透明区)域向上移动偏移量，0表示扫码透明区域在当前视图中心位置，如果负值表示扫码区域下移 */
@property (nonatomic, assign) CGFloat centerUpOffset;

/** 矩形框(视频显示透明区)域离界面左边及右边距离，默认80 */
@property (nonatomic, assign) CGFloat xScanRetangleOffset;

/** 矩形框线条颜色，默认为白色 */
@property (nonatomic, strong) UIColor *colorRetangleLine;

/** 非识别区域颜色,默认 RGBA (0,0,0,0.5) */
@property (nonatomic, strong) UIColor *notRecoginitonAreaColor;

#pragma mark - 扫码区域

/** 4个角的颜色 默认为 橙色 */
@property (nonatomic, strong) UIColor *colorAngle;

/** 扫码区域的4个角类型 默认 覆盖在边框上 */
@property (nonatomic, assign) MSRQCodeScanViewPhotoframeAngleStyle photoframeAngleStyle;

/** 扫码区域4个角的宽度，默认24 */
@property (nonatomic, assign) CGFloat photoframeAngleW;

/** 扫码区域4个角的高度 默认24 */
@property (nonatomic, assign) CGFloat photoframeAngleH;

/** 扫码区域4个角的线条宽度，默认2 */
@property (nonatomic, assign) CGFloat photoframeLineW;

#pragma mark -- 动画效果

/** 扫码动画效果:线条 */
@property (nonatomic, assign) MSRQCodeScanViewAnimationStyle anmiationStyle;

/** 动画效果的图像，如线条或网格的图像 */
@property (nonatomic, strong) UIImage *animationImage;

/**
 *  开始扫描动画
 */
- (void)startScanningAnimation;

/**
 *  结束扫描动画
 */
- (void)stopScanningAnimation;

@end
