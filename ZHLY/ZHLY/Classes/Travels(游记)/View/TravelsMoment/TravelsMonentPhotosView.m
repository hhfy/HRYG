
//
//  TravelsMonentPhotosView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsMonentPhotosView.h"

#define PhotoMargin 5
#define PhotoMaxCol(count) ((count == 4) ? 2 : 3)

@interface TravelsMonentPhotosView () <HZPhotoBrowserDelegate>
@end

@implementation TravelsMonentPhotosView

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    
    NSUInteger photoCount = photos.count;
    while (self.subviews.count < photoCount) {
        PhotoView *photoView = [[PhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    for (int i = 0; i < self.subviews.count; i++) {
        PhotoView *photoView = self.subviews[i];
        photoView.tag = i;
        if (i < photoCount) {
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else {
            photoView.hidden = YES;
        }
        // 添加点点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [photoView addGestureRecognizer:tap];
    }
    
    // 九宫格计算方法
    NSInteger photsCount = self.photos.count;
    for (int i = 0; i < photsCount; i++) {
        UIImageView *photoView = self.subviews[i];
        
        NSInteger col = i % PhotoMaxCol(photsCount);
        NSInteger row = i / PhotoMaxCol(photsCount);
        
        photoView.x = col * (self.photoWH + PhotoMargin);
        photoView.y = row * (self.photoWH + PhotoMargin);
        photoView.width = self.photoWH;
        photoView.height = self.photoWH;
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [LaiMethod setupPhotoBrowserWithImageCount:self.photos.count offsetY:self.offsetY currentImageIndex:tap.view.tag sourceImagesContainerView:self indexShowType:PhotoIndexTypePageControl delegate:self];
}

//临时占位图（thumbnail图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    PhotoView *photoView = [PhotoView new];
    photoView.photo = self.photos[index];
    return photoView.image;
}
//高清原图 （bmiddle图）
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return SetURL(self.photos[index]);
}
@end

@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = NO;
        self.backgroundColor = SetupColor(236, 234, 230);
    }
    return self;
}

- (void)setPhoto:(NSString *)photo {
    _photo = [photo copy];
    WeakSelf(weakSelf)
    [self sd_setImageWithURL:SetURL(SmallImage(photo)) placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.userInteractionEnabled = (image != nil);
    }];
}

@end
