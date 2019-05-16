//
//  TravelsHotVenueHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/30.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsHotVenueHeaderView.h"
#import "Travels.h"

@interface TravelsHotVenueHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageCountBtn;
@property (weak, nonatomic) IBOutlet UILabel *visitorCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *strategyCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *travelsCountBtn;
@end

@implementation TravelsHotVenueHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    if (iPhoneX) {
        self.height += 24;
    }
    self.imageCountBtn.titleLabel.font = self.strategyCountBtn.titleLabel.font = self.travelsCountBtn.titleLabel.font = IconFont(16);
}

- (void)setStadium:(TravelStadium *)stadium {
    _stadium = stadium;
    self.titleTextLabel.text = stadium.stadium_name;
    [self.imageCountBtn setTitle:[NSString stringWithFormat:@"%zd张图片%@", stadium.stadium_image_number, RightArrowIconUnicode2] forState:UIControlStateNormal];
    self.visitorCountLabel.text = [NSString stringWithFormat:@"%zd人游玩过", stadium.stadium_people];
    [self.strategyCountBtn setTitle:[NSString stringWithFormat:@"%zd篇攻略%@", stadium.stadium_tips, RightArrowIconUnicode2] forState:UIControlStateNormal];
    [self.travelsCountBtn setTitle:[NSString stringWithFormat:@"%zd篇游记%@", stadium.stadium_notes, RightArrowIconUnicode2] forState:UIControlStateNormal];
}

- (IBAction)tipsTap {
    [LaiMethod runtimePushVcName:@"TravelsStrategyVC" dic:@{@"stadiumId" : self.stadium.supplier_stadium_id} nav:CurrentViewController.navigationController];
}

- (IBAction)notesTap {
    [LaiMethod runtimePushVcName:@"TravelsTravelsVC" dic:@{@"stadiumId" : self.stadium.supplier_stadium_id} nav:CurrentViewController.navigationController];
}

- (IBAction)photoCountBntTap {
    [LaiMethod runtimePushVcName:@"TravelsAlbumVC" dic:@{@"titleText" : [NSString stringWithFormat:@"%zd张图片", self.stadium.stadium_image_number], @"shopId" : self.stadium.shop_id} nav:CurrentViewController.navigationController];
}


@end
