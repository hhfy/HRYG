//
//  HZPhotoBrowser.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPhotoBrowserView.h"

typedef enum : NSUInteger {
    PhotoIndexTypeIndexLabel,
    PhotoIndexTypePageControl,
    PhotoIndexTypePageCustom
} PhotoIndexType;

@class HZPhotoBrowser;
@protocol HZPhotoBrowserDelegate <NSObject>
@required
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
@end

@interface HZPhotoBrowser : UIViewController
@property (nonatomic, assign) PhotoIndexType indexType;
@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;//图片总数
@property (nonatomic, assign) CGFloat offsetY; // 纵向偏移量
@property (nonatomic, weak) id<HZPhotoBrowserDelegate> delegate;
@property (nonatomic, strong) UIImage *smallImage;

- (void)show;
@end
