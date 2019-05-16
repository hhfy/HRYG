//
//  NSDate+Extension.h
//
//  Created by LTWL on 2017/2/4.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/// 判断当期时间是否为今年
- (BOOL)isThisYear;
/// 判断当期时间是否为昨天
- (BOOL)isYesterday;
/// 判断当期时间是否为明天
- (BOOL)isTomorrow;
/// 判断当期时间是否为今天
- (BOOL)isToday;
/// 判断当期时间是否为后天
- (BOOL)isDayAfterTomorrow;
/// 判断当期时间是在本周类
- (BOOL)isThisWeek;
/// 判断当期时间是否没有过期
- (BOOL)isInTime;
/// 判断当期时间是否过期（用截止日期和今天作比较的）
- (BOOL)isOutTime;
/// 本地时间（去掉时区）
+ (NSDate *)localDate;
/// 将制定字符串格式的时间转为NSDate
+ (NSDate *)dateFromStringFormat:(NSString *)dateStr formatter:(NSString *)formatter;
@end
