//
//  UserInfo.m
//
//  Created by LTWL on 2017/7/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+ (instancetype)userInfoWithDict:(NSDictionary *)dict {
    UserInfo *userInfo = [[self alloc] init];
    userInfo.ID = dict[@"id"];
    userInfo.head = dict[@"head"];
    userInfo.sex = [dict[@"sex"] integerValue];
    userInfo.birth = dict[@"birth"];
    userInfo.is_member = [dict[@"is_member"] integerValue];
    userInfo.nickname = dict[@"nickname"];
    userInfo.add_time = dict[@"add_time"];
    userInfo.name = dict[@"name"];
    return userInfo;
}

MJCodingImplementation
@end
