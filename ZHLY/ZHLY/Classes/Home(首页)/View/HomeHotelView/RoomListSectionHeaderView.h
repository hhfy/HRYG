//
//  RoomListSectionHeaderView.h
//  YWY2
//
//  Created by LTWL on 2017/4/26.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomListSectionHeaderView : UIView
+ (instancetype)show;

@property (weak, nonatomic) IBOutlet UILabel *checkTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkoutTimeLabel;

@property(nonatomic,copy) NSString *checkTime;
@property(nonatomic,copy) NSString *checkoutTime;
@end
