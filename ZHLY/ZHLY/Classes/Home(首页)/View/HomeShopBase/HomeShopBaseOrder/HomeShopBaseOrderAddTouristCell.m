
//
//  HomeMuseumOrderAddTouristCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderAddTouristCell.h"
#import "Home.h"

@interface HomeShopBaseOrderAddTouristCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touristInfoH;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *moblieLabel;
@property (weak, nonatomic) IBOutlet UILabel *editIconLabel;
@end

@implementation HomeShopBaseOrderAddTouristCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.editIconLabel.font = IconFont(20);
    self.editIconLabel.text = EditIconUnicode2;
    self.touristInfoH.constant = 30;
}

- (void)setUserVisitor:(HomeMuseumUserVisitor *)userVisitor {
    _userVisitor = userVisitor;
    if (userVisitor.biz_visitor_id) {
        self.touristInfoH.constant = 70;
        self.nameLabel.text = userVisitor.visitor_name;
        self.IDNOLabel.textAlignment = NSTextAlignmentLeft;
        self.IDNOLabel.textColor = SetupColor(102, 102, 102);
        self.IDNOLabel.font = TextSystemFont(13);
        self.IDNOLabel.text = [NSString stringWithFormat:@"%@号：%@", (userVisitor.visitor_type == 1) ? @"身份证" : @"证件号", userVisitor.visitor_type_number];
        self.moblieLabel.text = [NSString stringWithFormat:@"手机号：%@", userVisitor.visitor_mobile];
        self.nameLabel.hidden = NO;
        self.moblieLabel.hidden = NO;
    } else {
        self.touristInfoH.constant = 30;
        self.IDNOLabel.text = @"    点击补全游客信息";
        self.IDNOLabel.textAlignment = NSTextAlignmentCenter;
        self.IDNOLabel.textColor = SetupColor(51, 51, 51);
        self.IDNOLabel.font = TextSystemFont(14.5);
        self.nameLabel.hidden = YES;
        self.moblieLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [LaiMethod runtimePushVcName:@"HomeShopBaseSelectTouristVC" dic:nil nav:CurrentViewController.navigationController];
    }
}

@end
