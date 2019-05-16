
//
//  ItemTextFiledCell.m
//
//  Created by LTWL on 2017/6/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ItemTextFiledCell.h"

@interface ItemTextFiledCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *ItemTextField;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTextFieldLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemUnitLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineRightSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTitleW;
@end

@implementation ItemTextFiledCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self addTextFieldKVO];
    [self setupValue];
}

- (void)setupValue {
    self.keyboardType = UIKeyboardTypeDefault;
    self.unitLabel.text = nil;
    self.itemTextFieldLeftSpace.constant = 0;
    self.title = nil;
}

- (void)setupUI {
    self.itemTextFieldLeftSpace.constant = 0;
    [self.ItemTextField setValue:SetupColor(153, 153, 153) forKeyPath:@"_placeholderLabel.textColor"];
    self.ItemTextField.returnKeyType = UIReturnKeyDone;
    [self addTextFieldKVO];
    
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 2.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([weakSelf.ItemTextField hasText]) return;
//        if (weakSelf.tag == 0) [weakSelf.ItemTextField becomeFirstResponder];
    });
}

- (void)addTextFieldKVO {
    [self.ItemTextField addTarget:self action:@selector(itemTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)itemTextField:(UITextField *)textField {
    if (self.textDidChange) self.textDidChange(textField.text);
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.ItemTextField.tag = self.tag;
    self.itemTitleLabel.text = title;
    if (title) {
        self.itemTitleW.constant = 77;
        self.itemTextFieldLeftSpace.constant = (self.textLeftSpace) ? self.textLeftSpace : 30;
    } else {
        self.itemTitleW.constant = 0;
        self.itemTextFieldLeftSpace.constant = 0;
    }
}

- (void)setTitleW:(CGFloat)titleW {
    _titleW = titleW;
    self.itemTitleW.constant = titleW;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self.ItemTextField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = [placeholderText copy];
    self.ItemTextField.tag = self.tag;
    self.ItemTextField.placeholder = placeholderText;
}

- (void)setUnit:(NSString *)unit {
    _unit = unit;
    self.unitLabel.text = unit;
    self.itemTextFieldLeftSpace.constant = (unit) ? 10 : 0;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.ItemTextField.keyboardType = keyboardType;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.ItemTextField.text = text;
}

- (void)setTextAlign:(NSTextAlignment)textAlign {
    _textAlign = textAlign;
    self.ItemTextField.textAlignment = textAlign;
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    self.lineTopSpace.constant = cellHeight;
}

- (void)setTextFieldBgColor:(UIColor *)textFieldBgColor {
    _textFieldBgColor = textFieldBgColor;
    self.ItemTextField.backgroundColor = textFieldBgColor;
}

- (void)setLineLeftW:(CGFloat)lineLeftW {
    _lineLeftW = lineLeftW;
    self.lineLeftSpace.constant = lineLeftW;
}

- (void)setLineRightW:(CGFloat)lineRightW {
    _lineRightW = lineRightW;
    self.lineRightSpace.constant = lineRightW;
}

- (void)setTextLeftSpace:(CGFloat)textLeftSpace {
    _textLeftSpace = textLeftSpace;
    self.itemTextFieldLeftSpace.constant = textLeftSpace;
}

- (void)setIsSecureTextEntry:(BOOL)isSecureTextEntry {
    _isSecureTextEntry = isSecureTextEntry;
    self.ItemTextField.secureTextEntry = isSecureTextEntry;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.textBeginEidt) self.textBeginEidt();
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger MaxTextLength = (self.textMaxLenght) ? self.textMaxLenght : 20;
        // 切割字符串
        NSString *comcatStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSInteger canInputLength = MaxTextLength - comcatStr.length;
    
        if (canInputLength >= 0)
        {
            return YES;
        }
        else
        {
            NSInteger len = string.length + canInputLength;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
    
            if (rg.length > 0)
            {
                NSString *s = [string substringWithRange:rg];
    
                [textField setText:[string stringByReplacingCharactersInRange:range withString:s]];
            }
            [SVProgressHUD showError:(self.exceedMsg) ? self.exceedMsg : @"最大不超过20个字"];
            return NO;
        }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
    return YES;
}

@end
