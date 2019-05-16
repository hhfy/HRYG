//
//  NSString+Extension.m
//
//  Created by LTWL on 2017/4/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "NSString+Extension.h"
#import "NSDate+Extension.h"

@implementation NSString (Extension)

/// 将字符串日期格式转为指定字符串格式的日期
+ (NSString *)dateStr:(NSString *)dateStr formatter:(NSString *)formatter  formatWithOtherFormatter:(NSString *)otherFormatter {
    NSDate *date = [NSDate dateFromStringFormat:dateStr formatter:formatter];
    return [NSString stringFormDateFromat:date formatter:otherFormatter];
}

/// 对比连个字符串类型的时间至少是年月日
+ (NSInteger)compareDateStr:(NSString *)dateStr withOtherDateStr:(NSString *)otherDateStr formatter:(NSString *)formatter {
    NSDate *dateA = [NSDate dateFromStringFormat:dateStr formatter:formatter];
    NSDate *dateB = [NSDate dateFromStringFormat:otherDateStr formatter:formatter];
    
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) { //降序
        return 1;
    } else if (result == NSOrderedAscending){ // 升序
        return -1;
    } else {
        return 0;
    }
}

/// 将字符类型的时间转为周几至少是年月日
+ (NSString *)calculateWeek:(NSDate *)date {
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSCalendarUnitWeekday fromDate:date] weekday];
    switch (week) {
        case 1: {
            return @"周日";
        }
        case 2: {
            return @"周一";
        }
        case 3: {
            return @"周二";
        }
        case 4: {
            return @"周三";
        }
        case 5: {
            return @"周四";
        }
        case 6: {
            return @"周五";
        }
        case 7: {
            return @"周六";
        }
    }
    return nil;
}

/// 对比两个字符串格式的时间是否为今天、明天、后天
+ (NSString *)componentNowDateWithSelectedDate:(NSString *)selectedDate formatter:(NSString *)formatter {

    NSDate *createDate = [NSDate dateFromStringFormat:selectedDate formatter:formatter];
    
    if ([createDate isYesterday]) {
        return @"昨天";
    }
    else if ([createDate isToday]) // 今天
    {
        return @"今天";
    }
    else if ([createDate isTomorrow]) // 明天
    {
        return @"明天";
    }
    else if ([createDate isDayAfterTomorrow]) // 后天
    {
        return @"后天";
    } else {
        return [self calculateWeek:createDate]; // 显示周几
    }
}

/// 对比两个字符串类型的时间直接的差值(格式不能为时间戳类型的格式)
+ (NSString *)getDifferenceDate:(NSString *)date withOtherDate:(NSString *)otherDate formatter:(NSString *)formatter options:(DifferenceDateComponentType)componentType {
    NSDate *dateA = [NSDate dateFromStringFormat:date formatter:formatter];
    NSDate *dateB = [NSDate dateFromStringFormat:otherDate formatter:formatter];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:dateB toDate:dateA options:0];
    
    switch (componentType) {
        case DifferenceDateComponentTypeOnlyDays:
            return [NSString stringWithFormat:@"%zd", labs(dateCom.day)];
            break;
        case DifferenceDateComponentTypeDayHourMinute:
            return [NSString stringWithFormat:@"%zd天%zd时%zd分", labs(dateCom.day), labs(dateCom.hour), labs(dateCom.minute)];
            break;
        case DifferenceDateComponentTypeHourMinute:
            return [NSString stringWithFormat:@"%zd时%zd分", labs(dateCom.hour), labs(dateCom.minute)];
            break;
        default:
            return nil;
            break;
    }
}

/// NSDate转为字符串格式的时间
+ (NSString *)stringFormDateFromat:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0.f];
    fmt.dateFormat = formatter;
    return [fmt stringFromDate:date];
}

/// 将时间戳装换为指定的字符串格式的时间格式
+ (NSString *)stringFromTimestampFromat:(NSString *)timestamp formatter:(NSString *)formatter {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSDate *localDate = [date dateByAddingTimeInterval:28800.0f];
    return [NSString stringFormDateFromat:localDate formatter:formatter];
}

/// 计算NSData大小
+ (NSString *)getBytesFromDataLength:(long long)dataLength {
    NSString *bytes = nil;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM", dataLength / 1024 / 1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK", dataLength / 1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB", dataLength];
    }
    return bytes;
}

