//
//  ProfileOrderHeaderView.h
//  ZHLY
//
//  Created by LTWL on 2018/3/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProfileOrderHeaderTapBlock)(void);

@class ProfileOrderIndex;
@interface ProfileOrderHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy) ProfileOrderHeaderTapBlock btnTap;

@property (nonatomic, strong)ProfileOrderIndex *orderIndex;
@end
