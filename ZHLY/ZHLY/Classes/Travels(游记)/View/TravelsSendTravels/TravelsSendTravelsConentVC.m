//
//  TravelsSendTravelsConentVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsSendTravelsConentVC.h"

@interface TravelsSendTravelsConentVC ()
@property (nonatomic, copy) NSString *contentStr;
@end

@implementation TravelsSendTravelsConentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVlaue];
    [self setupNav];
}

- (void)setupVlaue {
    self.title = @"编辑内容";
    self.view.backgroundColor = [UIColor whiteColor];
    self.receiveEditorDidChangeEvents = NO;
    self.alwaysShowToolbar = YES;
    self.shouldShowKeyboard = NO;
    self.toolbarItemTintColor = MainThemeColor;
    [self setPlaceholder:@"写点什么吧，分享游玩中的精彩片段..."];
    [self setHTML:[SaveTool objectForKey:@"travelsContentStr"]];
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(commit) title:@"保存" nomalColor:MainThemeColor hightLightColor:SetupColor(180, 180, 180) titleFont:TextSystemFont(15) top:0 left:0 bottom:0 right:0];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) title:LeftArrowIconUnicode nomalColor:SetupColor(51, 51, 51) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:-25 bottom:0 right:0];
}

- (void)commit {
    [self.view endEditing:YES];
    [SVProgressHUD showMessage:nil];
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *content = [weakSelf getHTML];
        if (content.length <= 5) {
            [SVProgressHUD showError:@"最少五个字!"];
        } else {
            [SVProgressHUD dismiss];
            [SaveTool setObject:content forKey:@"travelsContentStr"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TravelsReturnValueNotification" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)back {
    [self.view endEditing:YES];
    WeakSelf(weakSelf)
    [LaiMethod alertControllerWithTitle:nil message:@"当前编辑内容尚未保存，确定退出?" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

@end
