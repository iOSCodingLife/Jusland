//
//  MSCellItem.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/16.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 公用条目类型，决定cell右侧显示内容
 
 - MSItemTypeNone: 无
 - MSCellItemTypeText: 文本
 - MSItemTypeArrow: 箭头
 - MSItemTypeSwitch: 开关
 - MSItemTypeCheckbox: 选择框
 */
typedef NS_ENUM(NSInteger, MSCellItemType) {
    MSCellItemTypeNone,
    MSCellItemTypeText,
    MSCellItemTypeArrow,
    MSCellItemTypeSwitch,
    MSCellItemTypeCheckbox
};

@interface MSCellItem : NSObject

/**
 *  cell 类型，决定cell右侧显示内容
 */
@property (nonatomic, assign) MSCellItemType type;

/**
 *  左侧图标
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  主标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  配置cell
 */
@property (nonatomic, copy) void (^configrueCell)(UITableViewCell *cell);

/**
 *  点击cell操作
 */
@property (nonatomic, copy) void (^didClickHandler)();

+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title;
+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;
+ (instancetype)itemWithType:(MSCellItemType)type image:(UIImage *)image title:(NSString *)title;
+ (instancetype)itemWithType:(MSCellItemType)type image:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;

@end
