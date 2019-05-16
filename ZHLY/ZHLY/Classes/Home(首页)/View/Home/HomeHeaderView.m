//
//  HomeHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHeaderView.h"
#import "Home.h"

@interface HomeHeaderView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *sDCycleScrollView;
@end

@implementation HomeHeaderView

- (SDCycleScrollView *)sDCycleScrollView
{
    if (_sDCycleScrollView == nil)
    {
        _sDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenSize.width, self.height) delegate:self placeholderImage:SetImage(BannerPlaceHolder)];
        _sDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sDCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _sDCycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _sDCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _sDCycleScrollView.pageControlBottomOffset = 0;
        _sDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        [self addSubview:_sDCycleScrollView];
    }
    return _sDCycleScrollView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    NSArray *arr = [NSArray arrayWithObject:[UIImage imageNamed:@"homeTopImgView.png"]];
    self.sDCycleScrollView.localizationImageNamesGroup = arr;
//    self.sDCycleScrollView.imageURLStringsGroup = @[@"homeTopImgView"];
//    self.sDCycleScrollView.imageURLStringsGroup = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513419426418&di=59ef674cb94f6ae56acebf7be0baaa08&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101110%2F2889686_124508761323_2.jpg", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513419426418&di=59ef674cb94f6ae56acebf7be0baaa08&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101110%2F2889686_124508761323_2.jpg", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513419426418&di=59ef674cb94f6ae56acebf7be0baaa08&imgtype=0&src=http%3A%2F%2Fpic11.nipic.com%2F20101110%2F2889686_124508761323_2.jpg"];
//    self.sDCycleScrollView.titlesGroup = @[@"海澜马术", @"海澜马术", @"海澜马术"];
}

-(void)setAd1:(NSArray *)ad1 {
    _ad1 = ad1;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<ad1.count; i++) {
        HomeAd *ad = (HomeAd*)ad1[i];
        [arr addObject:ad.path];
    }
    self.sDCycleScrollView.imageURLStringsGroup = arr;
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HomeAd *ad = (HomeAd*)self.ad1[index];
    NSString *url = ad.url;;
    if(url){
        [LaiMethod urlRoutePushWithUrl:url];
    }
}

@end
