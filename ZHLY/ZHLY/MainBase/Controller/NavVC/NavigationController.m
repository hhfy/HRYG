//
//  NavigationController.m
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController () <UINavigationControllerDelegate>

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

+ (void)initialize
{
    [self setNavigationBar];
    
    [self setBarButtonItem];
}

+ (void)setNavigationBar
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barStyle = UIBarStyleDefault;
    if (@available(iOS 11.0, *)) navBar.prefersLargeTitles = NO;
    
    [navBar setBackgroundImage:(iPhoneX) ? SetImage(@"navigationbarBackgroundWhite_X") : SetImage(@"navigationbarBackgroundWhite") forBarMetrics:UIBarMetricsDefault];
//    navBar.shadowImage = [UIImage new];
//    navBar.translucent = NO;
    [navBar setTitleTextAttributes:@{
                                     NSFontAttributeName:TextBoldFont(NavBarTitleFont),
                                     NSForegroundColorAttributeName:SetupColor(51, 51, 51)
                                     }];
}

+ (void)setBarButtonItem
{
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setTitleTextAttributes:@{
                                      NSFontAttributeName: TextSystemFont(NavBarItemFont),
                                      NSForegroundColorAttributeName: SetupColor(51, 51, 51)
                                      } forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:@{
                                      NSFontAttributeName: TextSystemFont(NavBarItemFont),
                                      NSForegroundColorAttributeName: SetupColor(180, 180, 180)
                                      } forState:UIControlStateDisabled];
    [barItem setTitleTextAttributes:@{
                                      NSFontAttributeName: TextSystemFont(NavBarItemFont),
                                      NSForegroundColorAttributeName: SetupColor(180, 180, 180)
                                      } forState:UIControlStateHighlighted];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        if (@available(iOS 11.0, *)) viewController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) title:LeftArrowIconUnicode nomalColor:SetupColor(51, 51, 51) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:-25 bottom:0 right:0];
    }
//    else if (self.viewControllers.count == 0) {
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:2 target:self action:@selector(cancel)];
//    }
    return [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}


- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.interactivePopGestureRecognizer.enabled = self.viewControllers.count > 1;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果当前显示的是第一个子控制器,就应该禁止掉[返回手势]
    return self.childViewControllers.count > 1;
}

@end
