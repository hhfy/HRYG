//
//  ProfileOrderFooterView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/8.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileOrderFooterView.h"
#import "Profile.h"

@interface ProfileOrderFooterView()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation ProfileOrderFooterView


- (IBAction)cancelAction:(UIButton *)sender {
    if (self.btnBlock) self.btnBlock(sender.tag);
}
- (IBAction)payAction:(UIButton *)sender {
    if (self.btnBlock) self.btnBlock(sender.tag);
}

-(void)setOrderIndex:(ProfileOrderIndex *)orderIndex {
    _orderIndex = orderIndex;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",orderIndex.order_pay_price];
    self.cancelBtn.layer.borderColor = SetupColor(102, 102, 102).CGColor;
    self.cancelBtn.backgroundColor = [UIColor whiteColor];
    [self.cancelBtn setTitleColor:SetupColor(102, 102, 102) forState:UIControlStateNormal];
    self.cancelBtn.hidden = NO;
    self.payBtn.layer.borderColor = SetupColor(228, 167, 102).CGColor;
    self.payBtn.backgroundColor = SetupColor(228, 167, 102);
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payBtn.hidden = NO;
    //order_status 2未付款，3已付款，4使用中，5已完成，6已评价，11已取消，12已关闭
    switch (orderIndex.order_status) {
        case 2:
        {
            [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.payBtn setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            self.cancelBtn.hidden = YES;
            [self.payBtn setTitle:@"退款" forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            self.cancelBtn.hidden = YES;
            [self.payBtn setTitle:@"去评价" forState:UIControlStateNormal];
        }
            break;
        case 6:
        {
            self.cancelBtn.hidden = YES;
            [self.payBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.payBtn.layer.borderColor = SetupColor(102, 102, 102).CGColor;
            self.payBtn.backgroundColor = [UIColor whiteColor];
            [self.payBtn setTitleColor:SetupColor(102, 102, 102) forState:UIControlStateNormal];
        }
            break;
        case 11:
        {
            self.cancelBtn.hidden = YES;
            [self.payBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.payBtn.layer.borderColor = SetupColor(102, 102, 102).CGColor;
            self.payBtn.backgroundColor = [UIColor whiteColor];
            [self.payBtn setTitleColor:SetupColor(102, 102, 102) forState:UIControlStateNormal];
        }
            break;
        case 12:
        {
            self.cancelBtn.hidden = YES;
            [self.payBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.payBtn.layer.borderColor = SetupColor(102, 102, 102).CGColor;
            self.payBtn.backgroundColor = [UIColor whiteColor];
            [self.payBtn setTitleColor:SetupColor(102, 102, 102) forState:UIControlStateNormal];
        }
            break;
        default:
        {
            self.cancelBtn.hidden = YES;
            self.payBtn.hidden = YES;
        }
            break;
    }
}


@end
