//
//  LoginView.h
//
//  Created by LTWL on 2017/7/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ShakeViewTypeUserName = 0,
    ShakeViewTypePwd,
    ShakeViewTypeLoginBtn
} ShakeViewType;

@class LoginView;
@protocol LoginViewDelegate <NSObject>
@optional;
- (void)didClickLoginView:(LoginView *)loginView;
- (void)didClickInputTextFieldWithLoginView:(LoginView *)loginView;
- (void)loginView:(LoginView *)loginView userName:(NSString *)text;
- (void)loginView:(LoginView *)loginView passWord:(NSString *)text;
- (void)keyboardDidClickReturn:(LoginView *)loginView;
@end
@interface LoginView : UIView
- (void)loginBtnaddTarget:(id)target action:(SEL)action;
- (void)registBtnaddTarget:(id)target action:(SEL)action;
- (void)setupPwdBtnaddTarget:(id)target action:(SEL)action;
@property (nonatomic, weak) id<LoginViewDelegate> delegate;
@property (nonatomic, assign) ShakeViewType shakeViewType;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *pwd;
@end
