//
//  TravelsHotCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsHotCell.h"
#import "TravelsHotItemCell.h"
#import "Travels.h"

@interface TravelsHotCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@end

@implementation TravelsHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

static NSString * const ID = @"TravelsHotItemCell";

- (void)setupUI {
    CGFloat itemWH = self.itemCollectionView.height;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWH - 20, itemWH);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    [self.itemCollectionView setCollectionViewLayout:layout];
    self.itemCollectionView.backgroundColor = [UIColor whiteColor];
    self.itemCollectionView.scrollEnabled = YES;
    self.itemCollectionView.dataSource = self;
    self.itemCollectionView.delegate = self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleNameLabel.text = title;
}

- (void)setStadiums:(NSArray<TravelStadium *> *)stadiums {
    _stadiums = stadiums;
    [self.itemCollectionView reloadData];
}

#pragma mark - CollectionView数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stadiums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TravelsHotItemCell *cell = [TravelsHotItemCell cellFromXibWithCollectionView:collectionView indexPath:indexPath];
    TravelStadium *stadium = self.stadiums[indexPath.item];
    cell.stadium = stadium;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TravelStadium *stadium = self.stadiums[indexPath.item];
    [LaiMethod runtimePushVcName:@"TravelsHotVenueListVC" dic:@{@"stadiumId" : stadium.supplier_stadium_id, @"titleText" : stadium.stadium_name,@"key":stadium.supplier_scene_id} nav:CurrentViewController.navigationController];
}

@end
