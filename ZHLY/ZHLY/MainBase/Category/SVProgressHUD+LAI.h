//
//  SVProgressHUD+LAI.h
//  GXBG
//
//  Created by LTWL on 2017/11/23.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <SVProgressHUD.h>

@interface SVProgressHUD (LAI)
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showMessage:(NSString *)message;
+ (void)showProgress:(float)progress loaddingMsg:(NSString *)loaddingMsg doneMsg:(NSString *)doneMsg;
@end
