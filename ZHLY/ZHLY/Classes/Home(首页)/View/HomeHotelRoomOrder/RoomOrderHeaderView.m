//
//  RoomOrderHeaderView.m
//  YWY2
//
//  Created by LTWL on 2017/5/3.
//  Copyright © 2017年 XMB. All rights reserved.
//

#import "RoomOrderHeaderView.h"

@interface RoomOrderHeaderView ()
@property (weak, nonatomic) IBOutlet QuiteButton *quiteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@end

@implementation RoomOrderHeaderView

+ (instancetype)show {
    return [[[NSBundle mainBundle] loadNibNamed:@"RoomOrderHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.topHeight.constant = (iPhoneX) ? 44 : 20;
    self.height = (iPhoneX) ? 194 : 170;
    self.contentView.backgroundColor = MainThemeColor;
    self.quiteBtn.titleLabel.font = IconFont(20);
    [self.quiteBtn setTitle:@"\U0000e685" forState:UIControlStateNormal];
    self.roomClassLabel.textColor = [UIColor blackColor];
    self.roomInfoLabel.textColor = self.roomOtherInfoLabel.textColor = SetupColor(51, 51, 51);
    self.contianerView.layer.cornerRadius = 2;
    self.contianerView.clipsToBounds = YES;
}

- (IBAction)quiteBtnClick {
    [CurrentViewController.navigationController popViewControllerAnimated:YES];
}

@end

@implementation QuiteButton

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.x = 10;
}

@end
