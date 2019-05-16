//
//  Service.h
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 问答的标题栏
@interface ServiceCommonQuestion : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *question;
@property (nonatomic, copy) NSString *icon;
@end

/// 问答栏
@interface ServiceCommonQuestionDetial : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *type_id;
@end

/// 客服电话标题栏
@interface ServicePhone : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, strong) NSArray *phone_data;
@end

/// 客服电话
@interface ServicePhoneDetial : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *number;
@end

/// 留言类型
@interface ServiceLeaveMsgType : NSObject
@property (nonatomic, copy) NSString *customer_consult_type_id;
@property (nonatomic, copy) NSString *name;
@end

/// 我的留言
@interface ServiceMyLeaveMsg : NSObject
@property (nonatomic, copy) NSString *customer_consult_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger status;  // 1未回复  2回复
@property (nonatomic, copy) NSString *reply;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *customer_consult_type_name;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *reply_time;
@end
