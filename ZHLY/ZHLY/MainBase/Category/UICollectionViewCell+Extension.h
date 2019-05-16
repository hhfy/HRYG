//
//  UICollectionViewCell+Extension.h
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (Extension)
+ (instancetype)cellFromXibWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
