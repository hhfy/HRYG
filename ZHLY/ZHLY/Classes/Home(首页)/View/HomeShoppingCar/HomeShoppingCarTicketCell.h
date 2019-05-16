//
//  HomeShoppingCarCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeStatusEventBlock)(NSIndexPath *indexPath, BOOL isSelected);

@class HomeShoppingCarTicket;
@interface HomeShoppingCarTicketCell : UITableViewCell
@property (nonatomic, strong) HomeShoppingCarTicket *ticket;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isSelectedStatus;
@property (nonatomic, copy) ChangeStatusEventBlock changeStatus;
@end
