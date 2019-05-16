//
//  RoomOrderFooterView.m
//  YWY2
//
//  Created by LTWL on 2017/5/4.
//  Copyright © 2017年 XMB. All rights reserved.
//

#import "RoomOrderFooterView.h"

@interface RoomOrderFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeContentLabel;

@end

@implementation RoomOrderFooterView

+ (instancetype)show {
    return [[[NSBundle mainBundle] loadNibNamed:@"RoomOrderFooterView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.noticeTitleLabel.textColor = self.noticeContentLabel.textColor = SetupColor(153, 153, 153);
    self.noticeTitleLabel.text = @"酒店入住须知";
    NSString *contentText = @"1.为了您能顺利出行，请准确填写真实、有效的证件号码和用于接收保单信息的手机号码，所填姓名需与所持证件一致，订单提交后将无法修改。超过85周岁，不承保。";
    self.noticeContentLabel.text = contentText;
    self.height = [contentText boundingRectWithSize:CGSizeMake(MainScreenSize.width - 25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.noticeContentLabel.font} context:nil].size.height + 60;
}



@end
