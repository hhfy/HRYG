//
//  UIImage+Extension.h
//
//  Created by LTWL on 2017/1/28.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/// 图片裁剪
+ (UIImage *)imageWithName:(NSString *)name border:(CGFloat)boeder boederColor:(UIColor *)color;

/// 截屏功能
+ (instancetype)imageWithCaptureView:(UIView *)view;

/// 图片拉伸
+ (UIImage *)resizableReszieWithImageName:(NSString *)imageName;

/// 图片拉伸2
+ (UIImage *)stretchableReszieWithImageName:(NSString *)imageName;

/// 图片压缩
+ (UIImage *)compressImageWithOriginalImage:(UIImage *)image scale:(CGFloat)scale;

/// 修正照相机拍照方向
+ (UIImage *)fixOrientation:(UIImage *)image;

/// 通过编码生成二维码图片
+ (UIImage *)creatCodeImageWithCode:(NSString *)code;

/// 二维码生成放大重绘高清图片
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

/// 使用颜色填充图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/// 图片高斯模糊
- (UIImage *)gaussianBlurImageWithLevel:(CGFloat)blur;

/// 将图片模糊化
+ (UIImage *)boxBlurImage:(UIImage *)image withLevel:(CGFloat)level;

/// 选择图片方向
- (UIImage*)rotate:(UIImageOrientation)orient;
@end
