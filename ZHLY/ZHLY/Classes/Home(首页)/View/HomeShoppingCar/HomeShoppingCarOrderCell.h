//
//  HomeShoppingCarOrderCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/21.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeShoppingCarHotel, HomeShoppingCarTicket,HomeSeasonTicketOrderTicketList;
@interface HomeShoppingCarOrderCell : UITableViewCell
@property (nonatomic, strong) HomeShoppingCarHotel *hotel;
@property (nonatomic, strong) HomeShoppingCarTicket *ticket;
@property (nonatomic, assign) BOOL showImg; //显示购买须知
@property (nonatomic, strong) HomeSeasonTicketOrderTicketList *seasonTicket; //套票
@end
