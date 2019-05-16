//
//  RoomOrderHeaderView.h
//  YWY2
//
//  Created by LTWL on 2017/5/3.
//  Copyright © 2017年 XMB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomOrderHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomOtherInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *contianerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
+ (instancetype)show;
@end

@interface QuiteButton : UIButton

@end
