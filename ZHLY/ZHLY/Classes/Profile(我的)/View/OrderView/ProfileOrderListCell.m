//
//  ProfileOrderListCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileOrderListCell.h"
#import "Profile.h"

@interface ProfileOrderListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@end

@implementation ProfileOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setTicket:(ProfileOrderTicketList *)ticket {
    _ticket = ticket;
    self.nameLabel.text = ticket.ticket_name;
    self.numLabel.text = [NSString stringWithFormat:@"商品数量：x%@", ticket.ticket_count];
    [self.priceBtn setTitle:[NSString stringWithFormat:@"￥%@", ticket.ticket_pay_price] forState:UIControlStateNormal];
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(ticket.ticket_image) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        if(self.orderBlock) self.orderBlock();
    }
}

@end
