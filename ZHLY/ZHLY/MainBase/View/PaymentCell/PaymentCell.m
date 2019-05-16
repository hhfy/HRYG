//
//  PaymentCell.m
//  GXBG
//
//  Created by LTWL on 2017/11/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "PaymentCell.h"
#import "Home.h"

@interface PaymentCell ()
@property (weak, nonatomic) IBOutlet UIButton *aliPaySelectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *weichatPaySelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alipayIcon;
@property (weak, nonatomic) IBOutlet UIImageView *weichatIcon;

@end

@implementation PaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.alipayIcon.image = SetImage(@"icons.bundle/alipay");
    self.weichatIcon.image = SetImage(@"icons.bundle/wechat");
    
    self.aliPaySelectedBtn.titleLabel.font = self.weichatPaySelectBtn.titleLabel.font = IconFont(20);
    [self.aliPaySelectedBtn setTitleColor:SetupColor(180, 180, 180) forState:UIControlStateNormal];
    [self.aliPaySelectedBtn setTitleColor:MainThemeColor forState:UIControlStateSelected];
    [self.aliPaySelectedBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.aliPaySelectedBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
    
    [self.weichatPaySelectBtn setTitleColor:SetupColor(180, 180, 180) forState:UIControlStateNormal];
    [self.weichatPaySelectBtn setTitleColor:MainThemeColor forState:UIControlStateSelected];
    [self.weichatPaySelectBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.weichatPaySelectBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
    self.priceLabel.textColor = MainThemeColor;
    self.aliPaySelectedBtn.selected = YES;
}

-(void)setPayTypeList:(NSArray *)payTypeList {
    _payTypeList = payTypeList;
    for (int i=0; i<payTypeList.count; i++) {
        TicketPayType *type = payTypeList[i];
        if ([type.pay_name rangeOfString:@"支付宝"].location == NSNotFound) {
            self.aliPaySelectedBtn.tag = [type.pay_type integerValue];
        }
        if ([type.pay_name rangeOfString:@"微信"].location == NSNotFound) {
            self.weichatPaySelectBtn.tag = [type.pay_type integerValue];
        }
    }
}

- (IBAction)alipayTap:(UIButton *)button {
    button.selected = !button.isSelected;
    [LaiMethod animationWithView:button];
    if (button.isSelected) {
        self.weichatPaySelectBtn.selected = NO;
        if (self.paymentSeletedType) self.paymentSeletedType(button.tag);
    }
}

- (IBAction)weichatPayTap:(UIButton *)button {
    button.selected = !button.isSelected;
    [LaiMethod animationWithView:button];
    if (button.isSelected) {
        self.aliPaySelectedBtn.selected = NO;
        if (self.paymentSeletedType) self.paymentSeletedType(button.tag);
    }
}

@end
