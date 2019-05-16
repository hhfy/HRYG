//
//  HomeMuseumScorePhotosView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeShopBaseScorePhotosView : UIView <HZPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat photoWH;
@end


@interface HomeMuseumScorePhotoView : UIImageView
@property (nonatomic, copy) NSString *photo;
@end
