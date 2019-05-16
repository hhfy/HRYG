//
//  LaiCAAnimatonLibTool.h
//  GXBG
//
//  Created by LTWL on 2017/11/23.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LAIActivityIndicatorAnimationType) {
    LAIActivityIndicatorAnimationTypeNineDots,
    LAIActivityIndicatorAnimationTypeTriplePulse,
    LAIActivityIndicatorAnimationTypeFiveDots,
    LAIActivityIndicatorAnimationTypeRotatingSquares,
    LAIActivityIndicatorAnimationTypeDoubleBounce,
    LAIActivityIndicatorAnimationTypeTwoDots,
    LAIActivityIndicatorAnimationTypeThreeDots,
    LAIActivityIndicatorAnimationTypeBallPulse,
    LAIActivityIndicatorAnimationTypeBallClipRotate,
    LAIActivityIndicatorAnimationTypeBallClipRotatePulse,
    LAIActivityIndicatorAnimationTypeBallClipRotateMultiple,
    LAIActivityIndicatorAnimationTypeBallRotate,
    LAIActivityIndicatorAnimationTypeBallZigZag,
    LAIActivityIndicatorAnimationTypeBallZigZagDeflect,
    LAIActivityIndicatorAnimationTypeBallTrianglePath,
    LAIActivityIndicatorAnimationTypeBallScale,
    LAIActivityIndicatorAnimationTypeLineScale,
    LAIActivityIndicatorAnimationTypeLineScaleParty,
    LAIActivityIndicatorAnimationTypeBallScaleMultiple,
    LAIActivityIndicatorAnimationTypeBallPulseSync,
    LAIActivityIndicatorAnimationTypeBallBeat,
    LAIActivityIndicatorAnimationTypeLineScalePulseOut,
    LAIActivityIndicatorAnimationTypeLineScalePulseOutRapid,
    LAIActivityIndicatorAnimationTypeBallScaleRipple,
    LAIActivityIndicatorAnimationTypeBallScaleRippleMultiple,
    LAIActivityIndicatorAnimationTypeTriangleSkewSpin,
    LAIActivityIndicatorAnimationTypeBallGridBeat,
    LAIActivityIndicatorAnimationTypeBallGridPulse,
    LAIActivityIndicatorAnimationTypeRotatingSandglass,
    LAIActivityIndicatorAnimationTypeRotatingTrigons,
    LAIActivityIndicatorAnimationTypeTripleRings,
    LAIActivityIndicatorAnimationTypeCookieTerminator
};

@interface LaiCAAnimatonLibTool : NSObject

/// 加载动画库
+ (CALayer*)generateActivityIndicatorLayerWithAnimationType:(LAIActivityIndicatorAnimationType)animationType size:(CGSize)size tintColor:(UIColor *)tintColor superView:(UIView *)superView;

/// 渐变动画
+ (void)gradientAnimatonWithLoaddingView:(UIView *)loaddingView;
@end
