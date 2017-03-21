//
//  MSNavMenuView.h
//  MIS
//
//  Created by LIUZHEN on 2017/3/11.
//  Copyright © 2017年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNavMenuItem.h"

@class MSNavMenuView;

@protocol MSNavMenuViewDelegate <NSObject>

@optional
- (void)navMenuView:(MSNavMenuView *)menuView didScrollToIndex:(NSInteger)index;

@end

@interface MSNavMenuView : UIView

/**
 *  代理
 */
@property (nonatomic, weak) id <MSNavMenuViewDelegate> delegate;

/**
 *  菜单条目宽度是否等分 默认为YES
 */
@property (nonatomic, assign, getter=iseEuipartition) BOOL equipartition;

/**
 *  是否显示选中状态下标 默认为YES
 */
@property (nonatomic, assign) BOOL showSlectedState;

/**
 *  当前选中的条目下标，默认为选中第一个
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  加载菜单条目
 *
 *  @param titles 菜单条目
 */
- (void)reloadWithTitles:(NSArray <NSString *> *)titles;

/**
 *  加载菜单条目
 *
 *  @param items 菜单条目
 */
- (void)reloadWithItems:(NSArray <MSNavMenuItem *> *)items;

/**
 *  滑动到指定的菜单
 *
 *  @param index 指定的菜单下标
 *  @param animated 是否显示动画
 */
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
