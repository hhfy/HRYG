//
//  HomeShoppingCarCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeStatusEventBlock)(NSIndexPath *indexPath, BOOL isSelected);

@class HomeShoppingCarHotel;
@interface HomeShoppingCarHotelCell : UITableViewCell
@property (nonatomic, strong) HomeShoppingCarHotel *hotel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isSelectedStatus;
@property (nonatomic, copy) ChangeStatusEventBlock changeStatus;
@end
