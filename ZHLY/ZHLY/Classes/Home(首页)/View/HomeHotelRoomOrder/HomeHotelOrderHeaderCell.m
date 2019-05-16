
//
//  HomeHotelOrderHeaderCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHotelOrderHeaderCell.h"
#import "Home.h"

@interface HomeHotelOrderHeaderCell ()
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIView *countTextFiledBgView;
@property (nonatomic, assign) NSInteger count;
@end

@implementation HomeHotelOrderHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
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
    [self.countTextField addTarget:self action:@selector(countTextField:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setRoomOrderInfo:(HomeHotelRoomOrderInfo *)roomOrderInfo {
    _roomOrderInfo = roomOrderInfo;
    self.count = _roomOrderInfo.number;
    self.countTextField.text = @(self.count).description;
}

- (IBAction)minusBtnTap:(UIButton *)button {
    self.count--;
    NSInteger minCount = 1;
    if (self.count <= minCount) {
        self.count = minCount;
        button.enabled = NO;
    } 
    if (button.isEnabled) [LaiMethod animationWithView:self.countTextField];
    self.countTextField.text = @(self.count).description;
    if (self.totalPayForDidChange) self.totalPayForDidChange(self.countTextField.text.integerValue * self.roomOrderInfo.room_price.floatValue,self.count);
    self.plusBtn.enabled = YES;
}

- (IBAction)plusBtnTap:(UIButton *)button {
    self.count++;
    if (button.isEnabled) [LaiMethod animationWithView:self.countTextField];
    self.countTextField.text = @(self.count).description;
    if (self.totalPayForDidChange) self.totalPayForDidChange(self.countTextField.text.integerValue * self.roomOrderInfo.room_price.floatValue,self.count);
    self.minusBtn.enabled = YES;
}

- (void)countTextField:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) return;
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.totalPayForDidChange) weakSelf.totalPayForDidChange(weakSelf.countTextField.text.integerValue * weakSelf.roomOrderInfo.room_price.doubleValue,self.count);
    });
}

@end
