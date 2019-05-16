//
//  ProfileOrderBaseVC.m
//  ZHLY
//  BasePageVC 有bug 暂时舍弃，用PubTopPageOfBtnView
//  Created by Moussirou Serge Alain on 2018/3/2.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileOrderBaseVC.h"
#import "ProfileOrderUnpaidVC.h"
#import "ProfileOrderUnconsumedVC.h"
#import "ProfileOrderCompletedVC.h"
#import "ProfileOrderRefundedVC.h"

@interface ProfileOrderBaseVC ()
//
@end

@implementation ProfileOrderBaseVC

- (void)addChildVC {
    ProfileOrderUnpaidVC *UnpaidVC = [[ProfileOrderUnpaidVC alloc] init];
    UnpaidVC.title = @"待支付";
    [self addChildViewController:UnpaidVC];
    
    ProfileOrderUnconsumedVC *UnconsumedVC = [[ProfileOrderUnconsumedVC alloc] init];
    UnconsumedVC.title = @"待使用";
    [self addChildViewController:UnconsumedVC];
    
    ProfileOrderCompletedVC *CompletedVC = [[ProfileOrderCompletedVC alloc] init];
    CompletedVC.title = @"已完成";
    [self addChildViewController:CompletedVC];
    
    ProfileOrderRefundedVC *RefundedVC = [[ProfileOrderRefundedVC alloc] init];
    RefundedVC.title = @"退款单";
    [self addChildViewController:RefundedVC];
    
}

- (TitleViewType)titleViewType {
    return TitleViewTypeNormal;
}


-(NSInteger)selectedIndex {
    return self.index;
}

@end
