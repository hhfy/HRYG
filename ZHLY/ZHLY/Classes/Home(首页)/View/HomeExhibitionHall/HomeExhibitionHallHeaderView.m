//
//  HomeExhibitionHallHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeExhibitionHallHeaderView.h"

@interface HomeExhibitionHallHeaderView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end

@implementation HomeExhibitionHallHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    if (iPhoneX) self.height += 44;
    self.iconView.layer.cornerRadius = 5;
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(@"http://dimg10.c-ctrip.com/images/20040n000000dy2fwCCCC_R_170_170.jpg") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    
}



@end
