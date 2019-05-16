

//
//  TravelsHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/30.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsHeaderView.h"
#import "TravelsItemCell.h"
#import "Travels.h"

@interface TravelsHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (nonatomic, strong) SDCycleScrollView *sDCycleScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemColloectViewH;
@property (nonatomic, assign) CGFloat itemWH;
@end

@implementation TravelsHeaderView

- (SDCycleScrollView *)sDCycleScrollView
{
    if (_sDCycleScrollView == nil)
    {
        _sDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenSize.width, self.bannerView.height) delegate:nil placeholderImage:SetImage(BannerPlaceHolder)];
        _sDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sDCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _sDCycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _sDCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _sDCycleScrollView.pageControlBottomOffset = 0;
    }
    return _sDCycleScrollView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    [self.bannerView addSubview:self.sDCycleScrollView];
    [self setupItemCollectionView];
}

- (void)setAdUrls:(NSArray *)adUrls {
    _adUrls = adUrls;
    NSMutableArray *arr = [NSMutableArray array];
    for (TravelTrafficAd *ad in adUrls) {
        [arr addObject:ad.path];
    }
    if (arr.count>0) {
        self.sDCycleScrollView.imageURLStringsGroup = arr;
    }
    else {
        NSArray *arr = [NSArray arrayWithObject:[UIImage imageNamed:@"homeTopImgView.png"]];
        self.sDCycleScrollView.localizationImageNamesGroup = arr;
    }
}

#define ColMaxCount 4

- (void)setupItemCollectionView {
    self.itemWH = MainScreenSize.width / ColMaxCount;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.itemWH, self.itemWH);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    [self.itemCollectionView setCollectionViewLayout:layout];
    self.itemCollectionView.backgroundColor = [UIColor whiteColor];
    self.itemCollectionView.scrollEnabled = NO;
    self.itemCollectionView.dataSource = self;
    self.itemCollectionView.delegate = self;
    
    
    NSInteger rows = (4 + ColMaxCount - 1) / ColMaxCount;
    self.itemColloectViewH.constant = rows * self.itemWH;
    [self.itemCollectionView reloadData];
}


#pragma mark - CollectionView数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TravelsItemCell *cell = [TravelsItemCell cellFromXibWithCollectionView:collectionView indexPath:indexPath];
    switch (indexPath.item) {
        case 0:
            cell.text = @"游览攻略";
            cell.icon = @"游览攻略";
            break;
        case 1:
            cell.text = @"交通指南";
            cell.icon = @"交通指南";
            break;
        case 2:
            cell.text = @"旅游游记";
            cell.icon = @"旅游游记";
            break;
        case 3:
            cell.text = @"精彩动态";
            cell.icon = @"精彩分享";
            break;
        default:
            break;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 0.9) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            switch (indexPath.item) {
                case 0:
                {
                    [LaiMethod runtimePushVcName:@"TravelsStrategyVC" dic:nil nav:CurrentViewController.navigationController];
                }
                    break;
                case 1:
                {
                    [LaiMethod runtimePushVcName:@"TravelsTrafficGuideVC" dic:nil nav:CurrentViewController.navigationController];
                }
                    break;
                case 2:
                {
        
                    [LaiMethod runtimePushVcName:@"TravelsTravelsVC" dic:nil nav:CurrentViewController.navigationController];
                }
                    break;
                case 3:
                {
                    [LaiMethod runtimePushVcName:@"TravelsMonentVC" dic:nil nav:CurrentViewController.navigationController];
                }
                    break;
                default:
                    break;
            }
    });

}


@end
