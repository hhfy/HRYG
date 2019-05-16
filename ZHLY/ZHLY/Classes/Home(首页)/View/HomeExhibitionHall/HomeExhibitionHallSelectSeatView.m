
//
//  HomeExhibitionHallSelectSeatView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeExhibitionHallSelectSeatView.h"

@implementation HomeExhibitionHallSelectSeatView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    if (iPhoneX) self.height += SateBottomHeightIphoneX;
    self.width = MainScreenSize.width;
}

- (IBAction)selectSeatTap:(UIButton *)button {
    if (self.selectSeat) self.selectSeat();
}
@end
