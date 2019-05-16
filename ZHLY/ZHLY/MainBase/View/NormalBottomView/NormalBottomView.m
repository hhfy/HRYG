//
//  NormalBottomView.m
//  ZTXWY
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "NormalBottomView.h"

@interface NormalBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@end

@implementation NormalBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.height = 60;
    self.itemButton.backgroundColor = MainThemeColor;
    self.itemButton.layer.cornerRadius = 5;
    self.itemButton.clipsToBounds = YES;
    self.itemButton.isIgnore = YES;
}

- (void)setTitle:(NSString *)title {
     _title = [title copy];
    [self.itemButton setTitle:title forState:UIControlStateNormal];
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void)setBtnBgColor:(UIColor *)btnBgColor {
    _btnBgColor = btnBgColor;
    self.itemButton.backgroundColor = btnBgColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.itemButton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.itemButton.layer.borderColor = borderColor.CGColor;
    self.itemButton.layer.borderWidth = 0.5;
}

- (void)setStatusType:(ItemBtnStatusType)statusType {
    _statusType = statusType;
    switch (statusType) {
        case ItemBtnStatusTypeEnbale:
            self.itemButton.enabled = YES;
            if (!self.btnBgColor) self.itemButton.backgroundColor = MainThemeColor;
            break;
        case ItemBtnStatusTypeDisable:
            self.itemButton.enabled = NO;
            if (!self.btnBgColor) self.itemButton.backgroundColor = SetupColor(198, 198, 198);
            break;
        default:
            break;
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.itemButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)nextStepBtn:(UIButton *)button {
    if (self.didTap) self.didTap();
}

@end
