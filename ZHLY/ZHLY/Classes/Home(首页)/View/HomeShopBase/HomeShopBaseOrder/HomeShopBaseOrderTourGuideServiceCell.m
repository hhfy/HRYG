//
//  HomeMuseumOrderTourGuideServiceCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderTourGuideServiceCell.h"

@interface HomeShopBaseOrderTourGuideServiceCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@end

@implementation HomeShopBaseOrderTourGuideServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.selectBtn.titleLabel.font = IconFont(22);
    self.selectBtn.isIgnore = YES;
    [self.selectBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.selectBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
}

- (IBAction)selectBtnTap:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.isSelected) [LaiMethod animationWithView:button];
}


@end
