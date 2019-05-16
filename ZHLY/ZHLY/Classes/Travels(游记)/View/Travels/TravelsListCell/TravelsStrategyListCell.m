//
//  TravelsStrategyListCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsStrategyListCell.h"
#import "Travels.h"

@interface TravelsStrategyListCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end

@implementation TravelsStrategyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.typeLabel.layer.cornerRadius = 2;
    self.typeLabel.layer.borderColor = self.typeLabel.textColor.CGColor;
    self.typeLabel.layer.borderWidth = 0.5;
}

- (void)setNoteTip:(TravelNoteTip *)noteTip {
    _noteTip = noteTip;
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    [self.iconImageView sd_setImageWithURL:SetURL(ScreenWidthImage(noteTip.image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    self.titleTextLabel.text = noteTip.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"titleText"] = @"攻略详情";
    params[@"apiUrl"] = [MainURL stringByAppendingPathComponent:@"tips/detail"];
    params[@"Id"] = self.noteTip.travel_notes_id;
    [LaiMethod runtimePushVcName:@"TravelsDetailWebVC" dic:params nav:CurrentViewController.navigationController];
}

@end
