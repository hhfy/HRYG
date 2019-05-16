//
//  HomeHotelOrderVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/19.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHotelOrderVC.h"
#import "HomeShopBaseOrderCommitView.h"
#import "HomeHotelOrderHeaderCell.h"
#import "HomeHotelOrderAddTouristCell.h"
#import "RoomOrderHeaderView.h"
#import "RoomOrderFooterView.h"
#import "Home.h"
#import "PaymentCell.h"
#import "HomeHotelVC.h"
#import "HomeHotelOrderChargesView.h"
#import "HomeHotelOrderChargesCell.h"

@interface HomeHotelOrderVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) HomeShopBaseOrderCommitView *commitView;
@property (nonatomic, weak) RoomOrderHeaderView *headerView;
@property (nonatomic, copy) NSString *dateNum;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, weak) HomeHotelOrderChargesView *chargesView;
@end

@implementation HomeHotelOrderVC

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width, self.view.height-self.commitView.height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    [self setupHeaderView];
    RoomOrderFooterView *roomFooter = [RoomOrderFooterView show];
    tableView.tableFooterView = roomFooter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self setupCommitView];
    [self setupTableView];
    [self addNSNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([CurrentViewController isKindOfClass:[HomeHotelVC class]]) {
        self.navigationController.navigationBar.hidden = NO;
    } else {
        [self.navigationController.navigationBar setBackgroundImage:(iPhoneX) ? SetImage(@"navigationbarBackgroundWhite_X") : SetImage(@"navigationbarBackgroundWhite") forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[NavigationController new].navigationBar.shadowImage];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)setupHeaderView {
    RoomOrderHeaderView *headerView = [RoomOrderHeaderView viewFromXib];
    _headerView = headerView;
    _tableView.tableHeaderView = _headerView;
    _headerView.hotelNameLabel.text = self.hotelName;
    _headerView.roomClassLabel.text = self.roomOrderInfo.room_name;
    NSString *num = [self getDifferenceDate:self.roomOrderInfo.checkTime withOtherDate:self.roomOrderInfo.checkoutTime];
    self.dateNum = num;
    _headerView.roomInfoLabel.text = [NSString stringWithFormat:@"入住时间 %@ - %@ | 共%@晚", self.roomOrderInfo.checkTime, self.roomOrderInfo.checkoutTime, num];
    NSString *breakfast = nil;
    if ([self.roomOrderInfo.breakfast isEqualToString:@"1"]) {
        breakfast = @"含早";
    } else if ([self.roomOrderInfo.breakfast isEqualToString:@"2"]) {
        breakfast = @"不含早";
    }
    _headerView.roomOtherInfoLabel.text = [NSString stringWithFormat:@"%@ | %@", self.roomOrderInfo.room_name, breakfast];
}

-(NSString *)getDifferenceDate:(NSString *)date withOtherDate:(NSString *)otherDate {
    NSString *fmt = @"yyyy-MM-dd";
    NSDate *dateA = [NSDate dateFromStringFormat:date formatter:fmt];
    NSDate *dateB = [NSDate dateFromStringFormat:otherDate formatter:fmt];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    NSCalendarUnit unit = NSCalendarUnitDay;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:dateB toDate:dateA options:0];
    return [NSString stringWithFormat:@"%zd", labs(dateCom.day)];
}

//MARK:添加提交订单
- (void)setupCommitView {
    HomeShopBaseOrderCommitView *commitView = [HomeShopBaseOrderCommitView viewFromXib];
    commitView.y = self.view.height - commitView.height;
    [self.view addSubview:commitView];
    _commitView = commitView;
    _commitView.price = [self.roomOrderInfo.totalPrice floatValue];
    WeakSelf(weakSelf)
    commitView.didTap = ^{
        [LaiMethod alertControllerWithTitle:nil message:@"是否提交当前订单?" defaultActionTitle:@"提交" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
            [weakSelf postAddOrder];
        }];
    };
}

//MARK:下单
-(void)postAddOrder {
    NSString *url = [MainURL stringByAppendingPathComponent:@"home/ticket/order/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[Channel_pot_id] = ChannelPotId;
    params[@"hotel[0][hotel_id]"] = @1;
    params[@"hotel[0][room_id]"] = self.roomOrderInfo.room_id;
    params[@"hotel[0][s_date]"] = self.roomOrderInfo.checkTime;
    params[@"hotel[0][e_date]"] = self.roomOrderInfo.checkoutTime;
    params[@"hotel[0][number]"] = @(self.roomOrderInfo.number);
    params[@"pay_type"] = @"alipay";
    params[@"visitor_id"] = self.userVisitor.biz_visitor_id;
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        [SVProgressHUD showSuccess:@"下单成功"];
    //TODO:下单成功，待支付
    } otherCase:nil failure:nil];
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? self.roomOrderInfo.room_price_detail.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        HomeHotelOrderHeaderCell *cell = [HomeHotelOrderHeaderCell cellFromXibWithTableView:tableView];
        cell.roomOrderInfo = self.roomOrderInfo;
        cell.totalPayForDidChange = ^(CGFloat currentTicketTotalPayFor,NSInteger count) {
            self.totalPrice = currentTicketTotalPayFor;
            self.commitView.price = currentTicketTotalPayFor;
            self.roomOrderInfo.number = count;
            self.roomOrderInfo.totalPrice = [NSString stringWithFormat:@"%.2f",[self.roomOrderInfo.room_price floatValue]*count];
            [self.chargesView fillInfo:self.roomOrderInfo.room_price_detail withPrice:self.roomOrderInfo.totalPrice withCount:self.roomOrderInfo.number];
            [self.tableView reloadData];
        };
        return cell;
    }
    else if(indexPath.section == 1) {
        HomeHotelOrderAddTouristCell *cell = [HomeHotelOrderAddTouristCell cellFromXibWithTableView:tableView];
        cell.userVisitor = self.userVisitor;
        return cell;
    }
    else if(indexPath.section == 2) {
        HomeHotelOrderChargesCell *cell = [HomeHotelOrderChargesCell cellFromXibWithTableView:tableView];
        HomeHotelRoomPriceDetail *detail = self.roomOrderInfo.room_price_detail[indexPath.row];
        [cell fillPriceDetail:detail withCount:self.roomOrderInfo.number];
        return cell;
    }
    else {
        PaymentCell *cell = [PaymentCell cellFromXibWithTableView:tableView];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 2) {
        if (!self.chargesView) {
            self.chargesView = [HomeHotelOrderChargesView viewFromXib];
        }
        [self.chargesView fillInfo:self.roomOrderInfo.room_price_detail withPrice:self.roomOrderInfo.totalPrice withCount:self.roomOrderInfo.number];
        return self.chargesView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 50;
    }
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

#pragma mark - addNSNotification
- (void)addNSNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peopleInfoRealod:) name:NeedAcceptDataNotification object:nil];
}

- (void)peopleInfoRealod:(NSNotification *)notice {
    self.userVisitor = [HomeMuseumUserVisitor mj_objectWithKeyValues:notice.userInfo];
    NSArray *cells = self.tableView.visibleCells;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (id cell in cells) {
        if ([cell isKindOfClass:[HomeHotelOrderAddTouristCell class]]) {
            [indexPaths addObject:[self.tableView indexPathForCell:cell]];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
