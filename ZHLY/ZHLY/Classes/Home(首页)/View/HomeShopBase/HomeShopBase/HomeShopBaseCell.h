//
//  HomeMuseumCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTicket;
typedef void(^AddShoppingCarBlock)(NSInteger count);
typedef void(^PayforBlock)(void);

@interface HomeShopBaseCell : UITableViewCell
@property (nonatomic, strong) HomeTicket *ticket;
@property (nonatomic, copy) AddShoppingCarBlock addShoppingCar;
@property (nonatomic, copy) PayforBlock payfor;
@end
