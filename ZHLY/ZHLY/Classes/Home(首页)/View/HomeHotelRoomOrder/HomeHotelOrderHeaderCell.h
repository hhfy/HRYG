//
//  HomeHotelOrderHeaderCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CountDidChangedBlock)(CGFloat currentTicketTotalPayFor,NSInteger count);

@class HomeHotelRoomOrderInfo;
@interface HomeHotelOrderHeaderCell : UITableViewCell
@property (nonatomic, strong) HomeHotelRoomOrderInfo *roomOrderInfo;
@property (nonatomic, copy) CountDidChangedBlock totalPayForDidChange;
@end
