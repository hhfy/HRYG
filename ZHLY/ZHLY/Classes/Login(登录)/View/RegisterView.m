//
//  RegisterView.m
//  ZTXWY
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "RegisterView.h"

@interface RegisterView ()
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfirmTextField;
@end

@implementation RegisterView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self addTextFieldKVO];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.verificationCodeBtn.backgroundColor = MainThemeColor;
    self.verificationCodeBtn.layer.cornerRadius = self.verificationCodeBtn.height * 0.5;
    self.clipsToBounds = YES;
    self.telTextField.returnKeyType = self.pwdTextField.returnKeyType = self.pwdConfirmTextField.returnKeyType = self.verificationCodeTextField.returnKeyType = UIReturnKeyDone;
    [self.telTextField setValue:SetupColor(167, 142, 142) forKeyPath:@"_placeholderLabel.textColor"];
    [self.verificationCodeTextField setValue:SetupColor(167, 142, 142) forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdTextField setValue:SetupColor(167, 142, 142) forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdConfirmTextField setValue:SetupColor(167, 142, 142) forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)addTextFieldKVO {
    [self.telTextField addTarget:self action:@selector(telText:) forControlEvents:UIControlEventEditingChanged];
    [self.verificationCodeTextField addTarget:self action:@selector(verificationCode:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextField addTarget:self action:@selector(pwdText:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdConfirmTextField addTarget:self action:@selector(pwdConfirmText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)telText:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(registerView:telTextDidTextChange:)]) {
        [self.delegate registerView:self telTextDidTextChange:textField.text];
    }
}

- (void)verificationCode:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(registerView:verificationCodeDidTextChange:)]) {
        [self.delegate registerView:self verificationCodeDidTextChange:textField.text];
    }
}

- (void)pwdText:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(registerView:pwdTextDidTextChange:)]) {
        [self.delegate registerView:self pwdTextDidTextChange:textField.text];
    }
}

- (void)pwdConfirmText:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(registerView:pwdConfirmTextDidTextChange:)]) {
        [self.delegate registerView:self pwdConfirmTextDidTextChange:textField.text];
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.verificationCodeBtn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger MaxTextLength = 0;
    
    if ([textField isEqual:self.telTextField]) {
        MaxTextLength = 11;
    } else if ([textField isEqual:self.verificationCodeTextField]) {
        MaxTextLength = 6;
    } else {
        MaxTextLength = 18;
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
        } else if ([textField isEqual:self.verificationCodeTextField]) {
            [SVProgressHUD showError:@"验证码最长8位"];
        } else {
            [SVProgressHUD showError:@"密码最长不超过18位"];
        }
        return NO;
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

@end
