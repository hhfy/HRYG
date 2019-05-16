//
//  NSArray+Estension.h
//
//  Created by LTWL on 2017/6/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)
/// JSON字符串数组转成OC数组
+ (NSArray *)arrayFromatFromJsonDataString:(NSString *)string;
@end
