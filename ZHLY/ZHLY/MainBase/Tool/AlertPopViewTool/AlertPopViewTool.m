//
//  AlertPopViewTool.m
//
//  Created by LTWL on 2017/7/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "AlertPopViewTool.h"

static UIView *_currentView;
static UIView *_currentBgView;
static CGFloat bgAlpha = 0.3;
static CGFloat popDuration = 0.3;

@implementation AlertPopViewTool

+ (void)alertPopView:(UIView *)view animated:(BOOL)animated {
    // 避免重复的图层出现
    for (UIView *targetView in CurrentWindow.subviews) {
        if ([targetView isKindOfClass:[view class]]) {
            [_currentView removeFromSuperview];
            [_currentBgView removeFromSuperview];
            _currentView = nil;
            _currentBgView = nil;
        }
    }
    // 保存当前弹出的视图
    _currentView = view;
    
    CGFloat halfScreenWidth = MainScreenSize.width * 0.5;
    CGFloat halfScreenHeight = MainScreenSize.height * 0.5;
    // 屏幕中心
    CGPoint screenCenter = CGPointMake(halfScreenWidth, halfScreenHeight);
    view.center = screenCenter;
    UIView *bgView = [[UIView alloc] init];
    bgView.size = MainScreenSize;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    [CurrentWindow addSubview:bgView];
    [CurrentWindow addSubview:view];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertDimss)]];
    _currentBgView = bgView;
    
    if (animated) {
        [UIView animateWithDuration:popDuration animations:^{
            bgView.alpha = bgAlpha;
        }];
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = popDuration + 0.1;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [view.layer addAnimation:popAnimation forKey:nil];
    }
}

+ (void)alertPopViewDismiss:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:popDuration - 0.1
                         animations:^{
                             _currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:popDuration
                                              animations:^{
                                                  _currentBgView.alpha = 0;
                                                  [_currentBgView removeFromSuperview];
                                                  _currentBgView = nil;
                                                  _currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                                              } completion:^(BOOL finished) {
                                                  [_currentView removeFromSuperview];
                                                  _currentView = nil;
                                              }];
                         }];
    } else {
        [_currentView removeFromSuperview];
        _currentView = nil;
    }
}

+ (void)alertSheetPopView:(UIView *)view animated:(BOOL)animated {
    // 保存当前弹出的视图
    _currentView = view;
    view.y = MainScreenSize.height;
    UIView *bgView = [[UIView alloc] init];
    bgView.size = MainScreenSize;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    [CurrentWindow addSubview:bgView];
    [CurrentWindow addSubview:view];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sheetDimiss)]];
    _currentBgView = bgView;
    
    if (animated) {
        [UIView animateWithDuration:popDuration animations:^{
            [_currentView setTransform:CGAffineTransformMakeTranslation(0, -_currentView.frame.size.height)];
            bgView.alpha = bgAlpha;
        }];
    }
}

+ (void)alertSheetPopViewDismiss:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:popDuration animations:^{
            [_currentBgView setAlpha:0 ];
            [_currentBgView removeFromSuperview];
            _currentBgView = nil;
            [_currentView setTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            [_currentView removeFromSuperview];
            _currentView = nil;
        }];
    } else {
        [_currentView removeFromSuperview];
        _currentView = nil;
    }
}

+ (void)sheetDimiss {
    [self alertSheetPopViewDismiss:YES];
}

+ (void)alertDimss {
    [self alertPopViewDismiss:YES];
}

@end
