
//
//  HomeDetialWebVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeDetialWebVC.h"

@interface HomeDetialWebVC ()
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *IdKey;
@end

@implementation HomeDetialWebVC

- (WebDataType)webDataType {
    return WebDataTypeHtml;
}

- (NSString *)setupTitle {
    return self.titleText;
}

- (NSString *)setupUrl {
    return self.apiUrl;
}

- (void)setupParams:(NSMutableDictionary *)params {
    NSString *key = self.IdKey ? self.IdKey : @"shop_id";
    params[key] = self.Id;
}

@end
