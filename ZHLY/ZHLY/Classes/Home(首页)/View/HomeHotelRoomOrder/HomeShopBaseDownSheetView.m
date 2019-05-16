
//
//  HomeShopBaseDownSheetView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseDownSheetView.h"
#import "Home.h"

@interface HomeShopBaseDownSheetView ()
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIView *countTextFiledBgView;
@property (weak, nonatomic) IBOutlet UIView *sheetContianerView;
@property (nonatomic, assign) NSInteger count;
@end
@implementation HomeShopBaseDownSheetView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.size = MainScreenSize;
    self.count = 1;
    self.countTextField.text = @(self.count).description;
    self.minusBtn.isIgnore = self.plusBtn.isIgnore = YES;
    self.minusBtn.enabled = NO;
    
    self.countTextFiledBgView.layer.borderWidth = 0.5;
    self.countTextFiledBgView.layer.borderColor = SetupColor(224, 157, 91).CGColor;
    self.minusBtn.titleLabel.font = self.plusBtn.titleLabel.font = IconFont(20);
    self.minusBtn.adjustsImageWhenHighlighted = self.plusBtn.adjustsImageWhenHighlighted = NO;
    [self.minusBtn setTitle:MinusIconUnicode forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
    [self.plusBtn setTitle:PlusIconUnicode forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
}

- (IBAction)minusBtnTap:(UIButton *)button {
    self.count--;
    NSInteger minCount = (self.museumTicket.ticket_num) ? self.museumTicket.ticket_num : 1;
    if (self.count <= minCount) {
        self.count = minCount;
        button.enabled = NO;
    }
    if (button.isEnabled) [LaiMethod animationWithView:self.countTextField];
    self.countTextField.text = @(self.count).description;
    self.plusBtn.enabled = YES;
}

- (IBAction)plusBtnTap:(UIButton *)button {
    self.count++;
    if (self.museumTicket.ticket_store_isopen == 1) {
        if (self.count >= self.museumTicket.ticket_remain_num) {
            self.count = self.museumTicket.ticket_remain_num;
            button.enabled = NO;
        }
    }
    if (button.isEnabled) [LaiMethod animationWithView:self.countTextField];
    self.countTextField.text = @(self.count).description;
    self.minusBtn.enabled = YES;
}

- (IBAction)addShoppingCarBtnTap:(UIButton *)button {
    [self dismiss];
    if (self.dismissCallBack) self.dismissCallBack(self.count,button.tag);
}

- (IBAction)buyBtnAction:(id)sender {
    [self dismiss];
    UIButton *btn = sender;
    if (self.dismissCallBack) self.dismissCallBack(self.count,btn.tag);
}

- (void)setMuseumTicket:(HomeTicket *)museumTicket {
    _museumTicket = museumTicket;
    self.count = (self.museumTicket.ticket_num) ? self.museumTicket.ticket_num : 1;
    self.countTextField.text = @(self.count).description;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint tapPoint = [touch locationInView:self];
    if (!CGRectContainsPoint(self.sheetContianerView.frame, tapPoint)) [self dismiss];
}

- (void)show {
    [AlertPopViewTool alertSheetPopView:self animated:YES];
}

- (void)dismiss {
    [AlertPopViewTool alertSheetPopViewDismiss:YES];
}


@end
