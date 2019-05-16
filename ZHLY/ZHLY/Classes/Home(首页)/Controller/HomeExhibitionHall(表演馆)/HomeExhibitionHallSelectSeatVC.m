//
//  HomeExhibitionHallSelectSeatVC.m
//  ZHLY
//
//  Created by LTWL on 2018/1/19.
//  Copyright © 2018年 LTWL. All rights reserved.
//

#import "HomeExhibitionHallSelectSeatVC.h"

@implementation HomeExhibitionHallSelectSeatVC

- (WebDataType)webDataType {
    return WebDataTypeUrl;
}

- (NSString *)setupTitle {
    return @"测试选座";
}

- (NSString *)setupUrl {
    return @"http://www.ztxywy.com/map-box/index.html";
}




@end
