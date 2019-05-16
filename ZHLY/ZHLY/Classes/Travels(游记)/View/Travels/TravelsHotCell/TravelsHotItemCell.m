
//
//  TravelsHotItemCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsHotItemCell.h"
#import "Travels.h"

@interface TravelsHotItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingVIew;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorCountLabel;
@end

@implementation TravelsHotItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setStadium:(TravelStadium *)stadium {
    _stadium = stadium;
    [self.loaddingVIew startAnimating];
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(SmallImage(stadium.stadium_image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingVIew stopAnimating];
    }];
    self.titleTextLabel.text = stadium.stadium_name;
    self.visitorCountLabel.text = [NSString stringWithFormat:@"%zd人游玩过", stadium.stadium_people];
}

@end
