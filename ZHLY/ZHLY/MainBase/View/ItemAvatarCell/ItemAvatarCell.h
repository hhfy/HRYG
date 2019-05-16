//
//  ItemAvatarCell.h
//  ZHDJ
//
//  Created by LTWL on 2017/8/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 传递当前从相册亦是从相机拍摄的图片
typedef void(^ItemAvatarIconDidSelectedBlock)(UIImage *photoImg);

@interface ItemAvatarCell : UITableViewCell
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat lineLeftW;
@property (nonatomic, assign) CGFloat lineRightW;
@property (nonatomic, copy) ItemAvatarIconDidSelectedBlock didSelected;
@end
