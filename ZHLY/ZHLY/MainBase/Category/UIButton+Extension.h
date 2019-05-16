//
//  UIButton+Extension.h
//  ZHDJ
//
//  Created by LTWL on 2017/9/19.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

//默认时间间隔
#define defaultInterval 1

@interface UIButton (Extension)
//点击间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;
//用于设置单个按钮不需要被hook
@property (nonatomic, assign) BOOL isIgnore;
+(UIButton *)createButtonwithFrame:(CGRect)rect backgroundColor:(UIColor *)color image:(UIImage *)image;
@end
