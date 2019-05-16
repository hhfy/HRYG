
//
//  HomeGoodsDetialVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeGoodsDetialVC.h"

@interface HomeGoodsDetialVC ()
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, copy) NSString *goodId;
@end

@implementation HomeGoodsDetialVC

- (WebDataType)webDataType {
    return WebDataTypeUrl;
}

- (NSString *)setupTitle {
    return self.titleText;
}

- (NSString *)setupUrl {
    return self.apiUrl;
}

- (NSString *)setupJs {
    NSString *js = [NSString stringWithFormat:@"getSetting(%@,%@,%@)", [SaveTool objectForKey:Token], self.goodId, [MainURL stringByAppendingString:@"home/goods/goods/detail"]];
    return js;
}

- (NSString *)setupJsMsgObjName {
    return @"ios";
}

- (void)receiveScriptMessage:(WKScriptMessage *)message {
    Log(@"%@", message.body);
    
}

@end
