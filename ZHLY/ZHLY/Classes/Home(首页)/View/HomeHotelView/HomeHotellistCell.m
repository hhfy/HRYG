//
//  HomeHotellistCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/21.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHotellistCell.h"
#import "Home.h"

@interface HomeHotellistCell()
@property (weak, nonatomic) IBOutlet UIImageView *homeImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@end

@implementation HomeHotellistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setHotelInfo:(HomeHotelInfo *)hotelInfo {
    _hotelInfo = hotelInfo;
    [self.loadingView startAnimating];
    WeakSelf(weakSelf)
    [self.homeImgView sd_setImageWithURL:SetURL(hotelInfo.hotel_image) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loadingView stopAnimating];
    }];
    self.nameLabel.text = hotelInfo.hotel_name;
    self.infoLabel.font = IconFont(12);
    self.infoLabel.text = [NSString stringWithFormat:@"\U0000e739 %@",hotelInfo.hotel_address];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"hotelId"] = self.hotelInfo.hotel_id;
        [LaiMethod runtimePushVcName:@"HomeHotelVC" dic:params nav:CurrentViewController.navigationController];
    }
}

@end
