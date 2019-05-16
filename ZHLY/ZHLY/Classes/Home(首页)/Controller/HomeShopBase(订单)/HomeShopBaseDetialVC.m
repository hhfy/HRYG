
//
//  HomeMuseumDetialVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseDetialVC.h"
#import "Home.h"

@interface HomeShopBaseDetialVC ()
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, copy) NSString *Id;
@end

@implementation HomeShopBaseDetialVC

- (WebDataType)webDataType {
    return WebDataTypeUrl;
}

- (NSString *)setupTitle {
    return self.titleText;
}

- (NSString *)setupUrl {
    return [[NSBundle mainBundle] URLForResource:@"ticket_detail" withExtension:@"html"].absoluteString;
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
    params[@"biz_ticket_id"] = self.Id;
    params[@"API_URL"] = [MainURL stringByAppendingString:@"ticket/detail"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    json = [json stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString *js = [NSString stringWithFormat:@"getSetting(%@)", json];
    return js;
}

- (NSString *)setupJsMsgObjName {
    return @"ios";
}

- (void)receiveScriptMessage:(WKScriptMessage *)message {
    [self joinCar:message];
    
}

//// 添加购物车
//- (void)postAddShoppingCarRequesetWithMessage:(WKScriptMessage *)message {
////    NSString *url = [MainURL stringByAppendingPathComponent:@"home/ticket/cart/add"];
////    NSMutableDictionary *params = [NSMutableDictionary dictionary];
////    params[@"ticket_id"] = self.Id;
////    params[@"nums"] = @([message.body[@"number"] integerValue]);
////    params[Token] = [SaveTool objectForKey:Token];
////    params[@"date"] = message.body[@"date"];
////
////    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
////        [SVProgressHUD showSuccess:@"添加购物车成功"];
////    } otherCase:nil failure:nil];
//
//    [self joinCar:message];
//}

-(void)joinCar:(WKScriptMessage *)message {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"biz_ticket_id"] = self.Id;
    dic[@"ticket_lock_num"] = @([message.body[@"number"] integerValue]);
    NSMutableArray *arr = [NSMutableArray arrayWithObject:dic];
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *url = [MainURL stringByAppendingPathComponent:@"cart/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ticket_list"] = json;
    params[Token] = self.token;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
//
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        NSArray *carArr = [HomeShoppingCarTicket mj_objectArrayWithKeyValuesArray:json[Data]];
        if ([message.body[@"type"] isEqualToString:@"shopCar"]) {
            [SVProgressHUD showSuccess:@"添加购物车成功"];
        } else {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"ticket[0][biz_ticket_id]"] = self.Id;
            dic[@"ticket[0][ticket_number]"] = @([message.body[@"number"] integerValue]);
            dic[@"ticket_list"] = json;
            dic[Token] = self.token;
            dic[@"sign"] = [LaiMethod getSign];
            dic[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
            dic[Channel_pot_id] = ChannelPotId;
            NSMutableArray *paramsArr = [NSMutableArray arrayWithObject:dic];
            //
            weakSelf.ordinaryTicket.totalCount = [message.body[@"number"] integerValue];
            weakSelf.ordinaryTicket.ticket_deadline_text = message.body[@"date"];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"ordinaryTicket"] = weakSelf.ordinaryTicket;
            params[@"ordinaryTicketArr"] = carArr;
            params[@"paramsArr"] = paramsArr;
            [LaiMethod runtimePushVcName:@"HomeShopBaseOrderVC" dic:params nav:CurrentViewController.navigationController];
        }
    } otherCase:nil failure:^(NSError *error){
    }];
}

@end
