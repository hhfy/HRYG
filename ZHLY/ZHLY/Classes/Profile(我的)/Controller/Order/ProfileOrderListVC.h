//
//  ProfileOrderListVC.h
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/2.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    OrderTypeUnpaid,
    OrderTypeUnconsumed,
    OrderTypeCompleted,
    OrderTypeRefunded
} OrderStatusType;

@interface ProfileOrderListVC : BaseViewController
@property (nonatomic, copy) NSString *titleString;
//不用
//@property (nonatomic, assign, readonly) OrderStatusType orderStatusType;

@property (nonatomic, assign) BOOL fromAllOrder;

@property (nonatomic, assign) NSInteger indexType;//0.未付款 1.未使用 2.已完成 3.退款单

@end
