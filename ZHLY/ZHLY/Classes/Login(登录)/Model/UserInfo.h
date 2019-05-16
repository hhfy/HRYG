//
//  UserInfo.h
//
//  Created by LTWL on 2017/7/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString *birth;
@property (nonatomic, assign) NSInteger is_member;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *name;
+ (instancetype)userInfoWithDict:(NSDictionary *)dict;
@end
