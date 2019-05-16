//
//  HomeMuseumHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseHeaderView.h"
#import "Home.h"
#import <FBShimmering.h>
#import <FBShimmeringView.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface HomeShopBaseHeaderView () <SDCycleScrollViewDelegate,CustomDatePickerDelegate, CustomDatePickerDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *leftArrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightArrowLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *startBgView;
@property (weak, nonatomic) IBOutlet HomeShopBaseHeaderStartView *stratView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *locIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *locLabel;
@property (nonatomic, strong) SDCycleScrollView *sDCycleScrollView;
@property (weak, nonatomic) IBOutlet UILabel *pageCountLabel;
@property (weak, nonatomic) IBOutlet HomeShopBaseHeaderDateBtn *firstDateBtn;
@property (weak, nonatomic) IBOutlet HomeShopBaseHeaderDateBtn *SecondDateBtn;
@property (weak, nonatomic) IBOutlet HomeShopBaseHeaderDateBtn *thirdDateBtn;
@property (weak, nonatomic) IBOutlet HomeShopBaseHeaderDateBtn *fourthDateBtn;
@property (weak, nonatomic) IBOutlet HomeShopBaseHeaderDateBtn *fifthDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftViewTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftViewDetialLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, weak) CustomDatePicker *pickerView;
@end

@implementation HomeShopBaseHeaderView

- (SDCycleScrollView *)sDCycleScrollView {
    if (_sDCycleScrollView == nil){
        _sDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenSize.width, self.topView.height) delegate:self placeholderImage:SetImage(BannerPlaceHolder)];
        _sDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sDCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _sDCycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _sDCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _sDCycleScrollView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.rightArrowLabel.font = self.leftArrowLabel.font = IconFont(15);
    self.rightArrowLabel.text = self.leftArrowLabel.text = RightArrowIconUnicode;
    self.locIconLabel.font = IconFont(20);
    self.locIconLabel.text = LocationIconUnicode2;
    [self.topView insertSubview:self.sDCycleScrollView atIndex:0];
    self.stratView.stars = 3.5;
    
    self.firstDateBtn.isIgnore = self.SecondDateBtn.isIgnore = self.thirdDateBtn.isIgnore = self.fourthDateBtn.isIgnore = self.fifthDateBtn.isIgnore = YES;
    //
    NSTimeInterval oneDayTimeInterval = 24*60*60;
    self.firstDateBtn.date = [NSDate localDate];
    self.firstDateBtn.selected = YES;
    self.SecondDateBtn.date = [NSDate dateWithTimeInterval:oneDayTimeInterval sinceDate:[NSDate localDate]];
    self.thirdDateBtn.date = [NSDate dateWithTimeInterval:(oneDayTimeInterval * 2) sinceDate:[NSDate localDate]];
    self.fourthDateBtn.date = [NSDate dateWithTimeInterval:(oneDayTimeInterval * 3) sinceDate:[NSDate localDate]];
    self.fifthDateBtn.date = nil;
    
    [self.leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewTap:)]];
    [self.rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewTap:)]];
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.stratView.bounds];
    shimmeringView.shimmering = YES;
    shimmeringView.shimmeringOpacity = 1;
    shimmeringView.shimmeringDirection = FBShimmerDirectionRight;
    shimmeringView.shimmeringBeginFadeDuration = 0.3;
    shimmeringView.shimmeringPauseDuration = 2;
    shimmeringView.shimmeringHighlightWidth = 0.9;
    shimmeringView.shimmeringSpeed = 150;
    shimmeringView.layer.cornerRadius = self.stratView.height * 0.5;
    shimmeringView.clipsToBounds = YES;
    shimmeringView.backgroundColor = [UIColor whiteColor];
    shimmeringView.contentView = self.stratView;
    [self.startBgView addSubview:shimmeringView];
    //
    self.firstDateBtn.hidden = YES;
    self.SecondDateBtn.hidden = YES;
    self.thirdDateBtn.hidden = YES;
    self.fourthDateBtn.hidden = YES;
    self.fifthDateBtn.hidden = YES;
}
-(void)setHiddenBottomView:(BOOL)hiddenBottomView {
    if (hiddenBottomView) {
        self.bottomView.hidden = YES;
    }
}

//导航
- (IBAction)naviBtnAction:(id)sender {
//    [SVProgressHUD showError:@"未获取到经纬度信息"];
    [self lineNavigationWithcLLocationCoordinate2D:CLLocationCoordinate2DMake([self.info.scene_latitude doubleValue], [self.info.scene_longitude doubleValue])];
}


- (void)lineNavigationWithcLLocationCoordinate2D:(CLLocationCoordinate2D)cLLocationCoordinate2D {
    CLLocationCoordinate2D loc = cLLocationCoordinate2D;
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                                                                MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}
- (IBAction)backBtnTap {
    [CurrentViewController.navigationController popViewControllerAnimated:YES];
}
//景点介绍
- (void)leftViewTap:(UITapGestureRecognizer *)tap {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"apiUrl"] = self.info.detialApi;
//    params[@"Id"] = self.info.shopId;
    params[@"titleText"] = @"景点详情";
    [LaiMethod runtimePushVcName:@"HomeDetialWebVC" dic:params nav:CurrentViewController.navigationController];
}

