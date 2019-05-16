//
//  TabBarVcViewController.m
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeVC.h"
#import "ProfileVC.h"
#import "ServiceVC.h"
#import "TravelsVC.h"

@interface TabBarViewController () <UITabBarControllerDelegate>
@property (nonatomic, assign) NSInteger preTapIndex;
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addChildViewController:[HomeVC new] title:@"首页" image:@"首页" selectedImage:@"首页-选中"];
    [self addChildViewController:[TravelsVC new] title:@"游记" image:@"游记" selectedImage:@"游记-选中"];
    [self addChildViewController:[ServiceVC new] title:@"客服" image:@"客服" selectedImage:@"客服-选中"];
    [self addChildViewController:[ProfileVC new] title:@"我的" image:@"我的" selectedImage:@"我的-选中"];
    
    self.delegate = self;
    
    // 自定义TabBar
    TabBar *tabBar = [TabBar new];
    tabBar.tabBarCount = self.childViewControllers.count;
    [self setValue:tabBar forKey:@"tabBar"];
    
    // 设置默认启动控制器(默认的是0)
    self.selectedViewController = self.childViewControllers[0];
}

- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectdeImage
{
    childVc.title = title;
    childVc.tabBarItem.image = SetImage(image);
    childVc.tabBarItem.image = [SetImage(image) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [SetImage(selectdeImage) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SetupColor(89, 91, 118)} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SetupColor(228, 167, 102)} forState:UIControlStateSelected];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (self.preTapIndex == tabBarController.selectedIndex) [[NSNotificationCenter defaultCenter] postNotificationName:NeedReloadDataNotification object:nil];
    self.preTapIndex = tabBarController.selectedIndex;
}

@end

@implementation TabBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemW = self.width / self.tabBarCount;
    CGFloat itemH = self.height;
    NSInteger index = 0;
    
    for (UIControl *tabBarBtn in self.subviews) {
        if ([tabBarBtn isKindOfClass:[NSClassFromString(@"UITabBarButton") class]]) {
            tabBarBtn.width = itemW;
            tabBarBtn.height = itemH;
            tabBarBtn.y = 0;
            tabBarBtn.x = index * itemW;
            index++;
            [tabBarBtn addTarget:self action:@selector(tabBarBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)tabBarBtnTap:(UIControl *)tabBar {
    [LaiMethod sprintAnimationWithButton:tabBar];
}

@end

