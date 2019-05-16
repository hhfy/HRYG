//
//  HomeSeatSelectionVC.m
//  ZHLY
//  在线选座
//  Created by Moussirou Serge Alain on 2018/2/8.
//  Copyright © 2018年 LTWL. All rights reserved.
//

#import "HomeSeatSelectionVC.h"
#import "Home.h"

@interface HomeSeatSelectionVC ()
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, copy) NSString *biz_sess_id;
@end

@implementation HomeSeatSelectionVC

- (WebDataType)webDataType {
    return WebDataTypeUrl;
}

- (NSString *)setupTitle {
    return self.titleText;
}

- (NSString *)setupUrl {
    return [[NSBundle mainBundle] URLForResource:@"seat_detail" withExtension:@"html"].absoluteString;
//    return self.apiUrl;
}

- (BOOL)isCloseNavAnimation {
    return YES;
}
-(BOOL)rightBarBtnIsOpen {
    return YES;
}

- (NSString *)setupJs {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"API_URL"] = [MainURL stringByAppendingString:@"ticket/site"];
    params[@"biz_sess_id"] = self.biz_sess_id;
    params[Channel_pot_id] = ChannelPotId;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
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

- (void)receiveScriptMessage:(WKScriptMessage *)message {
    Log(@"%@", message.body);
    
    NSMutableArray *ticket = [NSMutableArray arrayWithArray:message.body[@"ticket"]];
    NSMutableArray *ticketListArr = [NSMutableArray array];
    for(int i=0;i<ticket.count;i++){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:ticket[i][@"biz_ticket_id"] forKey:@"biz_ticket_id"];
        [dic setValue:ticket[i][@"ticket_num"] forKey:@"ticket_lock_num"];
        
        [ticketListArr addObject:dic];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:ticketListArr options:kNilOptions error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *url = [MainURL stringByAppendingPathComponent:@"cart/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ticket_list"] = json;
    params[Token] = self.token;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
         NSArray *carArr = [HomeShoppingCarTicket mj_objectArrayWithKeyValuesArray:json[Data]];
        if([message.body[@"type"] isEqualToString:@"shopCar"]){ //加入购物车
            [SVProgressHUD showSuccess:@"添加购物车成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        else { //立即预订
            //params 参数
            NSMutableDictionary *requestParams = [NSMutableDictionary dictionary];
            for(int i=0;i<ticket.count;i++){
                NSString *keyID = [NSString stringWithFormat:@"ticket[%zd][biz_ticket_id]",i];
                NSString *keyNum = [NSString stringWithFormat:@"ticket[%zd][ticket_number]",i];
                [requestParams setValue:ticket[i][@"biz_ticket_id"] forKey:keyID];
                [requestParams setValue:ticket[i][@"ticket_num"] forKey:keyNum];
            }
            requestParams[Channel_pot_id] = ChannelPotId;
            requestParams[@"sign"] = [LaiMethod getSign];
            requestParams[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
            requestParams[Token] = self.token;
            NSMutableArray *paramsArr = [NSMutableArray arrayWithObject:requestParams];
            //
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            self.ordinaryTicket.totalCount = 1;
            params[@"ordinaryTicket"] = self.ordinaryTicket;
            params[@"paramsArr"] = paramsArr;
            params[@"ordinaryTicketArr"] = carArr; //购物车商品信息
            [LaiMethod runtimePushVcName:@"HomeShopBaseOrderVC" dic:params nav:self.navigationController];
        }
    } otherCase:nil failure:^(NSError *error){
    }];
}

@end