//购物车
- (IBAction)shoppingCarBtnTap:(UIButton *)button {
    [LaiMethod runtimePushVcName:@"HomeShoppingCarVC" dic:nil nav:CurrentViewController.navigationController];
}

//用户评价
- (void)rightViewTap:(UITapGestureRecognizer *)tap {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"shopId"] = self.info.shopId;
    [LaiMethod runtimePushVcName:@"HomeShopBaseScoreVC" dic:params nav:CurrentViewController.navigationController];
}

- (IBAction)firstBtnTap:(HomeShopBaseHeaderDateBtn *)button {
    button.selected = YES;
    self.SecondDateBtn.selected = NO;
    self.thirdDateBtn.selected = NO;
    self.fourthDateBtn.selected = NO;
    self.fifthDateBtn.selected = NO;
    if (self.didSelectedDate) self.didSelectedDate(button.date);
}

- (IBAction)secondDateBtnTap:(HomeShopBaseHeaderDateBtn *)button {
    button.selected = YES;
    self.firstDateBtn.selected = NO;
    self.thirdDateBtn.selected = NO;
    self.fourthDateBtn.selected = NO;
    self.fifthDateBtn.selected = NO;
    if (self.didSelectedDate) self.didSelectedDate(button.date);
}

- (IBAction)thirdDateBtnTap:(HomeShopBaseHeaderDateBtn *)button {
    button.selected = YES;
    self.SecondDateBtn.selected = NO;
    self.firstDateBtn.selected = NO;
    self.fourthDateBtn.selected = NO;
    self.fifthDateBtn.selected = NO;
    if (self.didSelectedDate) self.didSelectedDate(button.date);
}

- (IBAction)fourthDateBtnTap:(HomeShopBaseHeaderDateBtn *)button {
    button.selected = YES;
    self.SecondDateBtn.selected = NO;
    self.thirdDateBtn.selected = NO;
    self.firstDateBtn.selected = NO;
    self.fifthDateBtn.selected = NO;
    if (self.didSelectedDate) self.didSelectedDate(button.date);
}

- (IBAction)fifthDateBtnTap:(HomeShopBaseHeaderDateBtn *)button {
    self.pickerView = [LaiMethod setupCustomPickerWithTitle:@"请选择日期" delegate:self dataSource:self tintColor:MainThemeColor];
    
//    NSTimeInterval oneDayTimeInterval = 24*60*60;
//    WeakSelf(weakSelf)
//    [LaiMethod setupKSDatePickerWithMinDate:[NSDate dateWithTimeInterval:(oneDayTimeInterval * 3) sinceDate:[NSDate localDate]] maxDate:nil dateMode:UIDatePickerModeDate headerColor:MainThemeColor result:^(NSDate *selected) {
//        weakSelf.fourthDateBtn.date = selected;
//        weakSelf.SecondDateBtn.selected = NO;
//        weakSelf.thirdDateBtn.selected = NO;
//        weakSelf.firstDateBtn.selected = NO;
//        weakSelf.fifthDateBtn.selected = NO;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//             weakSelf.fourthDateBtn.selected = YES;
//            if (weakSelf.didSelectedDate) weakSelf.didSelectedDate(weakSelf.fourthDateBtn.date);
//        });
//    }];
}

