//
//  HomeShopCarOrderNewVC.h
//  ZHLY
//  购物车结算下单
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "BaseViewController.h"

@class HomeTicket,HomeTicketMainOrder;
@interface HomeShopCarOrderNewVC : BaseViewController
//@property (nonatomic, copy) NSString *ticketId;
//@property (nonatomic, copy) NSString *date;
//@property (nonatomic, assign) NSInteger buyCount;
@property (nonatomic, strong) HomeTicket *ordinaryTicket;
@property (nonatomic, strong) NSArray *ordinaryTicketArr;
@property (nonatomic, strong) HomeTicketMainOrder *ticketMainOrder; //选座购买获得的请求数据
//是否需要请求接口：选座表示已经请求过数据，普通购买需要当前页面请求
//@property (nonatomic, assign) BOOL isNeedRequest;
@property (nonatomic, strong) NSArray *paramsArr;
@end
