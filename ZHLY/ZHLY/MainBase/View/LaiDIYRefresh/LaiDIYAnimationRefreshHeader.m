//
//  LaiDIYAnimationRefreshHeader.m
//  ZHLY
//
//  Created by Mr Lai on 2017/12/30.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "LaiDIYAnimationRefreshHeader.h"
#import "LaiLoaddingView.h"

@interface LaiDIYAnimationRefreshHeader ()

@end

@implementation LaiDIYAnimationRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (LaiLoaddingView *)loadingPanel {
    if (!_loadingPanel) {
        _loadingPanel = [[LaiLoaddingView alloc] init];
        _loadingPanel.backgroundColor = [UIColor clearColor];
        _loadingPanel.defaultColor = [UIColor redColor];
    }
    return _loadingPanel;
}

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.height = 50;
    [self addSubview:self.loadingPanel];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.loadingPanel.frame = CGRectMake(0, 0, 40, 10);
    self.loadingPanel.center = CGPointMake(self.center.x, 0);
    
    CGRect panelFrame = self.loadingPanel.frame;
    panelFrame.origin.y =  CGRectGetHeight(self.bounds)/2.0f - CGRectGetHeight(self.loadingPanel.bounds) + 10;
    self.loadingPanel.frame = panelFrame;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loadingPanel stopPageLoadingAnimation];
            break;
        case MJRefreshStatePulling:
            break;
        case MJRefreshStateRefreshing:
            [self.loadingPanel doPageLoadingAnimation];
            break;
        default:
            break;
    }
}


#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    if (pullingPercent > 1.0) { return; }
    [self.loadingPanel doPullDownWithPullingPercent:pullingPercent];
}

@end
