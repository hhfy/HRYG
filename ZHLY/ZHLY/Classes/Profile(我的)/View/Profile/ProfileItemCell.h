//
//  ProfileItemCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BtnActionBlock)(NSInteger tag);
@interface ProfileItemCell : UITableViewCell
@property (nonatomic, copy) BtnActionBlock btnActionBlock;
@end


@interface ProfileItemBtn : UIButton

@end
