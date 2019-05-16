//
//  HZIndicatorView.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "HZIndicatorView.h"
#import "HZPhotoBrowserConfig.h"
#import "GKLoadingView.h"

@implementation HZIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.viewMode = HZIndicatorViewModePieDiagram;//圆
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.viewMode == HZIndicatorViewModeRotaryRing) {
            self.backgroundColor = [UIColor clearColor];
        } else {
            self.backgroundColor = kIndicatorViewBackgroundColor;
            [self setNeedsDisplay];
        }
        if (progress >= 1) [self removeFromSuperview];
    });
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = 42;
    frame.size.height = 42;
    self.layer.cornerRadius = 21;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [[UIColor whiteColor] set];
    
    switch (self.viewMode) {
        case HZIndicatorViewModePieDiagram:
        {
            CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - kIndicatorViewItemMargin;
            CGFloat w = radius * 2 + kIndicatorViewItemMargin;
            CGFloat h = w;
            CGFloat x = (rect.size.width - w) * 0.5;
            CGFloat y = (rect.size.height - h) * 0.5;
            CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
            CGContextFillPath(ctx);
            
            [kIndicatorViewBackgroundColor set];
            CGContextMoveToPoint(ctx, xCenter, yCenter);
            CGContextAddLineToPoint(ctx, xCenter, 0);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
            CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);
        }
            break;
        case HZIndicatorViewModeRotaryRing:
        {
            GKLoadingView *loadingView = [GKLoadingView loadingViewWithFrame:self.bounds style:GKLoadingStyleIndeterminate];
            loadingView.lineWidth   = 3;
            loadingView.radius      = 12;
            loadingView.bgColor     = [UIColor blackColor];
            loadingView.strokeColor = [UIColor whiteColor];
            [loadingView startLoading];
            [self addSubview:loadingView];
        }
            break;
        default:
        {
            CGContextSetLineWidth(ctx, 4);
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
            CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - kIndicatorViewItemMargin;
            CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
            CGContextStrokePath(ctx);
        }
            break;
    }
}
@end
