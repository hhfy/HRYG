//
//  UserInfoTool.h
//  ZHDJ
//
//  Created by LTWL on 2017/8/21.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@class UserInfo;
@interface UserInfoTool : NSObject
// 存储账号信息
+ (void)saveUserInfo:(UserInfo *)userInfo;
// 从模型中获取账号信息
+ (UserInfo *)userInfo;
@end
