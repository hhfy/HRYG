//
//  TravelsListCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsListCell.h"
#import "Travels.h"

@interface TravelsListCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end

@implementation TravelsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.typeLabel.layer.cornerRadius = 2;
    self.typeLabel.layer.borderColor = self.typeLabel.textColor.CGColor;
    self.typeLabel.layer.borderWidth = 0.5;
    self.avatarView.layer.cornerRadius = self.avatarView.height * 0.5;
    self.avatarView.layer.borderColor = SetupColor(227, 227, 227).CGColor;
    self.avatarView.layer.borderWidth = 0.5;
}

- (void)setNoteTip:(TravelNoteTip *)noteTip {
    _noteTip = noteTip;
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    [self.iconImageView sd_setImageWithURL:SetURL(SmallImage(noteTip.image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    self.titleTextLabel.text = noteTip.title;
    self.userNameLabel.text = (!noteTip.member_nickname || [noteTip.member_nickname isEqualToString:@""]) ? @"匿名用户" : noteTip.member_nickname;
    [self.avatarView sd_setImageWithURL:SetURL(noteTip.member_profile_image) placeholderImage:SetImage(@"avatar_default_small")];
    self.dateLabel.text = [NSString stringFromTimestampFromat:noteTip.create_time formatter:FmtYMD2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"titleText"] = @"攻略详情";
    params[@"apiUrl"] = [MainURL stringByAppendingPathComponent:@"notes/detail"];
    params[@"Id"] = self.noteTip.travel_notes_id;
    [LaiMethod runtimePushVcName:@"TravelsDetailWebVC" dic:params nav:CurrentViewController.navigationController];
}

@end
