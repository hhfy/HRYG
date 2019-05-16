//
//  TravelsAlbumCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsAlbumCell.h"
#import "TravelsAlbumPhotosView.h"

@interface TravelsAlbumCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosViewH;
@property (weak, nonatomic) IBOutlet TravelsAlbumPhotosView *photosView;
@end

@implementation TravelsAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPhotosUrl:(NSArray *)photosUrl {
    _photosUrl = photosUrl;
    
    CGFloat margin = 10;
    CGFloat photoW = (MainScreenSize.width - margin * 3) * 0.5;
    CGFloat photoH = 110;
    NSInteger row = (photosUrl.count + 2 - 1) / 2;
    self.photosViewH.constant = photoH * row + (row - 1) * margin;
    self.photosView.photoW = photoW;
    self.photosView.photoH = photoH;
    self.photosView.offsetY = NavHeight;
    self.photosView.margin = margin;
    self.photosView.photos = photosUrl;
}


@end
