//
//  SetupPwdVC.m
//
//  Created by LTWL on 2017/6/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "SetupPwdVC.h"
#import "SetupPwdView.h"
#import "LoginVC.h"

#define Time 60

@interface SetupPwdVC () <SetupPwdViewDelegate>
@property (nonatomic, weak) SetupPwdView *setupPwdView;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *pwdConfirm;
@property (nonatomic, copy) NSString *verCode;
@property (nonatomic, copy) NSString *currentVerCode;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation SetupPwdVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupSetupPwdView];
    [self setupNextStepView];
}

- (void)setupValue {
    self.currentTime = Time;
    self.title = @"设置密码";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupSetupPwdView {
    SetupPwdView *setupPwdView = [SetupPwdView viewFromXib];
    setupPwdView.delegate = self;
    [setupPwdView addTarget:self action:@selector(verificatCodeBtnClick)];
    [self.view addSubview:setupPwdView];
    _setupPwdView = setupPwdView;
}

- (void)setupNextStepView {
    NormalBottomView *bottomView = [NormalBottomView viewFromXib];
    bottomView.y = self.setupPwdView.maxY + 40;
    bottomView.title = @"下一步";
    [bottomView addTarget:self action:@selector(nextStepBtnClick)];
    [self.view addSubview:bottomView];
}

#pragma mark - SetupView代理
- (void)setupPwdView:(SetupPwdView *)setupPwdView telPhone:(NSString *)text {
    self.mobile = text;
}

- (void)setupPwdView:(SetupPwdView *)setupPwdView pwd:(NSString *)text {
    self.pwd = text;
}

- (void)setupPwdView:(SetupPwdView *)setupPwdView pwdConfirm:(NSString *)text {
    self.pwdConfirm = text;
}

- (void)setupPwdView:(SetupPwdView *)setupPwdView verCode:(NSString *)text {
    self.verCode = text;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 验证码按钮

- (void)verificatCodeBtnClick {
    if (self.mobile.length == 0) {
        [SVProgressHUD showError:@"请输入手机号"];
        return;
    } else if (![VerificationTool validateTelNumber:self.mobile]) {
        [SVProgressHUD showError:@"手机格式不正确"];
        return;
    }
    [self getVerificatCodeWithMobile:self.mobile];
}

#pragma mark - 获取验证码
- (void)getVerificatCodeWithMobile:(NSString *)mobile {
    NSString *url = [MainURL stringByAppendingPathComponent:@"main/get_back_code"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = mobile;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:NO progress:nil success:^(id json) {
        [SVProgressHUD showSuccess:@"获取成功"];
        weakSelf.currentVerCode = [json[Data][Code] description];
        [weakSelf verificatCodeBtnState];
    } otherCase:nil failure:nil];
}


- (void)verificatCodeBtnState {
    WeakSelf(weakSelf)
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakSelf.currentTime -= 1;
        [weakSelf.setupPwdView.verCodeBtn setTitle:[NSString stringWithFormat:@"%.0fs重发", weakSelf.currentTime] forState:UIControlStateNormal];
        weakSelf.setupPwdView.verCodeBtn.enabled = NO;
        weakSelf.setupPwdView.verCodeBtn.backgroundColor = SetupColor(179, 179, 179);
        Log(@"%f", weakSelf.currentTime);
        if (weakSelf.currentTime == 0) {
            weakSelf.currentTime = Time;
            [weakSelf.setupPwdView.verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            weakSelf.setupPwdView.verCodeBtn.enabled = YES;
            weakSelf.setupPwdView.verCodeBtn.backgroundColor = MainThemeColor;
            [timer invalidate];
        }
    }];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    _timer = timer;
}

#pragma mark - 下一步
- (void)nextStepBtnClick {
    [self.view endEditing:YES];
    if (self.mobile.length == 0) {
        [SVProgressHUD showError:@"请填写手机号"];
        return;
    } else if (![VerificationTool validateTelNumber:self.mobile]) {
        [SVProgressHUD showError:@"手机号格式不正确"];
        return;
    } else if (self.pwd.length == 0) {
        [SVProgressHUD showError:@"请填写密码"];
        return;
    } else if (self.pwd.length<6 || self.pwd.length>18) {
        [SVProgressHUD showError:@"必须是6-18位字母数字组合"];
        return;
    } else if (self.pwdConfirm.length == 0) {
        [SVProgressHUD showError:@"请填确认密码"];
        return;
    } else if (![self.pwdConfirm isEqualToString:self.pwd]) {
        [SVProgressHUD showError:@"两次输入的密码不一致"];
        return;
    } else if (self.verCode.length == 0) {
        [SVProgressHUD showError:@"请填写验证码"];
        return;
    } else if (![VerificationTool validateVerificationCode:self.verCode]) {
        [SVProgressHUD showError:@"请填写正确的验证码"];
        return;
    } else if (![self.currentVerCode isEqualToString:self.verCode]) {
        [SVProgressHUD showError:@"验证码不正确"];
        return;
    }
    [self postRegistInfo];
}

- (void)postRegistInfo {
    NSString *url = [MainURL stringByAppendingPathComponent:@"main/retrieve_password"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"phone"] = self.mobile;
    params[@"code"] = self.verCode;
    params[@"password"] = self.pwd;
    params[@"confirm_password"] = self.pwdConfirm;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"修改成功"];
//        [weakSelf saveUserDataWithJson:json];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } otherCase:nil failure:nil];
}

- (void)saveUserDataWithJson:(id)json {
    [SaveTool setObject:json[Data][Token] forKey:Token];
    [SaveTool setObject:self.mobile forKey:UserName];
    [SaveTool setObject:@"" forKey:Pwd];
    [SaveTool setObject:json[Data][@"user_info"][@"id"] forKey:UserID];
}

@end
