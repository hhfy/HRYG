//
//  ProfileOrderListCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OrderforBlock)(void);

@class ProfileOrderTicketList;
@interface ProfileOrderListCell : UITableViewCell
@property (nonatomic, strong) ProfileOrderTicketList *ticket;
@property (nonatomic, copy) OrderforBlock orderBlock;
@end
