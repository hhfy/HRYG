//
//  CheckoutGoView.m
//  YWY2
//
//  Created by LTWL on 2017/4/27.
//  Copyright © 2017年 XMB. All rights reserved.
//

#import "CheckoutGoView.h"
#import "CustomDatePicker.h"
#import "NSString+Extension.h"
#import "NSDate+Extension.h"
//#import "MBProgressHUD+LAI.h"

@interface CheckoutGoView () <CustomDatePickerDataSource, CustomDatePickerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArry;
@property (nonatomic, weak) CustomDatePicker *pickerView;
@end

@implementation CheckoutGoView

-(NSMutableArray *)dataArry {
    if (_dataArry == nil) {
        _dataArry = [NSMutableArray new];
    }
    return _dataArry;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [self addGestureRecognizer:tap];
    
}

- (void)viewTap {
    [self getWeakDay];
    CustomDatePicker * pickerView = [LaiMethod setupCustomPickerWithTitle:@"选择日期" delegate:self dataSource:self tintColor:MainThemeColor];
    _pickerView = pickerView;
}

#pragma mark - 转换计算时间
-(void)getWeakDay {
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate * today = [NSDate date];
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    for (int days = 1; days < 365; days ++) {
        NSString *dateString = [myDateFormatter stringFromDate:[today dateByAddingTimeInterval:days * secondsPerDay]];
        NSDate *inputDate = [NSDate dateFromStringFormat:dateString formatter:@"yyyy-MM-dd"];
        NSString * xq = [NSString calculateWeek:inputDate];
        NSString * itemStr = [NSString stringWithFormat:@"%@ %@",dateString,xq];
        [self.dataArry addObject:itemStr];
    }
}

#pragma mark - CustomDatePicker 数据源和代理
- (NSInteger)pickerView:(UIPickerView *)pickerView firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex numberOfRowsInPicker:(NSInteger)component {
    return self.dataArry.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * cellTitle = [[UILabel alloc] init];
    cellTitle.text = self.dataArry[row];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.font = TextSystemFont(20);
    cellTitle.textAlignment = NSTextAlignmentCenter;
    return cellTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row {
    NSString *selectDate = [self.dataArry[row] substringToIndex:10];
    NSString *selectWeek = [self.dataArry[row] substringFromIndex:11];
    
    NSString *checkOutTime = [NSString dateFormatMonthAndDayWithDateStr:selectDate];
    NSString *date = [NSString componentNowDateWithSelectedDate:selectDate formatter:@"YYYY-MM-dd"];
    NSString *checkOutWeek = (date.length) ? date : selectWeek;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"checkOutTime"] = checkOutTime;
    userInfo[@"checkOutFullTime"] = selectDate;
    userInfo[@"checkOutWeek"] = checkOutWeek;
    
    NSInteger result = [NSString compareDateStr:selectDate withOtherDateStr:self.checkinTime formatter:@"YYYY-MM-dd"];
    
    if ( result != 1) {
        [SVProgressHUD showError:@"离店时间要大于住店时间"];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckOutTimeNSNotification" object:nil userInfo:userInfo];
    [self.pickerView dismisView];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForPicker:(NSInteger)component {
    return Height44;
}

@end
