//
//  HomeGoodsCellTableViewCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeGoodsCell.h"
#import "Home.h"

@interface HomeGoodsCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *detialInfoTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet HomeGoodsPriceLabel *originalPriceLabel;

@end

@implementation HomeGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoods:(HomeGoods *)goods {
    _goods = goods;
    [self.loaddingView startAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"apiUrl"] = @"http://192.168.1.98:9002/goodDetail.html";
        params[@"titleText"] = @"商品详情";
        params[@"goodId"] = @4; //self.goods.wlbm;
        [LaiMethod runtimePushVcName:@"HomeGoodsDetialVC" dic:params nav:CurrentViewController.navigationController];
    }
}

@end

@implementation HomeGoodsPriceLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.textColor setFill];
    UIRectFill(CGRectMake(0, self.height * 0.5, rect.size.width, 1));
}

@end

