//
//  TravelsAlbumPhotosView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelsAlbumPhotosView : UIView <HZPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat photoW;
@property (nonatomic, assign) CGFloat photoH;
@property (nonatomic, assign) CGFloat margin;
@end

@interface TravelsAlbumPhotoView : UIImageView
@property (nonatomic, copy) NSString *photo;
@end
