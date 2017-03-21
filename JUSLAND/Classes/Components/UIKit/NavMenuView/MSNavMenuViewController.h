//
//  MSNavMenuViewController.h
//  MIS
//
//  Created by LIUZHEN on 2017/3/11.
//  Copyright © 2017年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNavMenuView.h"

@interface MSNavMenuViewController : UIViewController

/**
 *  导航菜单视图
 */
@property (nonatomic, strong, readonly) MSNavMenuView *menuView;

/**
 *  是否允许导航栏 标题跟右侧操作安装 跟随菜单切换而改变，默认YES
 */
@property (nonatomic, assign) BOOL allowsNavBarChange;

/**
 *  菜单条目
 */
@property (nonatomic, strong) NSArray <NSString *> *menuTitles;

/**
 *  菜单条目
 */
@property (nonatomic, strong) NSArray <MSNavMenuItem *> *menuItems;

/**
 *  菜单子控制器
 */
@property (nonatomic, strong) NSArray <UIViewController *> *viewControllers;

@end
