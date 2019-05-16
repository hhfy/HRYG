
//
//  ProfileDetailWebVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileDetailWebVC.h"

@interface ProfileDetailWebVC ()
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, copy) NSString *Id;
@end

@implementation ProfileDetailWebVC

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
    params[Id] = self.Id;
}

@end
