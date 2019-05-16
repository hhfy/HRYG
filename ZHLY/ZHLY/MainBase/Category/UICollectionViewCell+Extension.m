
//
//  UICollectionViewCell+Extension.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "UICollectionViewCell+Extension.h"

@implementation UICollectionViewCell (Extension)

+ (instancetype)cellFromXibWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString *ID = NSStringFromClass(self);
    UINib *xib = [UINib nibWithNibName:ID bundle:nil];
    [collectionView registerNib:xib forCellWithReuseIdentifier:ID];
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString *ID = NSStringFromClass(self);
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:ID];
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    }
    return cell;
}

@end
