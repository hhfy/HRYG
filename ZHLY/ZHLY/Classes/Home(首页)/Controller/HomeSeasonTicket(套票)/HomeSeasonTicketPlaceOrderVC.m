//
//  HomeSeasonTicketPlaceOrderVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeSeasonTicketPlaceOrderVC.h"
#import "Home.h"
#import "HomeSeasonTicketOrderCell.h"
#import "HomeShopBaseOrderAddTouristCell.h"
#import "HomeShopBaseOrderSpecialTicketCell.h"
#import "HomeShopBaseOrderCommitView.h"
#import "PaymentCell.h"
#import "HomeSeasonTicketOrderHeaderView.h"
#import "HomeShoppingCarOrderCell.h"
#import "HomeShopBaseOrderSpecialTicketView.h"

@interface HomeSeasonTicketPlaceOrderVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,copy) NSString *number;
@property(nonatomic,copy) NSString *date;
@property(nonatomic,copy) NSString *biz_pt_id;
@property(nonatomic,copy) NSString *titleText;

@property(nonatomic,strong) HomeSeasonTicketOrderPackage *ticketOrderPackage;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) HomeMuseumUserVisitor *userVisitor;
@property (nonatomic, weak) HomeShopBaseOrderCommitView *commitView;
@property (nonatomic, strong) NSArray *specialTickets;
@property (nonatomic, assign) CGFloat ordinaryTicketPrice;
@property (nonatomic, strong) HomeSeasonTicketOrderHeaderView *headerView;
@end

@implementation HomeSeasonTicketPlaceOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getOrderPackageData)];
    [self addNSNotification];
}

- (void)setupValue {
     self.title = self.titleText;
    self.seasonTicket.buyNum = self.number;
    self.seasonTicket.useDate = self.date;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isPush){
       [self getOrderPackageData];
    }
}
#pragma mark - 接口
//MARK: 获取订单数据
- (void)getOrderPackageData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"tickets/confirm"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Channel_pot_id] = ChannelPotId;
    params[@"biz_pt_id"] = self.biz_pt_id;
    params[@"pt_number"] = self.number;
    params[@"date"] = self.date;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    params[Token] = self.token;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        weakSelf.ticketOrderPackage = [HomeSeasonTicketOrderPackage mj_objectWithKeyValues:json[Data]];
        weakSelf.headerView.orderPackage = weakSelf.ticketOrderPackage;
        weakSelf.userVisitor = weakSelf.ticketOrderPackage.visitor_info;
        [self setupCommitView];
        weakSelf.commitView.price = [weakSelf.ticketOrderPackage.need_pay doubleValue];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.placeholderText = @"";
    tableView.placeholderImage = SetImage(@"没票");
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight * 2, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
    _headerView = [HomeSeasonTicketOrderHeaderView viewFromXib];
    _headerView.title = self.seasonTicket.pt_name;
    _tableView.tableHeaderView = _headerView;
}

- (void)setupCommitView {
    HomeShopBaseOrderCommitView *commitView = [HomeShopBaseOrderCommitView viewFromXib];
    commitView.y = MainScreenSize.height - commitView.height - NavHeight;
    [self.view addSubview:commitView];
    _commitView = commitView;
    WeakSelf(weakSelf)
    commitView.didTap = ^{
        [LaiMethod alertControllerWithTitle:nil message:@"是否提交当前订单?" defaultActionTitle:@"提交" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
            [weakSelf postOrderData];
        }];
    };
}

//MARK: 提交订单数据
- (void)postOrderData {
    if(!self.userVisitor.biz_visitor_id){
        [SVProgressHUD showError:@"请补全游客信息"];
        return;
    }
    NSString *url = [MainURL stringByAppendingPathComponent:@"tickets/pay"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    params[@"pay_type"] = @"1";
    params[@"biz_pt_id"] = self.biz_pt_id;
    params[@"pt_number"] = self.number;
    params[Token] = self.token;
    params[@"biz_visitor_id"] = self.userVisitor.biz_visitor_id;
    params[@"date"] = self.seasonTicket.useDate;
    params[Channel_pot_id] = ChannelPotId;
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"下单成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } otherCase:nil failure:^(NSError *error){
    }];
}


#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ticketOrderPackage ? 4 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? self.ticketOrderPackage.ticket_list.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self homeShopBaseOrderHeaderCellWithTableView:tableView];
    }
    else if(indexPath.section == 1){
        HomeShoppingCarOrderCell *cell = [HomeShoppingCarOrderCell cellFromXibWithTableView:tableView];
        HomeSeasonTicketOrderTicketList *seasonTicket = self.ticketOrderPackage.ticket_list[indexPath.row];
        cell.seasonTicket = seasonTicket;
        return cell;
    }
    else if (indexPath.section == 2) {
        return [self homeShopBaseOrderAddTouristCellWithTableView:tableView];
    }
    else {
        PaymentCell *cell = [PaymentCell cellFromXibWithTableView:tableView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return (section == 1 && self.ticketOrderPackage.ticket_list.count>0) ? 45 : NoneSpace;
    }
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return (section == 1 && self.ticketOrderPackage.ticket_list.count>0) ? SpaceHeight : NoneSpace;
    }
    return SpaceHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeShopBaseOrderSpecialTicketView *sectionHeaderView = [HomeShopBaseOrderSpecialTicketView headerFooterViewFromXibWithTableView:tableView];
    sectionHeaderView.title = @"套票信息";
    return (section == 1 && self.ticketOrderPackage.ticket_list.count>0) ? sectionHeaderView : nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - tableViewCell的封装方法
- (HomeSeasonTicketOrderCell *)homeShopBaseOrderHeaderCellWithTableView:(UITableView *)tableView  {
    HomeSeasonTicketOrderCell *cell = [HomeSeasonTicketOrderCell cellFromXibWithTableView:tableView];
    cell.seasonTicket = self.seasonTicket;
    return cell;
}

- (HomeShopBaseOrderAddTouristCell *)homeShopBaseOrderAddTouristCellWithTableView:(UITableView *)tableView {
    HomeShopBaseOrderAddTouristCell *cell = [HomeShopBaseOrderAddTouristCell cellFromXibWithTableView:tableView];
    cell.userVisitor = self.userVisitor;
    return cell;
}

//- (void)calculationTicketPrice {
//    CGFloat ordinaryTicketPrice = 0;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    HomeSeasonTicketOrderCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    ordinaryTicketPrice = [cell.ticket.pt_ticket_price floatValue];
//    self.commitView.price = ordinaryTicketPrice;
//    self.number = [NSString stringWithFormat:@"%zd",cell.ticket.pt_ticket_num];
////    self.ordinaryTicket.ticket_deadline_text = self.number;
//}

#pragma mark - addNSNotification
- (void)addNSNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPackageData) name:NeedReloadDataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserVisitor:) name:NeedAcceptDataNotification object:nil];
}

- (void)getUserVisitor:(NSNotification *)note {
    self.userVisitor = [HomeMuseumUserVisitor mj_objectWithKeyValues:note.userInfo];
    NSArray *cells = self.tableView.visibleCells;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (id cell in cells) {
        if ([cell isKindOfClass:[HomeShopBaseOrderAddTouristCell class]]) {
            [indexPaths addObject:[self.tableView indexPathForCell:cell]];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
