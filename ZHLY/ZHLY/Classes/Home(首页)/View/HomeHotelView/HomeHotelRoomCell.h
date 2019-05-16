//
//  HomeHotelRoomCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeHotelRoomInfo,HomeHotelInfo;
typedef void(^AddRoomToShoppingCarBlock)(HomeHotelRoomInfo *roomInfo, NSInteger count);
typedef void(^AddRoomOrderBlock)(HomeHotelRoomInfo *roomInfo, NSInteger count);

@interface HomeHotelRoomCell : UITableViewCell
@property (nonatomic, strong) HomeHotelRoomInfo *roomInfo;
@property(nonatomic,strong) HomeHotelInfo *hotelInfo;
@property (nonatomic, copy) AddRoomToShoppingCarBlock addShoppingCar;
@property (nonatomic, copy) AddRoomOrderBlock addRoomOrder;
@end
