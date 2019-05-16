//
//  SetupPwdView.h
//  ZTXWY
//
//  Created by LTWL on 2017/6/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetupPwdView;
@protocol SetupPwdViewDelegate <NSObject>
@optional
- (void)setupPwdView:(SetupPwdView *)setupPwdView telPhone:(NSString *)text;
- (void)setupPwdView:(SetupPwdView *)setupPwdView pwd:(NSString *)text;
- (void)setupPwdView:(SetupPwdView *)setupPwdView pwdConfirm:(NSString *)text;
- (void)setupPwdView:(SetupPwdView *)setupPwdView verCode:(NSString *)text;
@end

@interface SetupPwdView : UIView
@property (weak, nonatomic) IBOutlet UIButton *verCodeBtn;
@property (nonatomic, weak) id<SetupPwdViewDelegate> delegate;
- (void)addTarget:(id)target action:(SEL)action;
@end
