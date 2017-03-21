//
//  MSAlertViewController.h
//  MIS
//
//  Created by LIUZHEN on 2017/2/19.
//  Copyright © 2017年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSAlertAction;

typedef void (^MSAlertActionBlock)(MSAlertAction *action);

/**
 Action Title的样式
 
 - MSAlertActionStyleDefault: 默认值 黑色
 - MSAlertActionStyleCancel: 取消样式 黑色，默认在最后显示
 - MSAlertActionStyleDestructive: 着重显示 橙色
 */
typedef NS_ENUM(NSInteger, MSAlertActionStyle) {
    MSAlertActionStyleDefault = 0,
    MSAlertActionStyleCancel,
    MSAlertActionStyleDestructive
};

/**
 Alert的样式
 
 - MSAlertControllerStyleActionSheet: Sheet样式，从底部显示
 - MSAlertControllerStyleAlert: Alert样式，从视图中心显示
 */
typedef NS_ENUM(NSInteger, MSAlertControllerStyle) {
    MSAlertControllerStyleActionSheet = 0,
    MSAlertControllerStyleAlert
};

@interface MSAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title
                          value:(NSString *)value;

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(MSAlertActionStyle)style
                        handler:(MSAlertActionBlock)handler;

+ (instancetype)actionWithTitle:(NSString *)title
                          value:(NSString *)value
                          style:(MSAlertActionStyle)style
                        handler:(MSAlertActionBlock)handler;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *value;
@property (nonatomic, assign, readonly) MSAlertActionStyle style;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

@end

@interface MSAlertController : UIViewController

/** Alert显示完成的回调 */
@property (nonatomic, copy) void (^showAnimationCompletionBlock)();

/** Alert销毁完成的回调 */
@property (nonatomic, copy) void (^dismissAnimationCompletionBlock)();

/** 点击Action条目，首选执行的操作，指定了此操作不在执行Action模型中的操作 */
@property (nonatomic, copy) void (^preferredActionHandlerBlock)(MSAlertAction *action);

/** Alert中所有的操作条目 */
@property (nonatomic, strong, readonly) NSArray<MSAlertAction *> *actionItems;

/**
 *  创建一个Alert
 *
 *  @param title          主标题
 *  @param message        子标题
 *  @param preferredStyle Alert样式
 *
 *  @return MSAlertController
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(MSAlertControllerStyle)preferredStyle;

/**
 *  添加Alert操作条目
 *
 *  @param action 操作条目集
 */
- (void)addAction:(MSAlertAction *)action;
- (void)addActions:(MSAlertAction *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

/** 显示Alert */
- (void)show;

/**
 *  显示 MSAlertControllerStyleActionSheet
 *
 *  @param actionTitles Action 标题组
 *  @[@"条目1", @"item2" ...]
 */
- (void)showWithActionTitles:(NSArray<NSString *> *)actionTitles;

/**
 *  显示一个带有关闭操作的Alert
 *
 *  @param cancelTitle 关闭Action的标题
 *  @param handler     关闭Action的操作回调
 */
- (void)showCancel:(NSString *)cancelTitle handler:(MSAlertActionBlock)handler;

/**
 *  显示一个对话框Alert
 *
 *  @param cancelTitle 取消Action的标题，默认为“取消”
 *  @param actionTitle 操作Action的标题
 *  @param handler     操作action的操作回调
 */
- (void)showDialog:(NSString *)cancelTitle actionTitle:(NSString *)actionTitle handler:(MSAlertActionBlock)handler;

@end
