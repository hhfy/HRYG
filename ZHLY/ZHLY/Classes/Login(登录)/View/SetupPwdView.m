//
//  SetupPwdView.m
//  ZTXWY
//
//  Created by LTWL on 2017/6/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "SetupPwdView.h"

@interface SetupPwdView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfrimTextField;
@property (weak, nonatomic) IBOutlet UITextField *verCodeTextField;
@end

@implementation SetupPwdView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self addTextFieldKVO];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.verCodeBtn.backgroundColor = MainThemeColor;
    self.verCodeBtn.layer.cornerRadius = self.verCodeBtn.height * 0.5;
    self.verCodeBtn.clipsToBounds = YES;
    self.telTextField.returnKeyType = self.pwdTextField.returnKeyType = self.pwdConfrimTextField.returnKeyType = self.verCodeTextField.returnKeyType = UIReturnKeyDone;
    [self.telTextField setValue:SetupColor(167, 142, 142) forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdConfrimTextField setValue:SetupColor(167, 142, 142) forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdTextField setValue:SetupColor(167, 142, 142) forKeyPath:@"_placeholderLabel.textColor"];
    [self.verCodeTextField setValue:SetupColor(167, 142, 142) forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)addTextFieldKVO {
    [self.telTextField addTarget:self action:@selector(telTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextField addTarget:self action:@selector(pwdTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdConfrimTextField addTarget:self action:@selector(pwdConfrimTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.verCodeTextField addTarget:self action:@selector(verCodeTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)telTextField:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(setupPwdView:telPhone:)]) {
        [self.delegate setupPwdView:self telPhone:textField.text];
    }
}

- (void)pwdTextField:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(setupPwdView:pwd:)]) {
        [self.delegate setupPwdView:self pwd:textField.text];
    }
}

- (void)pwdConfrimTextField:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(setupPwdView:pwdConfirm:)]) {
        [self.delegate setupPwdView:self pwdConfirm:textField.text];
    }
}

- (void)verCodeTextField:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(setupPwdView:verCode:)]) {
        [self.delegate setupPwdView:self verCode:textField.text];
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.verCodeBtn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger MaxTextLength = 0;
    
    if ([textField isEqual:self.telTextField]) {
        MaxTextLength = 11;
    } else if ([textField isEqual:self.pwdTextField] || [textField isEqual:self.pwdConfrimTextField]) {
        MaxTextLength = 18;
    } else {
        MaxTextLength = 6;
    }
    
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
        
        if ([textField isEqual:self.telTextField]) {
            [SVProgressHUD showError:@"手机号最长11位"];
        } else if (([textField isEqual:self.pwdTextField]) || [textField isEqual:self.pwdConfrimTextField]) {
            [SVProgressHUD showError:@"密码最长不超过18位"];
        } else {
            [SVProgressHUD showError:@"验证码只有6位"];
        }
                   
        return NO;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

@end
