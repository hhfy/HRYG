//
//  RegisterView.h
//  ZTXWY
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegisterView;
@protocol RegisterViewDelegate <NSObject>
@optional
- (void)registerView:(RegisterView *)RegisterView telTextDidTextChange:(NSString *)text;
- (void)registerView:(RegisterView *)RegisterView verificationCodeDidTextChange:(NSString *)text;
- (void)registerView:(RegisterView *)RegisterView pwdTextDidTextChange:(NSString *)text;
- (void)registerView:(RegisterView *)RegisterView pwdConfirmTextDidTextChange:(NSString *)text;
@end

@interface RegisterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;
@property (nonatomic, weak) id<RegisterViewDelegate> delegate;
- (void)addTarget:(id)target action:(SEL)action;
@end
