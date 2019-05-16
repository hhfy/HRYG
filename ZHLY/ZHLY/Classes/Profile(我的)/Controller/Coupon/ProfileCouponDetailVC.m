//
//  ProfileCouponDetailVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/15.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileCouponDetailVC.h"
#import "ProfileCouponTopHeaderView.h"
#import "ProfileCouponCenterView.h"
#import "ProfileCouponBottomView.h"
#import "Profile.h"

@interface ProfileCouponDetailVC ()
@property (nonatomic,strong) ProfileCouponTopHeaderView *headerView;
@property (nonatomic,strong) ProfileCouponCenterView *centerView;
@property (nonatomic,strong) ProfileCouponBottomView *bottomView;
@property (nonatomic,strong) ProfileCoupon *coupon;
@end

@implementation ProfileCouponDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券详情";
    [self getCouponData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeaderView {
    ProfileCouponTopHeaderView *headerView = [ProfileCouponTopHeaderView viewFromXib];
    headerView.width = self.view.width;
    headerView.height = RateHeight375(148)+35;
    [self.view addSubview:headerView];
    _headerView = headerView;
}

- (void)setCenterView {
    ProfileCouponCenterView *centerView = [ProfileCouponCenterView viewFromXib];
    centerView.y = _headerView.height;
    centerView.width = self.view.width;
    centerView.height = RateHeight375(315);
    [self.view addSubview:centerView];
    _centerView = centerView;
}

- (void)setBottomView {
    ProfileCouponBottomView *bottomView = [ProfileCouponBottomView viewFromXib];
    bottomView.y = _headerView.height+_centerView.height;
    bottomView.height = RateHeight375(71)+29;
    bottomView.width = self.view.width;
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
}

- (void)getCouponData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"promotion/info"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"biz_pt_id"] = self.biz_pt_id;
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:NO progress:nil success:^(id json) {
        weakSelf.coupon = [ProfileCoupon mj_objectWithKeyValues:json[Data]];
        [self setHeaderView];
        [self setCenterView];
        [self setBottomView];
        weakSelf.headerView.coupon = weakSelf.coupon;
        weakSelf.centerView.coupon = weakSelf.coupon;
        weakSelf.bottomView.coupon = weakSelf.coupon;
    } otherCase:^(NSInteger code) {

    } failure:^(NSError *error) {

    }];
}


@end
