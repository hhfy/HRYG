//
//  Profile.m
//  ZHLY
//
//  Created by LTWL on 2017/12/7.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "Profile.h"

@implementation ProfileFeedbackType

@end

@implementation ProfileInfo
IdTransfrom
@end

@implementation ProfileOrderTicketList

@end

@implementation ProfileOrderIndex
+ (NSDictionary *)objectClassInArray {
    return @{@"ticket_list" : [ProfileOrderTicketList class]};
}
@end

@implementation ProfileOrderModel
+ (NSDictionary *)objectClassInArray {
    return @{@"list" : [ProfileOrderIndex class]};
}
@end

@implementation ProfileOrderInfo

@end
@implementation ProfileOrderDetail
+ (NSDictionary *)objectClassInArray {
    return @{@"ticket_list" : [ProfileOrderTicketList class]};
}
@end

@implementation ProfileMyFeedBackMsg

@end

@implementation ImagesArray
@end
@implementation ProfileReviews
+ (NSDictionary *)objectClassInArray {
    return @{@"imagesArr" : [ImagesArray class]};
}
@end

@implementation ProfileCoupon
@end

