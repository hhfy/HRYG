//
//  UICollectionView+Extension.h
//  ZHDJ
//
//  Created by LTWL on 2017/9/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Extension)
@property (nonatomic, strong) UIView *loaddingView;
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign, readonly) BOOL firstReload;
@property (nonatomic, strong, readonly) UIView *superView;
@end
