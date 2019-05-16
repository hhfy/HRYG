
//
//  Service.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "Service.h"

@implementation ServiceCommonQuestion
IdTransfrom
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"question" : [ServiceCommonQuestionDetial class]};
}
@end

@implementation ServiceCommonQuestionDetial
IdTransfrom
@end

@implementation ServicePhone
IdTransfrom
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"phone_data" : [ServicePhoneDetial class]};
}
@end

@implementation ServicePhoneDetial
IdTransfrom
@end

@implementation ServiceLeaveMsgType

@end

@implementation ServiceMyLeaveMsg
IdTransfrom
@end


