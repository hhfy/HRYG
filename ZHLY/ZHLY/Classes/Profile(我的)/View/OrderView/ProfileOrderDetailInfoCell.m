//
//  ProfileOrderDetailInfoCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/5.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileOrderDetailInfoCell.h"
#import "Profile.h"

@interface ProfileOrderDetailInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ProfileOrderDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrderInfo:(ProfileOrderInfo *)orderInfo {
    _orderInfo = orderInfo;
    self.orderLabel.text = orderInfo.order_sn;
    self.timeLabel.text = orderInfo.create_time;
    self.statusLabel.text = orderInfo.order_status_name;
    self.payLabel.text = orderInfo.pay_type_status;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",orderInfo.order_pay_price];
}

@end
