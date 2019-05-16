//
//  ProfileCouponTopHeaderView.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/15.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileCouponTopHeaderView.h"
#import "Profile.h"

@interface ProfileCouponTopHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@end


@implementation ProfileCouponTopHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgHeight.constant = RateHeight375(148);
}

-(void)setCoupon:(ProfileCoupon *)coupon {
    _coupon = coupon;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:coupon.pt_image] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    self.nameLabel.text = coupon.pt_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@  (满%@可用)",coupon.pt_discount,coupon.pt_limit];
    [LaiMethod applyAttributeToLabel:self.priceLabel atRange:NSMakeRange(1,coupon.pt_discount.length) withAttributes:@{NSFontAttributeName:TextBoldFont(30)}];
    
    NSString *start = [NSString dateStr:coupon.pt_stime formatter:@"YYYY-MM-dd HH:mm:ss" formatWithOtherFormatter:@"YYYY-MM-dd"];
    NSString *end = [NSString dateStr:coupon.pt_etime formatter:@"YYYY-MM-dd HH:mm:ss" formatWithOtherFormatter:@"YYYY-MM-dd"];
    self.timeLabel.text = [NSString stringWithFormat:@"有效期:%@ ~ %@",start,end];
}

@end
