//
//  NSString+Extension.h
//
//  Created by LTWL on 2017/4/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DifferenceDateComponentTypeOnlyDays = 0,
    DifferenceDateComponentTypeDayHourMinute,
    DifferenceDateComponentTypeHourMinute
} DifferenceDateComponentType;

@interface NSString (Extension)
/// 将字符串日期格式转为指定字符串格式的日期
+ (NSString *)dateStr:(NSString *)dateStr formatter:(NSString *)formatter formatWithOtherFormatter:(NSString *)otherFormatter;
/// 对比两个日期的大小
+ (NSInteger)compareDateStr:(NSString *)dateStr withOtherDateStr:(NSString *)otherDateStr formatter:(NSString *)formatter;
/// 根据当前日期判断是周几
+ (NSString *)calculateWeek:(NSDate *)date;
/// 通过当前时间判断是否为明天，今天，昨天，后天
+ (NSString *)componentNowDateWithSelectedDate:(NSString *)selectedDate formatter:(NSString *)formatter;
/// 比较两个时间的差值，可以设置天和分钟
+ (NSString *)getDifferenceDate:(NSString *)date withOtherDate:(NSString *)otherDate formatter:(NSString *)formatter options:(DifferenceDateComponentType)componentType;
/// NSDate转指定格式NSString
+ (NSString *)stringFormDateFromat:(NSDate *)date formatter:(NSString *)formatter;
/// 时间戳格式转为指定格式的时间
+ (NSString *)stringFromTimestampFromat:(NSString *)timestamp formatter:(NSString *)formatter;
/// 计算二进制文件的容量大小
+ (NSString *)getBytesFromDataLength:(long long)dataLength;
/// 数组转成JSON字符串
+ (NSString *)jsonStrFromatWithArray:(NSArray *)array;
/// 通过指定格式生日时间计算出年龄
+ (NSInteger)currentAgeWithBirthDay:(NSString *)birthDay format:(NSString *)format;
/// 对比当前时间和目标时间返回具体中文称呼
+ (NSString *)currentDateBetweenWithTargetDateTimestamp:(NSString *)timestamp;
/// 计算沙盒里面cache文件夹的大小
- (long long)fileSize;
/// 计算字符串frame
- (CGRect)sizeWithTextFont:(UIFont *)texFont rectSize:(CGSize)rectSize;
/// icon转换
+(NSString *)getIconStringWithName:(NSString *)name;
/// 字典转json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
///日期格式转换 2017-4-27 -> 4月27日
+ (NSString *)dateFormatMonthAndDayWithDateStr:(NSString *)dateStr;
///date转NSString
+ (NSString *)dateFormatMonthAndDayWithDate:(NSDate *)date;
@end
