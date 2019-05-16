//
//  ProfileOrderRefundInfoCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/5.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileOrderRefundInfoCell.h"
#import "Profile.h"

@interface ProfileOrderRefundInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation ProfileOrderRefundInfoCell

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
}

-(void)setInfo:(NSString *)info {
    _info = info;
    self.orderLabel.text = info;
}

-(void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

@end
