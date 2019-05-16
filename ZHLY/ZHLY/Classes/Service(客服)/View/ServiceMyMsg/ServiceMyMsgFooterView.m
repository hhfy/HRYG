//
//  ServiceMyMsgFooterView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceMyMsgFooterView.h"
#import "Service.h"
#import "Profile.h"

@interface ServiceMyMsgFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation ServiceMyMsgFooterView

- (void)setMyLeaveMsg:(ServiceMyLeaveMsg *)myLeaveMsg {
    _myLeaveMsg = myLeaveMsg;
    self.typeLabel.text = [NSString stringWithFormat:@"问题类型：%@", myLeaveMsg.customer_consult_type_name];
    self.dateLabel.text = myLeaveMsg.create_time;//[NSString stringFromTimestampFromat:myLeaveMsg.create_time formatter:FmtYMDHM2];
}

-(void)setMyFeedBackMsg:(ProfileMyFeedBackMsg *)myFeedBackMsg {
    _myFeedBackMsg = myFeedBackMsg;
    self.typeLabel.text = [NSString stringWithFormat:@"问题类型：%@", myFeedBackMsg.sys_fd_type_title];
    self.dateLabel.text = myFeedBackMsg.create_time;
    
}

@end