/// json字符串转数组
+ (NSString *)jsonStrFromatWithArray:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    return (error) ? nil : [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/// 计算出生的岁数
+ (NSInteger)currentAgeWithBirthDay:(NSString *)birthDay format:(NSString *)format{
    NSDate *birthDate = [NSDate dateFromStringFormat:birthDay formatter:format];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:birthDate toDate:[NSDate date] options:0];
    if (cmps.month > 0 && cmps.month <5) {
        return cmps.year + 1;
    } else if (cmps.month >= 5) {
        return cmps.year + 2;
    } else {
        return cmps.year;
    }
}

/// 对比当前时间和目标时间返回具体中文称呼
+ (NSString *)currentDateBetweenWithTargetDateTimestamp:(NSString *)timestamp {
    NSString *fmt = @"yyyy-MM-dd HH:mm:ss";
    NSDate *creatDate = [NSDate dateFromStringFormat:[self stringFromTimestampFromat:timestamp formatter:fmt] formatter:fmt];
    
    // 当前时间
    NSDate *now = [NSDate localDate];
    
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 设置哪些对比的属性（年、月、日）
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 计算两个日历之前的差值(但是不能像下面一样获得具体的时间)
    NSDateComponents *cmps = [calendar components:unit fromDate:creatDate toDate:now options:NSCalendarWrapComponents];
    
    if ([creatDate isThisYear]) // 今年
    {
        if ([creatDate isToday]) // 今天
        {
            if (cmps.hour >= 1) // 大于1小时发的
            {
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            }
            else if (cmps.minute >= 1) // 1小时以内
            {
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            }
            else // 小于1分钟
            {
                return @"刚刚";
            }
        }
        else if ([creatDate isYesterday]) // 昨天
        {
            return [NSString stringFormDateFromat:creatDate formatter:@"昨天 HH:mm"];
        }
        else // 一年以内
        {
            return [NSString stringFormDateFromat:creatDate formatter:@"MM-dd HH:mm"];
        }
    }
    else // 非今年
    {
        return [NSString stringFormDateFromat:creatDate formatter:@"yyyy-MM-dd HH:mm"];
    }
}

- (long long)fileSize {
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL dir = NO;
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&dir];
    // 文件、文件夹不存在
    if (exists == NO) return 0;
    if (dir) // self是一个文件夹
    {
        // NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        // 遍历caches里面所有的文件
        //NSArray *contents = [mgr contentsOfDirectoryAtPath:caches error:nil];
        // 该方法可以搞定所有文件夹下面的文件
        NSArray *subPaths = [mgr subpathsAtPath:self];
        // 所有文件总大小
        NSInteger totalFileSize = 0;
        for (NSString *subPath in subPaths)
        {
            // 拼接全路径
            NSString *fullSubPath = [self stringByAppendingPathComponent:subPath];
            // 判断是否为文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
            if (dir == NO) // 是文件
            {
                NSDictionary *attrs = [mgr attributesOfItemAtPath:fullSubPath error:nil];
                long long fileSize = [attrs[NSFileSize] longLongValue];
                totalFileSize += fileSize;
                }
        }
        return totalFileSize;
    } else{
        NSDictionary *attrs = [mgr attributesOfItemAtPath:self error:nil];
        long long fileSize = [attrs[NSFileSize] longLongValue];
        return fileSize;
    }
}

- (CGRect)sizeWithTextFont:(UIFont *)texFont rectSize:(CGSize)rectSize {
    return [self boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:texFont} context:nil];
}

+ (NSString *)getIconStringWithName:(NSString *)name {
    if (!name) return nil;
    NSString *hexString = [name substringWithRange:NSMakeRange(3, 4)];
    unsigned int character;
    NSScanner* scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&character ];
    UTF32Char inputChar = NSSwapHostIntToLittle(character); // swap to little-endian if necessary
    NSString *str = [[NSString alloc] initWithBytes:&inputChar length:4 encoding:NSUTF32LittleEndianStringEncoding];
    return str;
}

/// 字典转json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    if (![dic allKeys]) return nil;
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

///日期格式转换 2017-4-27 -> 4月27日
+ (NSString *)dateFormatMonthAndDayWithDateStr:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateStr];
    formatter.dateFormat = @"MM月dd日";
    return [formatter stringFromDate:date];
}

///date转NSString
+ (NSString *)dateFormatMonthAndDayWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M月dd日";
    return [formatter stringFromDate:date];
}

@end
