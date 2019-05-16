//
//  ServiceMyMsgCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceMyMsgCell.h"
#import "Service.h"
#import "Profile.h"

@interface ServiceMyMsgCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNamelabel;
@end

@implementation ServiceMyMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMyLeaveMsg:(ServiceMyLeaveMsg *)myLeaveMsg {
    _myLeaveMsg = myLeaveMsg;
    switch (myLeaveMsg.status) {
        case 1:
            self.contentLabel.text = @"";
            self.userNamelabel.text = @"尚未回复";
            break;
        case 2:
            self.contentLabel.text = myLeaveMsg.reply;
            self.userNamelabel.text = @"客服回复：";
            break;
        default:
            break;
    }
}

-(void)setMyFeedBackMsg:(ProfileMyFeedBackMsg *)myFeedBackMsg {
    _myFeedBackMsg = myFeedBackMsg;
    switch (myFeedBackMsg.sys_fd_status) {
        case 2:
            self.contentLabel.text = @"";
            self.userNamelabel.text = @"尚未回复";
            break;
        case 1:
            self.contentLabel.text = myFeedBackMsg.sys_fd_reply;
            self.userNamelabel.text = @"客服回复：";
            break;
        default:
            break;
    }
}


@end
