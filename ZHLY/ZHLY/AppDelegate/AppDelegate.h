//
//  AppDelegate.h
//  ZHLY(智慧旅游)
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

//支付类型
typedef NS_ENUM(NSUInteger, PayType) {
    PayTypeWXServiceFee,
    PayTypeZFBServiceFee,
    PayTypeWXShopping,
    PayTypeZFBShopping,
    PayTypeNone,
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) PayType payType;
+(AppDelegate *)app;

@end

