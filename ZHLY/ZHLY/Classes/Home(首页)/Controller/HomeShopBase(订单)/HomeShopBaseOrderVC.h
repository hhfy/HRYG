//
//  HomeMuseumOrderVC.h
//  ZHLY
//  订单页 - 通用：包含普通景点和选座场馆（除购物车确认）
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "BaseViewController.h"

@class HomeTicket,HomeTicketMainOrder;
@interface HomeShopBaseOrderVC : BaseViewController
@property (nonatomic, strong) HomeTicket *ordinaryTicket;
@property (nonatomic, strong) NSArray *ordinaryTicketArr;
@property (nonatomic, strong) HomeTicketMainOrder *ticketMainOrder; //选座购买获得的请求数据
//请求参数
@property (nonatomic, strong) NSArray *paramsArr;
@end
