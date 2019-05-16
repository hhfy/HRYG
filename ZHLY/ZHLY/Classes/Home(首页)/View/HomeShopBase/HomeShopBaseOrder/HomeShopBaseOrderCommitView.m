//
//  HomeMuseumOrderCommitView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/7.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderCommitView.h"

@interface HomeShopBaseOrderCommitView ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation HomeShopBaseOrderCommitView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    if (iPhoneX) self.height += SateBottomHeightIphoneX;
    self.width = MainScreenSize.width;
}

- (void)setPrice:(CGFloat)price {
    _price = price;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", price];
}

- (IBAction)commitBtnTap:(UIButton *)button {
    if (self.didTap) self.didTap();
}

@end
