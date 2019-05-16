//
//  SVProgressHUD+LAI.m
//  GXBG
//
//  Created by LTWL on 2017/11/23.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "SVProgressHUD+LAI.h"

@implementation SVProgressHUD (LAI)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SVProgressHUD setMinimumSize:CGSizeMake(85, 85)];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setFont:TextSystemFont(13.5f)];
        [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"ProgressHUD.bundle/success.png"]];
        [SVProgressHUD setErrorImage:[UIImage imageNamed:@"ProgressHUD.bundle/error.png"]];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    });
}

+ (void)showSuccess:(NSString *)success {
    [SVProgressHUD showSuccessWithStatus:success];
    [SVProgressHUD dismissWithDelay:0.7];
}

+ (void)showError:(NSString *)error {
    [SVProgressHUD showErrorWithStatus:error];
    [SVProgressHUD dismissWithDelay:0.7];
}

+ (void)showMessage:(NSString *)message {
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showWithStatus:message];
}

+ (void)showProgress:(float)progress loaddingMsg:(NSString *)loaddingMsg doneMsg:(NSString *)doneMsg {
    [SVProgressHUD showProgress:progress status:loaddingMsg];
    if (progress >= 1.0f && doneMsg) [self showSuccess:doneMsg];
}

@end
