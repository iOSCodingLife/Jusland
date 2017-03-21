//
//  MSDatePicker.h
//  MIS
//
//  Created by LIUZHEN on 2017/3/7.
//  Copyright © 2017年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSDatePicker;

@protocol MSDatePickerDelegate <NSObject>

@optional
- (void)didSelectCompleteDatePicker:(MSDatePicker *)datePicker;

@end

@interface MSDatePicker : UIView

@property (nonatomic, strong, readonly) UIDatePicker *datePicker;

/**
 *  事件代理
 */
@property (nonatomic, weak) id<MSDatePickerDelegate> delegate;

/**
 *  日期选中后的回调，指定了block，代理的方式就不会执行
 */
@property (nonatomic, copy) void (^didSelectAtDate)(MSDatePicker *datePicker);

/**
 *  显示选择器
 */
- (void)show;

/**
 *  隐藏选择器
 */
- (void)hide;

@end
