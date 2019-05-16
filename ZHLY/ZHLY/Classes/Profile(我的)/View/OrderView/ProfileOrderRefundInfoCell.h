//
//  ProfileOrderRefundInfoCell.h
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/5.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileOrderInfo;
@interface ProfileOrderRefundInfoCell : UITableViewCell
@property(nonatomic,strong)ProfileOrderInfo *orderInfo;
@property(nonatomic,copy)NSString *info;
@property(nonatomic,copy)NSString *name;
@end
