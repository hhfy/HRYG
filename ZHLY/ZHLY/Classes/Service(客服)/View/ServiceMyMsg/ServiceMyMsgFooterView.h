//
//  ServiceMyMsgFooterView.h
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceMyLeaveMsg,ProfileMyFeedBackMsg;
@interface ServiceMyMsgFooterView : UITableViewHeaderFooterView
@property (nonatomic, strong) ServiceMyLeaveMsg *myLeaveMsg;
@property (nonatomic, strong) ProfileMyFeedBackMsg *myFeedBackMsg;
@end
