//
//  ProfileCouponCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/14.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileCouponCell.h"
#import "Profile.h"

@interface ProfileCouponCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *drawBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftX;

@end

@implementation ProfileCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"biz_pt_id"] = self.coupon.biz_pt_id;
        [LaiMethod runtimePushVcName:@"ProfileCouponDetailVC" dic:params nav:CurrentViewController.navigationController];
    }
}

- (IBAction)drawBtnAction:(id)sender {
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

-(void)setCoupon:(ProfileCoupon *)coupon {
    _coupon = coupon;
    CGFloat font;
    if (iPhone5 || iPhoneSE) {
        self.rightX.constant = -3;
        self.leftX.constant = 23;
        font = 22;
    }
    else {
        self.rightX.constant = RateHeight375(-9.5);
        self.leftX.constant = RateHeight375(24.5);
        font = 28;
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:coupon.pt_image] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    self.titleLabel.text = coupon.pt_name;
    NSString *start = [NSString dateStr:coupon.pt_stime formatter:@"YYYY-MM-dd HH:mm:ss" formatWithOtherFormatter:@"YYYY-MM-dd"];
    NSString *end = [NSString dateStr:coupon.pt_etime formatter:@"YYYY-MM-dd HH:mm:ss" formatWithOtherFormatter:@"YYYY-MM-dd"];
    self.timeLabel.text = [NSString stringWithFormat:@"有效期:%@ ~ %@",start,end];
    self.numLabel.text = [NSString stringWithFormat:@"剩余:%zd",coupon.surplus_num];
    
    self.infoLabel.text = [NSString stringWithFormat:@"¥%@  满%@可用",coupon.pt_discount,coupon.pt_limit];
    [LaiMethod applyAttributeToLabel:self.infoLabel atRange:NSMakeRange(1,coupon.pt_discount.length) withAttributes:@{NSFontAttributeName:TextBoldFont(font)}];
    if(coupon.surplus_num>0){
        [self.drawBtn setTitle:@"领券" forState:UIControlStateNormal];
        self.drawBtn.enabled = YES;
        self.drawBtn.backgroundColor = SetupColor(228, 167, 102);
    }
    else {
        [self.drawBtn setTitle:@"已领完" forState:UIControlStateNormal];
        self.drawBtn.enabled = NO;
        self.drawBtn.backgroundColor = SetupColor(205, 205, 205);
    }
}

-(void)postRequest {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [SaveTool objectForKey:Token];
    params[@"biz_pt_id"] = self.coupon.biz_pt_id;
//    params[@"sign"] = [LaiMethod getSign];
//    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    NSString *url = [MainURL stringByAppendingPathComponent:@"promotion/add"];
    
//    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"领取成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.couponBlock) self.couponBlock();
        });
    } otherCase:^(NSInteger code) {
       
    } failure:^(NSError *error) {
        
    }];
}

@end
