//
//  MSNavMenuItem.h
//  MIS
//
//  Created by LIUZHEN on 2017/3/11.
//  Copyright © 2017年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 排序类型
 
 - MSNavMenuItemOrderTypeNone: 不可排序
 - MSNavMenuItemOrderTypeAsc: 正序
 - MSNavMenuItemOrderTypeDesc: 倒叙
 */
typedef NS_ENUM(NSUInteger, MSNavMenuItemOrderType) {
    MSNavMenuItemOrderTypeNone,
    MSNavMenuItemOrderTypeAsc,
    MSNavMenuItemOrderTypeDesc,
};

@interface MSNavMenuItem : NSObject

/**
 *  菜单条目名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  是否选中
 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/**
 *  是否可以排序
 */
@property (nonatomic, assign) MSNavMenuItemOrderType orderType;

@end
