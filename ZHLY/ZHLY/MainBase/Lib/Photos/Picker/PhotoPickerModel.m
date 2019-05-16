//
//  AlbumModel.m
//  ImagePickerController
//
//  Created by LTWL on 2017/5/23.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "PhotoPickerModel.h"

@implementation PhotoPickerModel

+ (instancetype)modelWithAsset:(id)asset type:(AlbumModelMediaType)type{
    PhotoPickerModel *model = [[PhotoPickerModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset type:(AlbumModelMediaType)type timeLength:(NSString *)timeLength {
    PhotoPickerModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

@end
