//
//  registerVC.m
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "RegisterVC.h"
#import "RegisterView.h"
#import "UserInfo.h"

#define Time 60

@interface RegisterVC () <RegisterViewDelegate>
@property (nonatomic, weak) RegisterView *registerView;
@property (nonatomic, copy) NSString *telPhone;
@property (nonatomic, copy) NSString *verificatCode;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *pwdConfirm;
@property (nonatomic, copy) NSString *currentVerCode;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation RegisterVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupRegisterView];
    [self setupNextStepView];
}

- (void)setupValue {
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentTime = Time;
//#ifdef TFDJ
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"认证" style:UIBarButtonItemStylePlain target:self action:@selector(authenticationAction)];
//#endif
}

- (void)setupRegisterView {
    RegisterView *registerView = [RegisterView viewFromXib];
    [registerView addTarget:self action:@selector(verificatCodeBtnClick)];
    registerView.delegate = self;
    [self.view addSubview:registerView];
    _registerView = registerView;
}

- (void)setupNextStepView {
    NormalBottomView *bottomView = [NormalBottomView viewFromXib];
    bottomView.y = self.registerView.maxY + 30;
    bottomView.title = @"确定";
    [bottomView addTarget:self action:@selector(nextStepBtnClick)];
    [self.view addSubview:bottomView];
}

#pragma mark - RegisterViewDelegate
- (void)registerView:(RegisterView *)RegisterView telTextDidTextChange:(NSString *)text {
    self.telPhone = text;
}

- (void)registerView:(RegisterView *)RegisterView verificationCodeDidTextChange:(NSString *)text {
    self.verificatCode = text;
}

- (void)registerView:(RegisterView *)RegisterView pwdTextDidTextChange:(NSString *)text {
    self.pwd = text;
}

- (void)registerView:(RegisterView *)RegisterView pwdConfirmTextDidTextChange:(NSString *)text {
    self.pwdConfirm = text;
}

#pragma mark - 下一步
- (void)nextStepBtnClick {
     [self.view endEditing:YES];
    if (self.telPhone.length == 0) {
        [SVProgressHUD showError:@"请填写手机号"];
        return;
    } else if (![VerificationTool validateTelNumber:self.telPhone]) {
        [SVProgressHUD showError:@"请填正确的手机号"];
        return;
    } else if (self.pwd.length == 0) {
        [SVProgressHUD showError:@"请填写密码"];
        return;
    } else if (self.pwd.length<6 || self.pwd.length>18) {//![VerificationTool validatePwd:self.pwd]
        [SVProgressHUD showError:@"必须是6-18位字母数字组合"];
        return;
    } else if (self.pwdConfirm.length == 0) {
        [SVProgressHUD showError:@"请填确认密码"];
        return;
    } else if (![self.pwdConfirm isEqualToString:self.pwd]) {
        [SVProgressHUD showError:@"两次输入的密码不一致"];
        return;
    } else if (self.verificatCode.length == 0) {
        [SVProgressHUD showError:@"请填写验证码"];
        return;
    } else if (![VerificationTool validateVerificationCode:self.verificatCode]) {
        [SVProgressHUD showError:@"请填写正确的验证码"];
        return;
    } else if (![self.currentVerCode isEqualToString:self.verificatCode]) {
        [SVProgressHUD showError:@"验证码不正确"];
        return;
    }
    
    [self postRegistInfo];
}

#pragma mark - 注册接口
- (void)postRegistInfo {
    NSString *url = [MainURL stringByAppendingPathComponent:@"main/register"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"member_phone"] = self.telPhone;
    params[@"member_passwd"] = self.pwd;
    params[@"code"] = self.verificatCode;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"注册成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } otherCase:^(NSInteger code) {
        
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 验证码
- (void)verificatCodeBtnClick {
    if (self.telPhone.length == 0) {
        [SVProgressHUD showError:@"请填写手机号"];
        return;
    }
    [self getVerificatCodeWithMobile:self.telPhone];
}

#pragma mark - 获取验证码 （此接口未更新）
- (void)getVerificatCodeWithMobile:(NSString *)mobile {
    NSString *url = [MainURL stringByAppendingPathComponent:@"main/get_register_code"];
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
        [weakSelf.registerView.verificationCodeBtn setTitle:[NSString stringWithFormat:@"%.0fs重发", weakSelf.currentTime] forState:UIControlStateNormal];
        weakSelf.registerView.verificationCodeBtn.enabled = NO;
        weakSelf.registerView.verificationCodeBtn.backgroundColor = SetupColor(179, 179, 179);
        Log(@"%f", weakSelf.currentTime);
        if (weakSelf.currentTime == 0) {
            weakSelf.currentTime = Time;
            [weakSelf.registerView.verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            weakSelf.registerView.verificationCodeBtn.enabled = YES;
            weakSelf.registerView.verificationCodeBtn.backgroundColor = MainThemeColor;
            [timer invalidate];
        }
    }];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    _timer = timer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
