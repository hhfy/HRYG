//
//  UIView+Refresh.h
//  ZHDJ
//
//  Created by LTWL on 2017/8/13.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,StatusOfRefresh) {
    RefreshDefault = 1,     //非刷新状态，该值不能为0
    RefreshBeginRefresh,    //刷新状态
    RefreshNone             //全非状态（即不是刷新 也不是 非刷新状态）
};

@class RefreshView;
@interface UIView (Refresh)
// 监测范围的临界点,>0代表向上滑动多少距离,<0则是向下滑动多少距离
@property (nonatomic, assign)CGFloat threshold;
// 记录scrollView.contentInset.top
@property (nonatomic, assign)CGFloat marginTop;
//记录刷新状态
@property (nonatomic, assign)StatusOfRefresh refreshStatus;
//用于刷新回调
@property (nonatomic, copy)void(^refreshBlock)(void);
//刷新动画
@property (nonatomic, strong) CABasicAnimation *animation;
//偏移量累加
@property (nonatomic, assign) CGFloat offsetCollect;
//刷新view
@property (nonatomic, strong) RefreshView *refreshView;
//用于承接需要刷新的下拉刷新的extenScrollView
@property (nonatomic, strong) UIScrollView *extenScrollView;

/**
 下拉刷新
 @param scrollView 需要添加刷新的tableview
 @param position icon位置（默认：{10，34}navBar左上角）
 @param block 刷新回调
 */
- (void)refreshWithObject:(UIScrollView *)scrollView atPoint:(CGPoint)position downRefresh:(void(^)(void))block;

/**
 结束刷新动作
 */
- (void)endRefresh;

/**
 释放观察者
 */
- (void)freeReFresh;
@end


@interface RefreshView : UIScrollView
//刷新view的icon
@property (nonatomic, strong)UIImageView *refreshIcon;
@end
