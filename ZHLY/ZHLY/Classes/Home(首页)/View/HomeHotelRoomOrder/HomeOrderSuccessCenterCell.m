//
//  HomeOrderSuccessCenterCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/19.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "HomeOrderSuccessCenterCell.h"
@interface HomeOrderSuccessCenterCell ()
@property (weak, nonatomic) IBOutlet UIButton *buyAgainBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderDetailBtn;

@end

@implementation HomeOrderSuccessCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyAgainBtn.layer.borderColor = SetupColor(51, 51, 51).CGColor;
    self.orderDetailBtn.layer.borderColor = SetupColor(51, 51, 51).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)buyAgainAction:(id)sender {
     [CurrentViewController.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)orderDetailAction:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bizOrderId"] = self.biz_order_id;
    params[@"isFromXiaDanChengGong"] = @"YES";
    [LaiMethod runtimePushVcName:@"ProfileOrderDetailVC" dic:params nav:CurrentViewController.navigationController];
}

@end
