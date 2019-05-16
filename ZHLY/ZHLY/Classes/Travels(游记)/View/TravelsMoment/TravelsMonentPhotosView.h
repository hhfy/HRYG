//
//  TravelsMonentPhotosView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelsMonentPhotosView : UIView
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat photoWH;
@end

@interface PhotoView : UIImageView
@property (nonatomic, copy) NSString *photo;
@end
