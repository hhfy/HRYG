//
//  PhotoPickerCell.h
//  ImagePickerController
//
//  Created by LTWL on 2017/5/23.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaType.h"

@class PhotoPickerModel;

@interface PhotoPickerCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;

@property (nonatomic, strong) PhotoPickerModel *model;

@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);

@property (nonatomic, assign) AlbumModelMediaType type;

@end

