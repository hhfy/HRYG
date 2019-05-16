//
//  HomeNoticeCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/1.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "HomeNoticeCell.h"
#import "Home.h"

@interface HomeNoticeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HomeNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"apiUrl"] = [MainURL stringByAppendingPathComponent:@"notify/detail"];
        params[@"Id"] = self.notice.app_notify_id;
        params[@"titleText"] = @"公告详情";
        params[@"IdKey"] = @"app_notify_id";
        [LaiMethod runtimePushVcName:@"HomeDetialWebVC" dic:params nav:CurrentViewController.navigationController];
    }
}

-(void)setNotice:(HomeNotice *)notice {
    _notice = notice;
    self.titleLabel.text = notice.notify_title;
    self.timeLabel.text = notice.create_time;
}

@end
