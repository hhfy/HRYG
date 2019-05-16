//
//  AppDelegate.m
//  ZHLY(智慧旅游)
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+RegisterRoute.h"
#import "TabBarViewController.h"
#import "LoginVC.h"
#import <JLRoutes.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    if ([SaveTool objectForKey:Token]) {
//        self.window.rootViewController = [TabBarViewController new];
//    } else {
//        self.window.rootViewController = [[NavigationController alloc] initWithRootViewController:[LoginVC new]];
//    }
    self.window.rootViewController = [TabBarViewController new];
    [self registerRouteWithScheme:@"FeiMa"];
    [self.window makeKeyAndVisible];
    [self WXPaySet];  //微信设置
    return YES;
}

#pragma mark ----- WXPaySet -----
- (void)WXPaySet {
    _payType = PayTypeNone;
    [WXApi registerApp:WXPayKey];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    switch (_payType) {
        case PayTypeNone:
            break;
        case PayTypeWXServiceFee:{
            [WXApi handleOpenURL:url delegate:self];
        }break;
        case PayTypeWXShopping:{
            [WXApi handleOpenURL:url delegate:self];
        }break;
        case PayTypeZFBServiceFee:{
            //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
            if ([url.host isEqualToString:@"safepay"]) {
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    [self handleZFBwithInfo:resultDic];
                }];
            }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
                [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                    [self handleZFBwithInfo:resultDic];
                }];
            }
        }break;
        case PayTypeZFBShopping:{
            //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
            if ([url.host isEqualToString:@"safepay"]) {
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    [self handleZFBwithInfo:resultDic];
                }];
                [[AlipaySDK defaultService] processAuth_V2Result:url
                                                 standbyCallback:^(NSDictionary *resultDic) {
                                                     NSLog(@"result = %@",resultDic);
                                                     NSString *resultStr = resultDic[@"result"];
                                                     NSLog(@"result = %@",resultStr);
                                                     [self handleZFBwithInfo:resultDic];
                                                 }];
            }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
                [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                    [self handleZFBwithInfo:resultDic];
                }];
            }
        }break;
        default:
            break;
    }
//    return YES;
    return [[JLRoutes routesForScheme:@"FeiMa"] routeURL:url];
}

#pragma mark - 支付宝回调
-(void)handleZFBwithInfo:(NSDictionary *)resultDic {
    if([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        [self zhifuSuccess];
    }
    else {
        [self showPayError];
    }
}
#pragma mark - 微信支付回调
//-(void)onResp:(BaseResp*)resp {
//    //    NSLog(@"%d,,,%@",resp.errCode,resp.errStr);
//    if (resp.errCode != 0) {
//        NSString *wxTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixin"];
//        if ([wxTitle isEqualToString:@"WXPAY"]) {
//            [self showPayError];
//        }
//    }else{
//        [self zhifuSuccess];
//    }
//}
//付款失败
-(void)showPayError {
    [SVProgressHUD showError:@"addChildVC付款失败"];
}
//付款成功
- (void)zhifuSuccess {
    [SVProgressHUD showSuccess:@"付款成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFSuccessNotification" object:self];
    });
}
+ (AppDelegate *)app {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
