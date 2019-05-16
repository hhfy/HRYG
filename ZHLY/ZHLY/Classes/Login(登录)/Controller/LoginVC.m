//
//  LoginVC.m
//
//  Created by LTWL on 2017/7/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"
#import "SetupPwdVC.h"
#import "RegisterVC.h"

@interface LoginVC () <LoginViewDelegate>
@property (nonatomic, weak) LoginView *loginView;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *pwd;
@end

@implementation LoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoginView];
    [self setupValue];
}

- (void)setupValue {
    self.userName = [SaveTool objectForKey:UserName];
    self.pwd = [SaveTool objectForKey:Pwd];
}

- (void)setupLoginView {
    LoginView *loginView = [LoginView viewFromXib];
    loginView.delegate = self;
    loginView.userName = [SaveTool objectForKey:UserName];
    loginView.pwd = [SaveTool objectForKey:Pwd];
    [loginView loginBtnaddTarget:self action:@selector(loginAction:)];
    [loginView registBtnaddTarget:self action:@selector(registAction)];
    [loginView setupPwdBtnaddTarget:self action:@selector(setupPwdAction)];
    [self.view addSubview:loginView];
    _loginView = loginView;
}

#pragma mark - 接口
- (void)postLoginRequset {
    NSString *url = [MainURL stringByAppendingPathComponent:@"main/login"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.userName;
    params[@"passwd"] = self.pwd;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        NSNumber *isLoginOut = [SaveTool objectForKey:IsLoginOut];
        if ([isLoginOut integerValue] == 1) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else {
            [LaiMethod loginAndLogoutAnmitonWithTargetVc:[TabBarViewController new] subtype:kCATransitionFromTop];
        }
        [weakSelf saveLoginDataWithJson:json];
    } otherCase:^(NSInteger code) {
        if (code == 500) weakSelf.loginView.shakeViewType = ShakeViewTypeLoginBtn;
    } failure:^(NSError *error) {
         weakSelf.loginView.shakeViewType = ShakeViewTypeLoginBtn;
    }];
}

#pragma mark - 保存数据
- (void)saveLoginDataWithJson:(id)json {
    [SaveTool setObject:self.userName forKey:UserName];
    [SaveTool setObject:self.pwd forKey:Pwd];
    [SaveTool setObject:json[Data][@"token"] forKey:Token];
}

#pragma mark - loginAction
- (void)loginAction:(UIButton *)button {
    [self recoveryPostion];
    [LaiMethod animationWithView:button];
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 0.9) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.userName.length == 0) {
            [SVProgressHUD showError:@"请输入手机号"];
            weakSelf.loginView.shakeViewType = ShakeViewTypeUserName;
            return;
        } else if (![VerificationTool validateTelNumber:weakSelf.userName]) {
            [SVProgressHUD showError:@"手机号格式错误"];
            weakSelf.loginView.shakeViewType = ShakeViewTypeUserName;
            return;
        } else if (weakSelf.pwd.length == 0) {
            [SVProgressHUD showError:@"请输入密码"];
            weakSelf.loginView.shakeViewType = ShakeViewTypePwd;
            return;
        }
        [self postLoginRequset];
    });
}

#pragma mark - registAction
- (void)registAction {
    RegisterVC *registerVc = [[RegisterVC alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

#pragma mark - setupPwdAction
- (void)setupPwdAction {
    SetupPwdVC *setupPwdVc = [[SetupPwdVC alloc] init];
    [self.navigationController pushViewController:setupPwdVc animated:YES];
}

#pragma mark - LoginViewDelegate
- (void)didClickInputTextFieldWithLoginView:(LoginView *)loginView {
    WeakSelf(weakSelf)
    [UIView animateWithDuration:KeyboradDuration animations:^{
        if (iPhone5) {
            weakSelf.loginView.y = -ItemCellHeight * 1.5;
        } else if (iPhone6) {
            weakSelf.loginView.y = -ItemCellHeight * 0.5;
        } 
    }];
}

- (void)didClickLoginView:(LoginView *)loginView {
    [self recoveryPostion];
}

- (void)loginView:(LoginView *)loginView userName:(NSString *)text {
    self.userName = text;
}

- (void)loginView:(LoginView *)loginView passWord:(NSString *)text {
    self.pwd = text;
}

- (void)keyboardDidClickReturn:(LoginView *)loginView {
    [self recoveryPostion];
}

- (void)recoveryPostion {
    [self.view endEditing:YES];
    WeakSelf(weakSelf)
    [UIView animateWithDuration:KeyboradDuration animations:^{
        weakSelf.loginView.y = 0;
    }];
}


@end
