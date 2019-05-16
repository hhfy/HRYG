
//
//  HomeItemCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeItemCell.h"
#import "HomeItemContentCell.h"
#import "Home.h"

@interface HomeItemCell () <UICollectionViewDelegate, UICollectionViewDataSource,UIApplicationDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *icons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@end

@implementation HomeItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    self.titles = @[@"博物馆", @"演出", @"酒店", @"购物",@"套票", @"游船",@"讲解",@"观光马车"];
    self.icons = nil;
}

- (void)setupUI {
    if (iPhone5 || iPhoneSE) {
        self.collectionHeight.constant = MainScreenSize.width/4*2+10;
    }
    else {
       self.collectionHeight.constant = MainScreenSize.width/4*2;
    }
    
    CGFloat itemW = MainScreenSize.width * 0.25;
    CGFloat itemH = self.collectionView.height * 0.5;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;
}

#pragma mark - collectionView数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.homeModel ? self.homeModel.menu.count : 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeItemContentCell *cell = [HomeItemContentCell cellFromXibWithCollectionView:collectionView indexPath:indexPath];
    HomeMenu *menu = self.homeModel.menu[indexPath.row];
    cell.icon = self.homeModel ? menu.icon : self.titles[indexPath.item];
    cell.title = self.homeModel ? menu.name : self.titles[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 0.9) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HomeMenu *menu = self.homeModel.menu[indexPath.item];
        NSString *url = menu.url;
        if(url){
            if([menu.name isEqualToString:@"酒店"]){
                [LaiMethod urlRoutePushWithUrl:@"FeiMa://push/HomeHotelVC?key=55"];
            }
            else {
                [LaiMethod urlRoutePushWithUrl:url];
            }
            
        }
    });
}

-(void)setHomeModel:(HomeHomeModel *)homeModel {
    _homeModel = homeModel;
    if (iPhone5 || iPhoneSE) {
        self.collectionHeight.constant = MainScreenSize.width/4* ceilf(self.homeModel.menu.count/4.0)+15;
    }
    else {
        self.collectionHeight.constant = MainScreenSize.width/4*ceilf(self.homeModel.menu.count/4.0);
    }
    [self.collectionView reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(MainScreenSize.width/4,MainScreenSize.width/4);
}

@end
