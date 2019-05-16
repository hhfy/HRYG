
//
//  Home.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "Home.h"
#import "Travels.h"

@implementation HomeAd
@end
@implementation HomeMenu
@end
@implementation HomeNotify
@end
@implementation HomeScene
@end
@implementation HomeHomeModel
+ (NSDictionary *)objectClassInArray {
    return @{@"ad1" : [HomeAd class],
             @"ad2" : [HomeAd class],
             @"menu" : [HomeMenu class],
             @"notify" : [HomeNotify class],
             @"scene" : [HomeScene class]
             };
}
@end

@implementation TicketPayType
@end

@implementation HomeMuseumScoreList
@end

@implementation HomeMuseumInfo
@end




@implementation HomeShopBaseInfo
@end

@implementation HomeTicket
@end

@implementation HomeMuseumUserVisitor
@end

@implementation HomeMuseumSeasonTickets
@end

@implementation HomeShoppingCarTicket
@end

@implementation HomeShoppingCarHotel
@end

@implementation HomeSeasonTicketOrderSonList
@end

@implementation HomeSeasonTicketOrderTicketInfo
+ (NSDictionary *)objectClassInArray {
    return @{@"son_list" : [HomeSeasonTicketOrderSonList class]};
}
@end

@implementation HomeSeasonTicketOrderTicketList
@end

@implementation HomeSeasonTicketOrderPackage
+ (NSDictionary *)objectClassInArray {
    return @{@"ticket_list" : [HomeSeasonTicketOrderTicketList class]};
}
@end

@implementation HomeTicketMainOrder
+ (NSDictionary *)objectClassInArray {
    return @{@"pay_list" : [TicketPayType class],
             @"ticket_link" : [HomeTicket class]};
}
@end


@implementation HomeGoods

@end

@implementation HomeHotelInfo

@end

@implementation HomeHotelRoomInfo

@end

@implementation HomeHotelRoomPriceDetail

@end

@implementation HomeHotelRoomOrderInfo
+ (NSDictionary *)objectClassInArray {
    return @{@"room_price_detail" : [HomeHotelRoomPriceDetail class]};
}
@end

@implementation HomeHotelRoomOrderConfirm
+ (NSDictionary *)objectClassInArray {
    return @{@"room_list" : [HomeHotelRoomOrderInfo class]};
}
@end

@implementation HomeTicketPayOrderInfo

@end
@implementation HomeTicketPayInfo

@end


@implementation HomeNotice

@end
@implementation HomeNoticeList
+ (NSDictionary *)objectClassInArray {
    return @{@"list" : [HomeNotice class]};
}
@end

@implementation AlipayInfo

@end

@implementation HomeSearchInfo
+ (NSDictionary *)objectClassInArray {
    return @{@"ticket" : [HomeTicket class],
             @"tickets" : [HomeMuseumSeasonTickets class],
             @"note" : [TravelNoteTip class]
             };
}
@end
