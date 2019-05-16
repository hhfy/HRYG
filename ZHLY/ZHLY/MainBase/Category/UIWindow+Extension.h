//
//  UIWindow+Extension.h
//  ZHRQ_CBZ
//
//  Created by LTWL on 2017/7/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)
/// 获取当前Window
+ (UIWindow *)getCurrentWindow;
+ (UIViewController *)getCurrentTabBarVC;
+ (UIViewController *)getCurrentNavVC;
/// 获取当前控制器
+ (UIViewController *)getCurrentVC;
@end
