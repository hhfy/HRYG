//
//  PhotoPreviewCell.h
//  ImagePickerController
//
//  Created by LTWL on 2017/5/23.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoPickerModel;

@interface PhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) PhotoPickerModel *model;

@property (nonatomic, copy) void (^singleTapGestureBlock)();

@property (nonatomic, copy) void (^doubleTapGestureBlock)();

@end
