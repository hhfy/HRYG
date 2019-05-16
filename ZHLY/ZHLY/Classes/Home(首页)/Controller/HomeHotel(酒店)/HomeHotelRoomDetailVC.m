//
//  HomeHotelRoomDetailVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/26.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHotelRoomDetailVC.h"
#import "Home.h"
#import "HomeShopBaseShoppingCarSheetView.h"

@interface HomeHotelRoomDetailVC ()
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, copy) NSString *Id;
//@property (nonatomic, strong) HomeHotelInfo *hotelInfo;
@property (nonatomic, strong) HomeMuseumSeasonTickets *seasonTicket;
@property (nonatomic, copy) NSString *json;
@end

@implementation HomeHotelRoomDetailVC

- (WebDataType)webDataType {
    return WebDataTypeUrl;
}

- (NSString *)setupTitle {
    return self.titleText;
}

- (NSString *)setupUrl {
//        return [[NSBundle mainBundle] URLForResource:@"hotel_detail" withExtension:@"html"].absoluteString;
    return self.apiUrl;
}

- (BOOL)isCloseNavAnimation {
    return YES;
}

- (NSString *)setupJs {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"API_URL"] = [MainURL stringByAppendingString:@"home/hotel/room/detail"];
    params[@"room_id"] = self.Id;
    params[@"token"] = [SaveTool objectForKey:Token];
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    json = [json stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString *jsStr = [NSString stringWithFormat:@"getSetting(%@)", json];
    return jsStr;
}

- (NSString *)setupJsMsgObjName {
    return @"ios";
}

-(void)joinCar:(WKScriptMessage *)message withBuy:(BOOL)buy {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"biz_ticket_id"] = self.Id;
    dic[@"ticket_lock_num"] = @([message.body[@"number"] integerValue]);
    NSMutableArray *arr = [NSMutableArray arrayWithObject:dic];
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:nil];
    self.json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *url = [MainURL stringByAppendingPathComponent:@"cart/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ticket_list"] = self.json;
    params[Token] = self.token;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    params[@"start_time"] = message.body[@"start"];
    params[@"end_time"] = message.body[@"end"];
//    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        NSArray *carArr = [HomeShoppingCarTicket mj_objectArrayWithKeyValuesArray:json[Data]];
        [SVProgressHUD showSuccess:@"添加购物车成功"];
        if(buy){
            [self buy:message with:carArr];
        }
    } otherCase:nil failure:^(NSError *error){
    }];
}

-(void)buy:(WKScriptMessage *)message with:(NSArray *)arr {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"ticket[0][biz_ticket_id]"] = self.Id;
    dic[@"ticket[0][ticket_number]"] = @([message.body[@"number"] integerValue]);
    dic[@"ticket_list"] = self.json;
    dic[Token] = self.token;
    dic[@"sign"] = [LaiMethod getSign];
    dic[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    dic[Channel_pot_id] = ChannelPotId;
    NSMutableArray *paramsArr = [NSMutableArray arrayWithObject:dic];
    //
    //            weakSelf.ordinaryTicket.totalCount = [message.body[@"number"] integerValue];
    //            weakSelf.ordinaryTicket.ticket_deadline_text = message.body[@"date"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ordinaryTicket"] = self.ordinaryTicket;
    params[@"ordinaryTicketArr"] = arr;
    params[@"paramsArr"] = paramsArr;
    [LaiMethod runtimePushVcName:@"HomeShopBaseOrderVC" dic:params nav:CurrentViewController.navigationController];
}

- (void)receiveScriptMessage:(WKScriptMessage *)message {
    Log(@"%@", message.body);
    if([message.body[@"type"] isEqualToString:@"shopCar"]){ //加入购物车
        HomeShopBaseShoppingCarSheetView *shoppingCarSheetView = [HomeShopBaseShoppingCarSheetView viewFromXib];
        [shoppingCarSheetView show];
        shoppingCarSheetView.dismissCallBack = ^(NSInteger count) {
            [self joinCar:message withBuy:NO];
        };
    }
    else { //立即预订
        [self joinCar:message withBuy:YES];
    }
}




@end
