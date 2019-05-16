
//
//  UIWindow+Extension.m
//  ZHRQ_CBZ
//
//  Created by LTWL on 2017/7/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "UIWindow+Extension.h"

@implementation UIWindow (Extension)
/**获取当前window*/
+ (UIWindow *)getCurrentWindow {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

+ (UIViewController *)getCurrentTabBarVC {
    UIViewController *result = [self getCurrentWindow].rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
        return result;
    }
    return nil;
}

+ (UIViewController *)getCurrentNavVC {
    UIViewController *result = [self getCurrentWindow].rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
        return result;
    }
    return nil;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    UIViewController * currVC = nil;
    UIWindow *window = [self getCurrentWindow];
    UIViewController * Rootvc = window.rootViewController;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        } else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    return currVC;
}


@end
