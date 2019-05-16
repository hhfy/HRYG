//
//  HomeMuseumScoreCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeMuseumScoreList;
@interface HomeShopBaseScoreCell : UITableViewCell
@property (nonatomic, strong) HomeMuseumScoreList *scoreList;
@end

@interface HomeMuseumStartView : UIView
// 需要显示的星星的长度
@property (nonatomic, assign) CGFloat stars;
// 未点亮时候的颜色
@property (nonatomic, strong) UIColor *emptyColor;
// 点亮的星星的颜色
@property (nonatomic, strong) UIColor *fullColor;
@end
