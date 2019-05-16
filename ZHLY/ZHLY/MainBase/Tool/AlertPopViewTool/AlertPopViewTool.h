//
//  AlertPopViewTool.h
//
//  Created by LTWL on 2017/7/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertPopViewTool : UIView
/// 中间弹窗动画
+ (void)alertPopView:(UIView *)view animated:(BOOL)animated;
/// 底部弹窗动画
+ (void)alertPopViewDismiss:(BOOL)animated;
/// 中间弹窗消失动画
+ (void)alertSheetPopView:(UIView *)view animated:(BOOL)animated;
/// 底部弹窗消失动画
+ (void)alertSheetPopViewDismiss:(BOOL)animated;
@end
