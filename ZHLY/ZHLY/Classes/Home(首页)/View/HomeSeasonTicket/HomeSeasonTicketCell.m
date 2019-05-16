//
//  HomeSeasonTicketCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/13.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeSeasonTicketCell.h"
#import "Home.h"

@interface HomeSeasonTicketCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation HomeSeasonTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSeasonTicket:(HomeMuseumSeasonTickets *)seasonTicket {
    _seasonTicket = seasonTicket;
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(SmallImage(seasonTicket.pt_image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    self.titleTextLabel.text = seasonTicket.pt_name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", seasonTicket.pt_sale_price];
    self.saleCountLabel.text = [NSString stringWithFormat:@"已售%@份", seasonTicket.pt_has_sale];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Channel_pot_id] = ChannelPotId;
    params[@"titleText"] = @"套票详情";
    params[@"apiUrl"] = @"http://192.168.1.98:9002/package_detail.html";
    params[@"dataUrl"] = [MainURL stringByAppendingPathComponent:@"tickets/detail"];
    params[@"biz_pt_id"] = self.seasonTicket.biz_pt_id;
    params[@"seasonTicket"] = self.seasonTicket;
    [LaiMethod runtimePushVcName:@"HomeSeasonTicketDetailVC" dic:params nav:CurrentViewController.navigationController];
}

@end
