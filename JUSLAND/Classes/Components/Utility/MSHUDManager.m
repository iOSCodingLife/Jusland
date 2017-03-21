//
//  MSHUDManager.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/19.
//  Copyright © 2016年 58. All rights reserved.
//

#import "MSHUDManager.h"
#import "MBProgressHUD.h"

@implementation MSHUDManager

+ (void)showToast:(NSString *)message {
    [self showToast:message inView:nil];
}

+ (void)showToast:(NSString *)message inView:(UIView *)view {
    if (view == nil) {
        UIViewController *currentVC = [self currentViewController];
        view = currentVC.view ?: [UIApplication sharedApplication].keyWindow;
    }
    // TODO: MIS4.0升级 更换
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = message;
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5f];
    });
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //        hud.label.text = message;
    //        hud.mode = MBProgressHUDModeText;
    //        hud.margin = 10.0f;
    //        hud.contentColor = [UIColor whiteColor];
    //        hud.bezelView.backgroundColor = [UIColor blackColor];
    //        hud.removeFromSuperViewOnHide = YES;
    //        [hud hideAnimated:YES afterDelay:1.5f];
    //    });
}

+ (void)showLoading {
    [self showLoadingInView:nil];
}

+ (void)showLoadingInView:(UIView *)view {
    [self showLoadingInView:view withTitle:nil];
}

+ (void)showLoadingInView:(UIView *)view withTitle:(NSString *)title {
    if (view == nil) {
        UIViewController *currentVC = [self currentViewController];
        view = currentVC.view ?: [UIApplication sharedApplication].keyWindow;
    }
    // TODO: MIS4.0升级 更换
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
        if (title) {
            hud.labelText = title;
        } else {
            hud.labelText = @"正在加载...";
        }
        hud.margin = 20.0f;
        hud.minSize = CGSizeMake(110, 110);
        hud.removeFromSuperViewOnHide = YES;
        [view addSubview:hud];
        [hud show:YES];
    });
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    //        if (title) {
    //            hud.label.text = title;
    //        } else {
    //            hud.label.text = @"正在加载...";
    //        }
    //        hud.margin = 20.0f;
    //        hud.minSize = CGSizeMake(110, 110);
    //        hud.contentColor = [UIColor whiteColor];
    //        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //        hud.bezelView.color = [UIColor colorWithHexString:@"#000000" colorAlpha:0.5f];
    //        hud.removeFromSuperViewOnHide = YES;
    //        [view addSubview:hud];
    //        [hud showAnimated:YES];
    //    });
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) {
        UIViewController *currentVC = [self currentViewController];
        view = currentVC.view ?: [UIApplication sharedApplication].keyWindow;
    }
    // TODO: MIS4.0升级 更换
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [self HUDForView:view];
        [hud hide:YES];
    });
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        MBProgressHUD *hud = [self HUDForView:view];
    //        [hud hideAnimated:YES];
    //    });
}

+ (MBProgressHUD *)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            return (MBProgressHUD *)subview;
        }
    }
    return nil;
}

+ (UIWindow *)frontWindow {
#if !defined(SV_APP_EXTENSIONS)
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
#endif
    return nil;
}

+ (UIViewController *)currentViewController {
    UIViewController *viewController = self.frontWindow.rootViewController;
    return [self findViewController:viewController];
}

+ (UIViewController *)findViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [self findViewController:viewController.presentedViewController];
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *vc = (UISplitViewController *)viewController;
        if (vc.viewControllers.count > 0) {
            return [self findViewController:vc.viewControllers.lastObject];
        } else {
            return viewController;
        }
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *vc = (UINavigationController *)viewController;
        if (vc.viewControllers.count > 0) {
            return [self findViewController:vc.topViewController];
        } else {
            return viewController;
        }
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *vc = (UITabBarController *)viewController;
        if (vc.viewControllers.count > 0) {
            return [self findViewController:vc.selectedViewController];
        } else {
            return viewController;
        }
    } else {
        return viewController;
    }
}

@end
