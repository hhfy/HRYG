//
//  TravelsDetailWebVCViewController.m
//  ZHLY
//
//  Created by LTWL on 2017/11/30.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsDetailWebVC.h"

@interface TravelsDetailWebVC ()
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, copy) NSString *Id;
@end

@implementation TravelsDetailWebVC

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
    params[@"travel_notes_id"] = self.Id;
}


@end
