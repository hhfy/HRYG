//
//  ProfileOrderDetailGoodsCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/5.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileOrderDetailGoodsCell.h"
#import "Profile.h"

@interface ProfileOrderDetailGoodsCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ProfileOrderDetailGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrderTicket:(ProfileOrderTicketList *)orderTicket {
    _orderTicket = orderTicket;
    self.titleLabel.text = orderTicket.ticket_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",orderTicket.ticket_pay_price];
    self.siteLabel.hidden = YES;
    self.countLabel.text = [NSString stringWithFormat:@"商品数量：x%@",orderTicket.ticket_count];
    //座位
    if(orderTicket.site_name){
        self.siteLabel.hidden = NO;
        self.siteLabel.text = orderTicket.site_name;
    }
    if(orderTicket.ticket_starttime && orderTicket.ticket_endtime){
        NSString *time = [NSString stringWithFormat:@"%@ ~ %@",[NSString dateStr:orderTicket.ticket_starttime formatter:@"YYYY-MM-dd HH:mm:ss" formatWithOtherFormatter:@"YYYY-MM-dd"],[NSString dateStr:orderTicket.ticket_endtime formatter:@"YYYY-MM-dd HH:mm:ss" formatWithOtherFormatter:@"YYYY-MM-dd"]];
        NSString *name = [orderTicket.biz_ticket_id integerValue]!=0 ? @"游玩时间" : @"入住时间";
        self.timeLabel.text = [NSString stringWithFormat:@"%@：%@",name,time];
    }
}

@end
