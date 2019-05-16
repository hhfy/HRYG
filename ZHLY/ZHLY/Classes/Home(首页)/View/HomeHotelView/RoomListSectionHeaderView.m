//
//  RoomListSectionHeaderView.m
//  YWY2
//
//  Created by LTWL on 2017/4/26.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "RoomListSectionHeaderView.h"
#import "NSString+Extension.h"
#import "CheckoutGoView.h"
#import "CheckInView.h"

@interface RoomListSectionHeaderView () 

@property (weak, nonatomic) IBOutlet UILabel *nowDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkInLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel2;
@property (nonatomic, strong) NSMutableArray *dataArry;
@property (weak, nonatomic) IBOutlet CheckInView *checkInView;
@property (weak, nonatomic) IBOutlet CheckoutGoView *checkoutGoView;
@end

@implementation RoomListSectionHeaderView

+ (instancetype)show {
    return [[[NSBundle mainBundle] loadNibNamed:@"RoomListSectionHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    [self addNSNotification];
}

- (void)setupUI {
    self.checkInLabel.textColor = self.checkoutLabel.textColor = self.checkInLabel.textColor = self.checkoutLabel.textColor = self.nowDateLabel.textColor = self.otherDateLabel.textColor = SetupColor(153, 153, 153);
    self.arrowLabel.textColor = self.arrowLabel2.textColor = SetupColor(199, 199, 199);
    self.arrowLabel.font = self.arrowLabel2.font = IconFont(12);
    self.arrowLabel.text = self.arrowLabel2.text = @"\U0000e684";

    self.checkTimeLabel.text = [NSString dateFormatMonthAndDayWithDate:[NSDate date]];
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]];
    self.checkoutTimeLabel.text = [NSString dateFormatMonthAndDayWithDate:nextDate];

    NSString *fmt = @"yyyy-MM-dd";
    self.checkInView.checkoutTime = [NSString stringFormDateFromat:nextDate formatter:fmt];
    self.checkoutGoView.checkinTime = [NSString stringFormDateFromat:[NSDate date] formatter:fmt];
    self.checkTime = self.checkoutGoView.checkinTime;
    self.checkoutTime = self.checkInView.checkoutTime;
}

- (void)addNSNotification {
    WeakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CheckOutTimeNSNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.checkoutTimeLabel.text = note.userInfo[@"checkOutTime"];
        weakSelf.otherDateLabel.text = note.userInfo[@"checkOutWeek"];
        weakSelf.checkInView.checkoutTime = note.userInfo[@"checkOutFullTime"];
        weakSelf.checkoutTime = note.userInfo[@"checkOutFullTime"];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CheckInTimeNSNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.checkTimeLabel.text = note.userInfo[@"checkInTime"];
        weakSelf.nowDateLabel.text = note.userInfo[@"checkInWeek"];
        weakSelf.checkoutGoView.checkinTime = note.userInfo[@"checkInFullTime"];
        weakSelf.checkTime = note.userInfo[@"checkInFullTime"];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CheckoutNextTimeNSNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.checkoutTimeLabel.text = note.userInfo[@"checkOutTime"];
        weakSelf.otherDateLabel.text = note.userInfo[@"checkOutWeek"];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
