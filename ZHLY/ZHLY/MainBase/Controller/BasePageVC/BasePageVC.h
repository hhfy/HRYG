//
//  BasePageVC.h
//
//  Created by LTWL on 2017/7/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleButton : UIButton
@property (nonatomic, strong) UIFont *nomarlFont;
@property (nonatomic, strong) UIFont *selectFont;
@end

// 设置标题是否为nav上面
typedef enum : NSUInteger {
    TitleViewTypeNormal,
    TitleViewTypeNavTitleView
} TitleViewType;

// 设置标题是否为滚动模式
typedef enum : NSUInteger {
    TitleViewModeView,
    TitleViewModeScrollView
} TitleViewMode;

@interface BasePageVC : UIViewController
@property (nonatomic, assign, readonly) TitleViewType titleViewType;
@property (nonatomic, assign, readonly) TitleViewMode titleViewMode;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, strong, readonly) UIColor *titleColor;
// 添加子控制器
- (void)addChildVC;
@end



