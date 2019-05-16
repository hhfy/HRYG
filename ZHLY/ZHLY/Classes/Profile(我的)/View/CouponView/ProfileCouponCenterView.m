//
//  ProfileCouponCenterView.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/15.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileCouponCenterView.h"
#import "Profile.h"
#import "ProfileCenterInfoCell.h"

@interface ProfileCouponCenterView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@end


@implementation ProfileCouponCenterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgHeight.constant = RateHeight375(315);
    [self setupTableView];
}

-(void)setCoupon:(ProfileCoupon *)coupon {
    _coupon = coupon;
}


- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 0, self.width-30, self.imgHeight.constant) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 30.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    _tableView = tableView;
}
#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCenterInfoCell *cell = [ProfileCenterInfoCell cellFromXibWithTableView:tableView];
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"活动简介";
            cell.infoLabel.text = self.coupon.pt_intro;
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"购买须知";
            cell.infoLabel.text = self.coupon.pt_buy_intro;
        }
            break;
        case 2:
        {
            cell.titleLabel.text = @"使用须知";
            cell.infoLabel.text = self.coupon.pt_use_intro;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


@end
