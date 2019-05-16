//
//  ProfileOrderHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2018/3/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileOrderHeaderView.h"
#import "Profile.h"

@interface ProfileOrderHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ProfileOrderHeaderView


-(void)setOrderIndex:(ProfileOrderIndex *)orderIndex {
    _orderIndex = orderIndex;
    self.titleLabel.text = [NSString stringWithFormat:@"订单编号:%@",orderIndex.order_sn];
    self.statusLabel.text = orderIndex.order_status_name;
}

- (IBAction)btnTapAction:(UIButton *)sender {
    if (self.btnTap) self.btnTap();
}

//-(NSString *)getOrderType:(NSInteger)orderStatus {
//    NSString *status = @"";
//    switch (orderStatus) {
//        case 2:
//            status = @"待付款";
//            break;
//        case 3:
//            status = @"已付款";
//            break;
//        case 4:
//            status = @"使用中";
//            break;
//        case 5:
//            status = @"已完成";
//            break;
//        case 6:
//            status = @"已评价";
//            break;
//        case 11:
//            status = @"已取消";
//            break;
//        case 12:
//            status = @"已关闭";
//            break;
//        default:
//            break;
//    }
//    return status;
//}

@end
