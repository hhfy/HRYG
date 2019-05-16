//
//  TravelsSendMomentTitleCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/2.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsSendMomentTitleCell.h"

@interface TravelsSendMomentTitleCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleCountLabel;
@end

@implementation TravelsSendMomentTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    [self.titleTextField addTarget:self action:@selector(titleTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.titleTextField setValue:SetupColor(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((JumpVcDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.titleTextField becomeFirstResponder];
    });
}

#pragma mark - UITextFieldDelegate
- (void)titleTextFieldTextChange:(UITextField *)textField {
    self.titleCountLabel.text = [NSString stringWithFormat:@"%zd/30", textField.text.length];
    if (self.inputTitle) self.inputTitle(textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger MaxTextLength = 30;
    // 切割字符串
    NSString *comcatStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger canInputLength = MaxTextLength - comcatStr.length;
    
    if (canInputLength >= 0) {
        return YES;
    } else {
        NSInteger len = string.length + canInputLength;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[string stringByReplacingCharactersInRange:range withString:s]];
        }
        [SVProgressHUD showError:@"标题不超过30个字!"];
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
    return YES;
}

@end
