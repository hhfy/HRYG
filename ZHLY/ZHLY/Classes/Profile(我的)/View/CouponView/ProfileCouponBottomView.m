//
//  ProfileCouponBottomView.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/15.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileCouponBottomView.h"
#import "Profile.h"

@interface ProfileCouponBottomView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ProfileCouponBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgHeight.constant = RateHeight375(71);
}

-(void)setCoupon:(ProfileCoupon *)coupon {
    _coupon = coupon;
    if(coupon.surplus_num>0){
        [self.btn setTitle:@"立即领券" forState:UIControlStateNormal];
        self.btn.enabled = YES;
        self.btn.backgroundColor = SetupColor(228, 167, 102);
    }
    else {
        [self.btn setTitle:@"已领完" forState:UIControlStateNormal];
        self.btn.enabled = NO;
        self.btn.backgroundColor = SetupColor(205, 205, 205);
    }
}

- (IBAction)btnAction:(id)sender {
    if (self.coupon.status == 1) { // 1未开始  2进行中  3已结束
        [SVProgressHUD showError:@"未开始"];
    }
    else if (self.coupon.status == 2) {
        if(self.coupon.surplus_num>0) {
            if (self.coupon.is_get == 2) {
                [SVProgressHUD showError:@"已达到最大参与次数"];
            }
            else {
                [self postRequest];
            }
        }
    }
    else if (self.coupon.status == 3) {
        [SVProgressHUD showError:@"已结束"];
    }
}

-(void)postRequest {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [SaveTool objectForKey:Token];
    params[@"biz_pt_id"] = self.coupon.biz_pt_id;
    NSString *url = [MainURL stringByAppendingPathComponent:@"promotion/add"];
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"领取成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CurrentViewController.navigationController popViewControllerAnimated:YES];
        });
    } otherCase:^(NSInteger code) {
    } failure:^(NSError *error) {
    }];
}

@end
