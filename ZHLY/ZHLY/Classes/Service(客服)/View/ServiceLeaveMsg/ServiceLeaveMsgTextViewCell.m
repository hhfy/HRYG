
//
//  ServiceLeaveMsgTextViewCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceLeaveMsgTextViewCell.h"

@interface ServiceLeaveMsgTextViewCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet TextView *questionTextView;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;
@end

@implementation ServiceLeaveMsgTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.questionTextView.placeholder = @"请输入您要咨询的内容";
    self.questionTextView.placeholderColor = SetupColor(152, 152, 152);
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.textCountLabel.text = [NSString stringWithFormat:@"%zd/200字", textView.text.length];
    if (self.didInput) self.didInput(textView.text);
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.questionTextView.placeholder = placeholder;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 200 - comcatstr.length;
    
    if (caninputlen >= 0){
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        [SVProgressHUD showError:@"内容不超过200个字"];
        return NO;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
    return YES;
}

@end
