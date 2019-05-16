//
//  HomeMuseumSelectTouristCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseSelectTouristCell.h"
#import "Home.h"

@interface HomeShopBaseSelectTouristCell ()
@property (weak, nonatomic) IBOutlet UILabel *IDNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIButton *editIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@end

@implementation HomeShopBaseSelectTouristCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.editIconBtn.titleLabel.font = IconFont(20);
    [self.editIconBtn setTitle:EditIconUnicode2 forState:UIControlStateNormal];
    self.defaultLabel.layer.cornerRadius = self.defaultLabel.height * 0.5;
}

- (void)setUserVisitor:(HomeMuseumUserVisitor *)userVisitor {
    _userVisitor = userVisitor;
    self.IDNOLabel.text = (userVisitor.visitor_type == 1) ? @"身份证号：" : @"证件号：";
    self.IDNOLabel.text = userVisitor.visitor_type_number;
    self.mobileLabel.text = userVisitor.visitor_mobile;
    self.nameLabel.text = userVisitor.visitor_name;
    self.defaultLabel.hidden = (userVisitor.is_default == 2);
}

- (IBAction)editBtnTap:(UIButton *)button {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"params"] = [NSDictionary createDictionayFromModelPropertiesWithObj:self.userVisitor];
    params[@"operationType"] = @1;
    [LaiMethod runtimePushVcName:@"HomeShopBaseEditTouristVC" dic:params nav:CurrentViewController.navigationController];
}


@end