- (void)setInfo:(HomeShopBaseInfo *)info {
    _info = info;
    if(info.banner){
        self.sDCycleScrollView.imageURLStringsGroup = @[info.banner];
    }
    self.nameLabel.text = info.shopName;
    self.pageCountLabel.text = [NSString stringWithFormat:@"%zd张", info.bannerCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%zd条评价", info.commentCount];
    self.locLabel.text = info.address.length>0 ? info.address : @"未获取到位置信息";
    self.leftViewTitleLabel.text = info.leftViewTitle;
    self.leftViewDetialLabel.text = info.leftViewDetialText;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f分", info.startCount];
    self.stratView.stars = info.startCount;
    //
    self.bottomView.backgroundColor = [UIColor whiteColor];
    if(info.date.count>0){
        self.firstDateBtn.hidden = NO;
        self.SecondDateBtn.hidden = YES;
        self.thirdDateBtn.hidden = YES;
        self.fourthDateBtn.hidden = YES;
        if(info.date.count>4){
            self.fifthDateBtn.hidden = NO;
        }
    }
//    else {
//        self.firstDateBtn.hidden = NO;
//        self.SecondDateBtn.hidden = NO;
//        self.thirdDateBtn.hidden = NO;
//        self.fourthDateBtn.hidden = NO;
//        self.fifthDateBtn.hidden = NO;
//    }
    for (int i=0; i<info.date.count; i++) {
        NSDate *date = [LaiMethod getDateString:info.date[i] withFormat:@"yyyy-MM-dd"];
        if (i==0) {
            self.firstDateBtn.date = date;
            self.firstDateBtn.selected = YES;
        }
        else if (i == 1){
            self.SecondDateBtn.date = date;
            self.SecondDateBtn.hidden = NO;
        }
        else if (i == 2){
            self.thirdDateBtn.date = date;
            self.thirdDateBtn.hidden = NO;
        }
        else if (i == 3){
            self.fourthDateBtn.date = date;
            self.fourthDateBtn.hidden = NO;
        }
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"titleText"] = [NSString stringWithFormat:@"%zd张图片", self.info.bannerCount];
    params[@"shopId"] = self.info.shopId;
    [LaiMethod runtimePushVcName:@"TravelsAlbumVC" dic:params nav:CurrentViewController.navigationController];
}

#pragma mark - CustomDatePicker数据源和代理
- (NSInteger)pickerView:(UIPickerView *)pickerView  firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex numberOfRowsInPicker:(NSInteger)component {
    return self.info.date.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * cellTitle = [[UILabel alloc] init];
    cellTitle.text = self.info.date[row];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.font = TextSystemFont(20);
    cellTitle.textAlignment = NSTextAlignmentCenter;
    return cellTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row {
    self.fourthDateBtn.date = [LaiMethod getDateString:self.info.date[row] withFormat:@"YYYY-MM-dd"];
    self.SecondDateBtn.selected = NO;
    self.thirdDateBtn.selected = NO;
    self.firstDateBtn.selected = NO;
    self.fifthDateBtn.selected = NO;
    self.fourthDateBtn.selected = YES;
    if (self.didSelectedDate) self.didSelectedDate(self.fourthDateBtn.date);
    [self.pickerView dismisView];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForPicker:(NSInteger)component {
    return Height44;
}

@end

/// 导航按钮
@implementation HomeShopBaseHeaderNavBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = self.currentImage.size;
    self.imageView.y = 10;
    self.imageView.centerX = self.width * 0.5;
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.maxY + 2;
    self.titleLabel.width = self.width;
    self.titleLabel.height = 20;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

/// 星星View
@implementation HomeShopBaseHeaderStartView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    // 未点亮星星的颜色（可根据自己喜好设定）
    self.emptyColor = SetupColor(194, 194, 194);
    // 点亮星星的颜色
    self.fullColor = SetupColor(228, 167, 102);
}

- (void)setStars:(CGFloat)stars {
    _stars = stars;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString *stars = @"★★★★★";
    
    UIFont *font = TextSystemFont(self.height + 1);
    CGSize starSize = [stars sizeWithTextFont:font rectSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
    rect.size=starSize;
    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: self.emptyColor}];
    
    CGRect clip = rect;
    // 裁剪的宽度 = 点亮星星宽度 = （显示的星星数/总共星星数）*总星星的宽度
    clip.size.width = starSize.width * (self.stars / (double)stars.length);
    CGContextClipToRect(context,clip);
    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: self.fullColor}];
}
@end

/// 时间btn
@interface HomeShopBaseHeaderDateBtn ()
@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UILabel *weekLabel;
@end

@implementation HomeShopBaseHeaderDateBtn

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    UILabel *weekLabel = [UILabel new];
    weekLabel.font = TextSystemFont(15);
    weekLabel.textColor = SetupColor(153, 153, 153);
    if (!self.date) {
        weekLabel.font = IconFont(17.5);
        weekLabel.text = CalendarIconUnicode;
    } else {
        if ([self.date isToday]) weekLabel.textColor = [UIColor whiteColor];
        weekLabel.text = [NSString calculateWeek:self.date];
    }
    weekLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:weekLabel];
    _weekLabel = weekLabel;
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.font = TextSystemFont(15);
    dateLabel.textColor = SetupColor(51, 51, 51);
    if ([self.date isToday]) {
        dateLabel.text = @"今天";
        dateLabel.textColor = [UIColor whiteColor];
    } else if ([self.date isTomorrow]) {
        dateLabel.text = @"明天";
    } else if (!self.date) {
        dateLabel.text = @"选择日期";
        if (iPhoneSE) dateLabel.font = TextSystemFont(12);
        if (iPhone6 || iPhoneX) dateLabel.font = TextSystemFont(13.5);
    } else {
        dateLabel.text = [NSString stringFormDateFromat:self.date formatter:FmtMD2];
    }
    
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    self.weekLabel.text = [NSString calculateWeek:date];
    self.dateLabel.text = [NSString stringFormDateFromat:date formatter:FmtMD2];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = MainThemeColor;
        self.weekLabel.textColor = self.dateLabel.textColor = [UIColor whiteColor];
        [LaiMethod animationWithView:self];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.weekLabel.textColor = SetupColor(153, 153, 153);
        self.dateLabel.textColor = SetupColor(51, 51, 51);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.weekLabel.y = 5;
    self.weekLabel.x = 0;
    self.weekLabel.width = self.width;
    self.weekLabel.height = [self.weekLabel.text sizeWithTextFont:self.weekLabel.font rectSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].size.height;
    
    self.dateLabel.y = self.weekLabel.maxY + 5;
    self.dateLabel.x = 0;
    self.dateLabel.width = self.width;
    self.dateLabel.height = [self.dateLabel.text sizeWithTextFont:self.dateLabel.font rectSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].size.height;
    if (!self.date) self.dateLabel.y += 2;
}

@end


