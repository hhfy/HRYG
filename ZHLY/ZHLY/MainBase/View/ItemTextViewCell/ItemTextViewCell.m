
//
//  ItemTextViewCell.m
//
//  Created by LTWL on 2017/6/19.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ItemTextViewCell.h"


@interface ItemTextViewCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet TextView *itemTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTitleW;
@end
@implementation ItemTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.itemTitleW.constant = 0;
    self.textViewLeftSpace.constant = 0;
    self.itemTextView.layer.borderWidth = 0.5;
    self.itemTextView.layer.borderColor = SetupColor(227, 227, 227).CGColor;
    self.itemTextView.layer.cornerRadius = 5;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.itemTitleLabel.text = title;
    if (title) {
        self.itemTitleW.constant = 77;
        if (iPhone5) {
            self.textViewLeftSpace.constant = 30;
        } else if (iPhone6) {
            self.textViewLeftSpace.constant = 40;
        } else if (iPhone6P) {
            self.textViewLeftSpace.constant = 50;
        }
    } else {
        self.itemTitleW.constant = 0;
        self.textViewLeftSpace.constant = 0;
    }
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    self.itemTextView.placeholder = placeholderText;
}

- (void)setTextViewResponderType:(TextViewFirstResponderType)textViewResponderType {
    _textViewResponderType = textViewResponderType;
    switch (textViewResponderType) {
        case TextViewFirstResponderTypeBecome:
            [self.itemTextView becomeFirstResponder];
            break;
        case TextViewFirstResponderTypeRegist:
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 1.8) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.itemTextView resignFirstResponder];
            });
            break;
    }
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.itemTextView.text = text;
}

- (void)setTextViewBgColor:(UIColor *)textViewBgColor {
    _textViewBgColor = textViewBgColor;
    self.itemTextView.backgroundColor = textViewBgColor;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(itemTextViewCell:textViewInputText:)]) {
        [self.delegate itemTextViewCell:self textViewInputText:textView.text];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewDidClick:)]) {
        [self.delegate textViewDidClick:self];
    }
}

@end
