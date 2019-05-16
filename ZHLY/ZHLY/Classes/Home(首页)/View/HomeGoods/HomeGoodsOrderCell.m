
//
//  HomeGoodsOrderCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeGoodsOrderCell.h"

@interface HomeGoodsOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation HomeGoodsOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
