//
//  ProfileOrderFooterView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/8.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProfileOrderFooterBtnBlock)(NSInteger tag);

@class ProfileOrderIndex;
@interface ProfileOrderFooterView : UITableViewHeaderFooterView
@property (nonatomic, copy) ProfileOrderFooterBtnBlock btnBlock;
@property (nonatomic, strong)ProfileOrderIndex *orderIndex;
@end
