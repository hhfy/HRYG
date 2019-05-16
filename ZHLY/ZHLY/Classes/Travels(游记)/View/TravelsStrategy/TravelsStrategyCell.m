

//
//  TravelsStrategyCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsStrategyCell.h"
#import "Travels.h"

@interface TravelsStrategyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TravelsStrategyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.iconView.layer.cornerRadius = 10;
    self.iconView.layer.borderWidth = 0.5;
    self.iconView.layer.borderColor = SetupColor(227, 227, 227).CGColor;
}

- (void)setNoteTip:(TravelNoteTip *)noteTip {
    _noteTip = noteTip;
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(ScreenWidthImage(noteTip.image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    self.titleTextLabel.text = noteTip.title;
    self.dateLabel.text = [NSString stringFromTimestampFromat:noteTip.create_time formatter:FmtYMD2];
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
