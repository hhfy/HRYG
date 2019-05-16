//
//  HomeShoppingCarCommitView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShoppingCarCommitView.h"

@interface HomeShoppingCarCommitView ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@end

@implementation HomeShoppingCarCommitView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.selectBtn.titleLabel.font = IconFont(22);
    self.selectBtn.isIgnore = YES;
    self.selectBtn.selected = YES;
    [self.selectBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.selectBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
}

- (IBAction)selectBtnTap:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.isSelected) {
        [LaiMethod animationWithView:button];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f", self.currentPrice];
        [self.commitBtn setTitle:[NSString stringWithFormat:@"结算(%zd)", self.goodsCount] forState:UIControlStateNormal];
    } else {
        self.totalPriceLabel.text = @"合计：￥0.00";
        [self.commitBtn setTitle:@"结算" forState:UIControlStateNormal];
    }
    if (self.checkAll) self.checkAll(button.isSelected);
}

- (void)setCurrentPrice:(CGFloat)currentPrice {
    _currentPrice = currentPrice;
    if (currentPrice > 0) {
        self.totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f", currentPrice];
    } else {
        self.totalPriceLabel.text = @"合计：￥0.00";
    }
}

- (void)setIsCheckAll:(BOOL)isCheckAll {
    _isCheckAll = isCheckAll;
    self.selectBtn.selected = isCheckAll;
    self.selectLabel.text = isCheckAll ? @"取消全选" :@"全选" ;
}

- (void)setGoodsCount:(NSInteger)goodsCount {
    _goodsCount = goodsCount;
    if (goodsCount > 0) {
        [self.commitBtn setTitle:[NSString stringWithFormat:@"结算(%zd)", goodsCount] forState:UIControlStateNormal];
    } else {
        [self.commitBtn setTitle:@"结算" forState:UIControlStateNormal];
    }
}

- (IBAction)commitBtnTap:(UIButton *)button {
    if (self.commit) self.commit();
}


@end
