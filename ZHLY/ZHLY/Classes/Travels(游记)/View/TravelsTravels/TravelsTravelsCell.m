
//
//  TravelsTravelsCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsTravelsCell.h"
#import "Travels.h"

@interface TravelsTravelsCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation TravelsTravelsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.avatarView.layer.cornerRadius = self.avatarView.height * 0.5;
}

- (void)setNoteTip:(TravelNoteTip *)noteTip {
    _noteTip = noteTip;
    [self.loaddingView startAnimating];
//    if (self.iconImageView.image) {
//        self.iconImageView.alpha = 0.f;
//        [UIView animateWithDuration:0.3 delay:0.08 options:0 animations:^{
//            self.iconImageView.alpha = 1.0;
//        } completion:nil];
//    }
    
    WeakSelf(weakSelf)
    [self.iconImageView sd_setImageWithURL:SetURL(SmallImage(noteTip.image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    self.titleTextLabel.text = noteTip.title;
    self.userNameLabel.text = (!noteTip.member_nickname || [noteTip.member_nickname isEqualToString:@""]) ? @"匿名用户" : noteTip.member_nickname;
    [self.avatarView sd_setImageWithURL:SetURL(noteTip.member_profile_image) placeholderImage:SetImage(@"avatar_default_small")];
    self.dateLabel.text = noteTip.create_time;
//    self.dateLabel.text = [NSString stringFromTimestampFromat:noteTip.create_time formatter:FmtYMD2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"titleText"] = @"游记详情";
    params[@"apiUrl"] = [MainURL stringByAppendingPathComponent:@"notes/detail"];
    params[@"Id"] = self.noteTip.travel_notes_id;
    [LaiMethod runtimePushVcName:@"TravelsDetailWebVC" dic:params nav:CurrentViewController.navigationController];
}

@end
