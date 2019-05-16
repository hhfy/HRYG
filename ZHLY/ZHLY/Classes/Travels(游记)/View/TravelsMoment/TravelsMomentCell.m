
//
//  TravelsMomentCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsMomentCell.h"
#import "Travels.h"
#import "TravelsMonentPhotosView.h"

@interface TravelsMomentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarVIew;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet TravelsMonentPhotosView *photosView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phototsViewH;
@end

@implementation TravelsMomentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.avatarVIew.layer.cornerRadius = self.avatarVIew.height * 0.5;
    self.avatarVIew.layer.borderColor = SetupColor(227, 227, 227).CGColor;
    self.avatarVIew.layer.borderWidth = 0.8;
}

- (void)setMoment:(TravelMoment *)moment {
    _moment = moment;
    [self.avatarVIew sd_setImageWithURL:SetURL(moment.member_profile_image) placeholderImage:SetImage(@"avatar_default")];
    self.userNameLabel.text = (![moment.member_nickname isEqualToString:@""]) ? moment.member_nickname : @"匿名用户";
    self.dateLabel.text = moment.create_time;
//    self.dateLabel.text = [NSString currentDateBetweenWithTargetDateTimestamp:moment.create_time];
    self.contentLabel.text = moment.text;
    
    CGFloat margin = 5;
    CGFloat itemWH = (MainScreenSize.width - margin * 2 - 40) / 3;
    if (moment.images.count) {
        NSInteger count = moment.images.count;
        NSInteger col = (count + 3 - 1) / 3;
        self.phototsViewH.constant = col * itemWH + (col - 1) * 5;
    } else {
        self.phototsViewH.constant = 0;
    }
    self.photosView.photoWH = itemWH;
    self.photosView.offsetY = NavHeight;
    self.photosView.photos = moment.images;
}



@end
