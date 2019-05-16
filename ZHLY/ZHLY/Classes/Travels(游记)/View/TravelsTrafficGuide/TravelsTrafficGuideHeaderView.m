
//
//  TravelsTrafficGuideHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsTrafficGuideHeaderView.h"
#import "Travels.h"

@interface TravelsTrafficGuideHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowBtnH;
@property (nonatomic, strong) SDCycleScrollView *sDCycleScrollView;
@end

@implementation TravelsTrafficGuideHeaderView

- (SDCycleScrollView *)sDCycleScrollView
{
    if (_sDCycleScrollView == nil)
    {
        _sDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, self.height) delegate:nil placeholderImage:SetImage(BannerPlaceHolder)];
        _sDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sDCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _sDCycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _sDCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        _sDCycleScrollView.titlesGroup = @[@"交通指南"];
    }
    return _sDCycleScrollView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    if (iPhoneX) {
        self.height += 24;
        self.arrowBtnH.constant += 24;
    }
    [self insertSubview:self.sDCycleScrollView atIndex:0];
}

- (void)setAdUrls:(NSArray *)adUrls {
    _adUrls = adUrls;
    NSMutableArray *arr = [NSMutableArray array];
    for (TravelTrafficAd *ad in adUrls) {
        [arr addObject:ad.path];
    }
    self.sDCycleScrollView.imageURLStringsGroup = arr;
}

- (IBAction)arrowBtnTap {
    [CurrentViewController.navigationController popViewControllerAnimated:YES];
}


@end
