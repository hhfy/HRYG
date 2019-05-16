//
//  HomeExhibitionHallChoiceCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeExhibitionHallChoiceCell.h"
#import "HomeExhibitionHallDateCell.h"

@interface HomeExhibitionHallChoiceCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *dateIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *loacIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation HomeExhibitionHallChoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.dateIconLabel.font = self.loacIconLabel.font = self.arrowIconLabel.font = IconFont(18);
    self.dateIconLabel.text = TimeIconUnicode2;
    self.loacIconLabel.text = LocationIconUnicode;
    self.arrowIconLabel.text = RightArrowIconUnicode;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(75, 50);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = YES;
}

#pragma mark - collectionView数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeExhibitionHallDateCell *cell = [HomeExhibitionHallDateCell cellFromXibWithCollectionView:collectionView indexPath:indexPath];
    return cell;
}

@end


