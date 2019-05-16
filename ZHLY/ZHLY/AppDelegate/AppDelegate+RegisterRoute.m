//
//  AppDelegate+RegisterRoute.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "AppDelegate+RegisterRoute.h"
#import <JLRoutes.h>

@implementation AppDelegate (RegisterRoute)
/// 注册url路由
- (void)registerRouteWithScheme:(NSString *)scheme{
    [[JLRoutes routesForScheme:scheme] addRoute:@"/push/:controller"handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        [LaiMethod runtimePushVcName:parameters[@"controller"] dic:parameters nav:CurrentViewController.navigationController];
        return YES;
    }];
}
    
@end
