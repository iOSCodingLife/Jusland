//
//  UIViewController+MSExtension.m
//  MIS
//
//  Created by LIUZHEN on 2017/2/14.
//  Copyright © 2017年 58. All rights reserved.
//

#import "UIViewController+MSExtension.h"

@implementation UIViewController (MSExtension)

- (void)setupNavBarDefaultTheme {
    [self setupNavBarBackgroundColor:[UIColor whiteColor]
                          titleColor:[UIColor ms_blackColor]];
    UINavigationBar *appearance = self.navigationController.navigationBar;
    [appearance setShadowImage:[UIImage imageWithColor:[UIColor ms_separatorColor]
                                                  size:CGSizeMake(0.6f, 0.6f)]];
}

- (void)setupNavBarBackgroundColor:(UIColor *)color titleColor:(UIColor *)titleColor {
    UINavigationBar *appearance = self.navigationController.navigationBar;
    appearance.shadowImage = [[UIImage alloc] init];
    appearance.tintColor = [UIColor whiteColor];
    [appearance setBackgroundImage:[UIImage imageWithColor:color]
                     forBarMetrics:UIBarMetricsDefault];
    [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName: titleColor,
                                         NSFontAttributeName: [UIFont ms_largeFont]}];
}

- (void)setupLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:NULL];
    spaceItem.width = -15;
    self.navigationItem.leftBarButtonItems = @[spaceItem, leftBarButtonItem];
}

- (void)setupRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:NULL];
    spaceItem.width = -15;
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightBarButtonItem];
}

@end
