//
//  ProfileCouponCell.h
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/14.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ProfileCouponBlock)(void);

@class ProfileCoupon;
@interface ProfileCouponCell : UITableViewCell

@property(nonatomic,strong)ProfileCoupon *coupon;
@property (nonatomic, copy) ProfileCouponBlock couponBlock;
@end
