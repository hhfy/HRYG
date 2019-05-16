//
//  UserInfoTool.m
//  ZHDJ
//
//  Created by LTWL on 2017/8/21.
//  Copyright © 2017年 LTWL. All rights reserved.
//


#import "UserInfoTool.h"

// 沙盒路径document文件夹
#define DocumentSaveOfAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.archive"]

@implementation UserInfoTool
+ (void)saveUserInfo:(UserInfo *)userInfo {
    [NSKeyedArchiver archiveRootObject:userInfo toFile:DocumentSaveOfAccountPath];
}
// 从模型中获取账号信息
+ (UserInfo *)userInfo {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:DocumentSaveOfAccountPath];
}
@end
