//
//  HomeMuseumHeaderView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ViewDidSelectedDateblock)(NSDate *selectedDate);

@class HomeShopBaseInfo;
@interface HomeHotelHeaderView : UIView
@property (nonatomic, strong) HomeShopBaseInfo *info;
@property (nonatomic, copy) ViewDidSelectedDateblock didSelectedDate;
@end

@interface HomeHotelHeaderNavBtn : UIButton
@end

@interface HomeHotelHeaderStartView : UIView

// 需要显示的星星的长度
@property (nonatomic, assign) CGFloat stars;
// 未点亮时候的颜色
@property (nonatomic, strong) UIColor *emptyColor;
// 点亮的星星的颜色
@property (nonatomic, strong) UIColor *fullColor;
@end


@interface HomeHotelHeaderDateBtn : UIButton
@property (nonatomic, strong) NSDate *date;
@end
