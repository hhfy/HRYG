//
//  ItemSelectBtnCell.m
//  ZTXWYGL
//
//  Created by LTWL on 2017/6/17.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ItemSelectBtnCell.h"

@interface ItemSelectBtnCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *fristSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondSelectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopSpace;
@property (weak, nonatomic) IBOutlet UIButton *thirdSelctedBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemSelectBtnLeftSpace;
@end

@implementation ItemSelectBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.fristSelectBtn.titleLabel.font = self.secondSelectBtn.titleLabel.font = self.thirdSelctedBtn.titleLabel.font = IconFont(22);
    self.fristSelectBtn.isIgnore = self.secondSelectBtn.isIgnore = self.thirdSelctedBtn.isIgnore = YES;
    
    [self.fristSelectBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
    [self.fristSelectBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.fristSelectBtn setTitleColor:MainThemeColor forState:UIControlStateSelected];
    [self.fristSelectBtn setTitleColor:SetupColor(227, 227, 227) forState:UIControlStateNormal];
    
    [self.secondSelectBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
    [self.secondSelectBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.secondSelectBtn setTitleColor:MainThemeColor forState:UIControlStateSelected];
    [self.secondSelectBtn setTitleColor:SetupColor(227, 227, 227) forState:UIControlStateNormal];
    
    [self.thirdSelctedBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
    [self.thirdSelctedBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.thirdSelctedBtn setTitleColor:MainThemeColor forState:UIControlStateSelected];
    [self.thirdSelctedBtn setTitleColor:SetupColor(227, 227, 227) forState:UIControlStateNormal];
    
    self.fristSelectBtn.selected = YES;
    self.fristSelectBtn.hidden = self.secondSelectBtn.hidden = NO;
    self.thirdSelctedBtn.hidden = YES;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.itemTitleLabel.text = title;
}

- (void)setFirstText:(NSString *)firstText {
    _firstText = firstText;
    self.firstTextLabel.text = firstText;
}

- (void)setSecondText:(NSString *)secondText {
    _secondText = secondText;
    self.secondTextLabel.text = secondText;
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    self.lineTopSpace.constant = cellHeight;
}

- (void)setSelectBtnLeft:(CGFloat)selectBtnLeft {
    _selectBtnLeft = selectBtnLeft;
    self.itemSelectBtnLeftSpace.constant = selectBtnLeft;
}

- (void)setSelectedBtnType:(SelectedBtnType)selectedBtnType {
    _selectedBtnType = selectedBtnType;
    switch (selectedBtnType) {
        case SelectedBtnTypeFirst:
            self.fristSelectBtn.selected = YES;
            self.secondSelectBtn.selected = NO;
            break;
        case SelectedBtnTypeSecond:
            self.fristSelectBtn.selected = NO;
            self.secondSelectBtn.selected = YES;
            break;
        default:
            break;
    }
}

- (void)setSelectedBtnMode:(SelectedBtnMode)selectedBtnMode {
    _selectedBtnMode = selectedBtnMode;
    switch (selectedBtnMode) {
        case SelectedBtnModeSingle:
            self.fristSelectBtn.hidden = self.secondSelectBtn.hidden = YES;
            self.thirdSelctedBtn.hidden = NO;
            break;
        case SelectedBtnModeMultiple:
            self.fristSelectBtn.hidden = self.secondSelectBtn.hidden = NO;
            self.thirdSelctedBtn.hidden = YES;
            break;
        default:
            break;
    }
}

- (IBAction)firstSelectBtnClick:(UIButton *)button {
    button.selected = YES;
    self.secondSelectBtn.selected = NO;
    if (button.isSelected) {
        [LaiMethod animationWithView:button];
        if (self.didSelected) self.didSelected(1, YES);
    }
}

- (IBAction)secondSelectBtnClick:(UIButton *)button {
    button.selected = YES;
    self.fristSelectBtn.selected = NO;
    if (button.isSelected) {
        [LaiMethod animationWithView:button];
        if (self.didSelected) self.didSelected(2, YES);
    }
}

- (IBAction)thirdSelectBtnClick:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.isSelected) {
        [LaiMethod animationWithView:button];
        if (self.didSelected) self.didSelected(3, YES);
    } else {
        if (self.didSelected) self.didSelected(3, NO);
    }
}

- (void)setSelectBtnIsSeleted:(BOOL)selectBtnIsSeleted {
    _selectBtnIsSeleted = selectBtnIsSeleted;
    self.thirdSelctedBtn.selected = selectBtnIsSeleted;
}

@end
