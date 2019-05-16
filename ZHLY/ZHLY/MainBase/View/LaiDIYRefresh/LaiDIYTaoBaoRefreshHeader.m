//
//  LaiDIYTaoBaoRefreshHeader.m
//  ZHLY
//
//  Created by LTWL on 2017/12/30.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "LaiDIYTaoBaoRefreshHeader.h"

@interface LaiDIYTaoBaoRefreshHeader ()
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LaiDIYTaoBaoRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (CAShapeLayer *)arrowLayer {
    if (!_arrowLayer) {
        _arrowLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
        [bezierPath moveToPoint:CGPointMake(20, 15)];
        [bezierPath addLineToPoint:CGPointMake(20, 25)];
        [bezierPath addLineToPoint:CGPointMake(25, 20)];
        [bezierPath moveToPoint:CGPointMake(20, 25)];
        [bezierPath addLineToPoint:CGPointMake(15, 20)];
        _arrowLayer.lineWidth = 1.5;
        _arrowLayer.path = bezierPath.CGPath;
        _arrowLayer.lineCap = kCALineCapRound;
        _arrowLayer.fillColor = [UIColor clearColor].CGColor;
        _arrowLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _arrowLayer.bounds = CGRectMake(0, 0, 40, 40);
        _arrowLayer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _arrowLayer;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20)
                                                                  radius:12.0
                                                              startAngle:-M_PI_2
                                                                endAngle:M_PI_2*3.0
                                                               clockwise:YES];
        _circleLayer.path = bezierPath.CGPath;
        _circleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineWidth = 1.0;
        _circleLayer.strokeEnd = 0.05;
        _circleLayer.strokeStart = 0.05;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.bounds = CGRectMake(0, 0, 40, 40);
        _circleLayer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _circleLayer;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = SetupColor(135, 135, 135);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.height = 50;
    [self addSubview:self.titleLabel];
    [self.layer addSublayer:self.arrowLayer];
    [self.layer addSublayer:self.circleLayer];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    CGRect react = self.bounds;
    self.arrowLayer.position = CGPointMake(react.size.width/2 - 40, react.size.height/2);
    self.circleLayer.position = CGPointMake(react.size.width/2 - 40, react.size.height/2);
    self.titleLabel.frame = CGRectMake((react.size.width - 100)/2 + 35, react.size.height/2 - 15, 100, 30);
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
            [self endRefreshAnimation];
            self.titleLabel.text = @"下拉刷新...";
            break;
        case MJRefreshStatePulling:
            self.titleLabel.text = @"释放刷新...";
            break;
        case MJRefreshStateRefreshing:
            self.titleLabel.text = @"加载中...";
            [self startRefreshAnimation];
            break;
        default:
            break;
    }
}

- (void)endRefreshAnimation {
    self.arrowLayer.hidden = NO;
    self.circleLayer.strokeEnd = 0.05;
    [self.circleLayer removeAllAnimations];
}

- (void)startRefreshAnimation {
    self.arrowLayer.hidden = YES;
    self.circleLayer.strokeEnd = 0.95;
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue = [[NSNumber alloc] initWithDouble:M_PI*2];
    rotateAnimation.duration = 0.6;
    rotateAnimation.cumulative = YES;
    rotateAnimation.repeatCount = 10000000;
    [self.circleLayer addAnimation:rotateAnimation forKey:@"rotate"];
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    if (pullingPercent > 1.0) { return; }
    self.circleLayer.strokeEnd = 0.05 + 0.9 * pullingPercent;
}

@end
