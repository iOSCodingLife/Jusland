//
//  MSPickerView.h
//  MIS
//
//  Created by LIUZHEN on 2017/3/6.
//  Copyright © 2017年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSPickerView;

@interface MSPickerItem : NSObject

/**
 *  选择条目显示标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  选择条目所对应值
 */
@property (nonatomic, copy) NSString *value;

/**
 *  构造方法
 *
 *  @param title 选择条目显示标题
 *  @param value 选择条目所对应的值
 *
 *  @return 选择条目
 */
+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value;

@end

@protocol MSPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(MSPickerView *)pickerView didSelectCompleteAtItem:(MSPickerItem *)item;

@end

@interface MSPickerView : UIView

/**
 *  选择器View，多列数据源自己实现代理方法
 */
@property (nonatomic, weak, readonly) UIPickerView *pickerView;

@property (nonatomic, weak) id<MSPickerViewDelegate> delegate;

/**
 *  选择器数据源
 */
@property (nonatomic, strong) NSArray<MSPickerItem *> *pickerItems;

/**
 *  显示选择器
 */
- (void)show;

- (void)showWithTitles:(NSArray <NSString *> *)titles;

/**
 *  隐藏选择器
 */
- (void)hide;

@end
