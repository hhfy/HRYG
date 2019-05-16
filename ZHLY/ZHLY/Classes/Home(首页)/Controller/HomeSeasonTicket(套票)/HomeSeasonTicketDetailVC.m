//
//  HomeSeasonTicketDetailVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeSeasonTicketDetailVC.h"
#import "Home.h"

@interface HomeSeasonTicketDetailVC ()
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, copy) NSString *channel_pot_id;
//@property(nonatomic,strong) NSString *ticketId;
@property(nonatomic,strong) NSString *biz_pt_id;
@property(nonatomic,strong) HomeMuseumSeasonTickets *seasonTicket;
@end

@implementation HomeSeasonTicketDetailVC

- (WebDataType)webDataType {
    return WebDataTypeUrl;
}

- (NSString *)setupTitle {
    return self.titleText;
}

- (NSString *)setupUrl {
    return [[NSBundle mainBundle] URLForResource:@"package_detail" withExtension:@"html"].absoluteString;
//    return self.apiUrl;
}

- (BOOL)isCloseNavAnimation {
    return YES;
}

- (NSString *)setupJs {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"channel_pot_id"] = self.channel_pot_id;
//    params[@"token"] = [SaveTool objectForKey:Token];
//    params[@"channel_id"] = self.channel_pot_id;
//    params[@"sess_id"] = [SaveTool objectForKey:Token];
    params[@"biz_pt_id"] = self.biz_pt_id;
//    params[@"biz_ticket_id"] = self.ticketId;
    //biz_pt_id
    params[@"API_URL"] = [MainURL stringByAppendingString:@"tickets/detail"];
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"date"] = message.body[@"date"];
    params[@"number"] = @([message.body[@"number"] integerValue]);
    params[@"biz_pt_id"] = self.biz_pt_id;
    params[@"titleText"] = @"填写订单";
    params[@"seasonTicket"] = self.seasonTicket;
    [LaiMethod runtimePushVcName:@"HomeSeasonTicketPlaceOrderVC" dic:params nav:CurrentViewController.navigationController];
}

@end
