
//
//  TravelsAlbumPhotosView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsAlbumPhotosView.h"

@implementation TravelsAlbumPhotosView 

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    
    NSUInteger photoCount = photos.count;
    while (self.subviews.count < photoCount) {
        TravelsAlbumPhotoView *photoView = [[TravelsAlbumPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    for (int i = 0; i < self.subviews.count; i++) {
        TravelsAlbumPhotoView *photoView = self.subviews[i];
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
    for (int i = 0; i < photoCount; i++) {
        UIImageView *photoView = self.subviews[i];
        
        NSInteger col = i % 2;
        NSInteger row = i / 2;
        
        photoView.x = col * (self.photoW + self.margin);
        photoView.y = row * (self.photoH + self.margin);
        photoView.width = self.photoW;
        photoView.height = self.photoH;
        Log(@"%@", photoView);
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [LaiMethod setupPhotoBrowserWithImageCount:self.photos.count offsetY:self.offsetY currentImageIndex:tap.view.tag sourceImagesContainerView:self indexShowType:PhotoIndexTypeIndexLabel delegate:self];
}

//临时占位图（thumbnail图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    TravelsAlbumPhotoView *photoView = [TravelsAlbumPhotoView new];
    photoView.photo = self.photos[index];
    return photoView.image;
}
//高清原图 （bmiddle图）
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return SetURL(self.photos[index]);
}

@end


@interface TravelsAlbumPhotoView ()
@property (nonatomic, strong) UIActivityIndicatorView *loaddingView;
@end

@implementation TravelsAlbumPhotoView

- (UIActivityIndicatorView *)loaddingView
{
    if (_loaddingView == nil)
    {
        _loaddingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_loaddingView setHidesWhenStopped:YES];
        [self addSubview:_loaddingView];
    }
    return _loaddingView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
    self.backgroundColor = SetupColor(236, 234, 230);
}

- (void)setPhoto:(NSString *)photo {
    _photo = [photo copy];
    WeakSelf(weakSelf)
    [self.loaddingView startAnimating];
    self.userInteractionEnabled = NO;
    [self sd_setImageWithURL:SetURL(SmallImage(photo)) placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.userInteractionEnabled = YES;
        [weakSelf.loaddingView stopAnimating];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.loaddingView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

@end
