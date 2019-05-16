//
//  ProfileHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "Profile.h"

@interface ProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@end

@implementation ProfileHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.avatarView.layer.cornerRadius = self.avatarView.height * 0.5;
    self.avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarView.layer.borderWidth = 1;
    self.settingBtn.titleLabel.font = IconFont(28);
    [self.settingBtn setTitle:SettingIconUnicode forState:UIControlStateNormal];
}

- (void)setProfileInfo:(ProfileInfo *)profileInfo {
    _profileInfo = profileInfo;
    [self.avatarView sd_setImageWithURL:SetURL(profileInfo.member_profile_image) placeholderImage:SetImage(@"avatar_default")];
    self.userNameLabel.text = profileInfo.member_nickname;
}

- (IBAction)settingBtnTap:(UIButton *)button {
    [LaiMethod animationWithView:button];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LaiMethod runtimePushVcName:@"ProfileSettingVC" dic:nil nav:CurrentViewController.navigationController];
    });
}

- (IBAction)profileIntoBtnTap {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"params"] = [NSDictionary createDictionayFromModelPropertiesWithObj:self.profileInfo];
    [LaiMethod runtimePushVcName:@"ProfileInfoVC" dic:params nav:CurrentViewController.navigationController];
}

@end
