
//
//  HomeShoppingCarOrderVC.m
//  ZHLY
//  旧的 购物车订单
//  Created by LTWL on 2017/12/20.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShoppingCarOrderVC.h"
#import "HomeShopBaseOrderHeaderCell.h"
#import "HomeShopBaseOrderSpecialTicketCell.h"
#import "HomeShopBaseOrderAddTouristCell.h"
#import "HomeShopBaseOrderCommitView.h"
#import "HomeShoppingCarOrderCell.h"
#import "Home.h"

@interface HomeShoppingCarOrderVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *ordinaryTickets;
@property (nonatomic, strong) NSArray *specialTickets;
@property (nonatomic, strong) NSArray *hotelRooms;
@property (nonatomic, strong) HomeMuseumUserVisitor *userVisitor;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property (nonatomic, weak) HomeShopBaseOrderCommitView *commitView;
@end

@implementation HomeShoppingCarOrderVC

- (NSMutableArray *)selectedIndexPaths
{
    if (_selectedIndexPaths == nil)
    {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return _selectedIndexPaths;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self setupCommitView];
    [self getShoppingCarOrderData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getShoppingCarOrderData)];
    [self addNSNotification];
}

- (void)setupValue {
    self.title = @"确认订单";
}

- (void)setupCommitView {
    HomeShopBaseOrderCommitView *commitView = [HomeShopBaseOrderCommitView viewFromXib];
    commitView.hidden = YES;
    commitView.y = self.view.height - commitView.height - NavHeight;
    [self.view addSubview:commitView];
    _commitView = commitView;
    WeakSelf(weakSelf)
    commitView.didTap = ^{
        if (weakSelf.userVisitor.biz_visitor_id) {
            [LaiMethod alertControllerWithTitle:nil message:@"是否提交当前订单?" defaultActionTitle:@"提交" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
                [weakSelf postOrderData];
            }];
        } else {
            [SVProgressHUD showError:@"请选择游客"];
        }
    };
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 20;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight * 2, 0);
    tableView.placeholderImage = SetImage(@"购物车还是空的~");
    tableView.placeholderText = @"";
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
// 获取购物车提交所产生的订单数据
- (void)getShoppingCarOrderData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"home/ticket/order/confirm"];
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:self.params isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.ordinaryTickets = [HomeTicket mj_objectArrayWithKeyValuesArray:json[Data][@"ticket_list"]];
        weakSelf.specialTickets = [HomeTicket mj_objectArrayWithKeyValuesArray:json[Data][@"ticket_link_list"]];
        weakSelf.hotelRooms = [HomeShoppingCarHotel mj_objectArrayWithKeyValuesArray:json[Data][@"room_list"]];
        weakSelf.userVisitor = [HomeMuseumUserVisitor mj_objectWithKeyValues:json[Data][@"user_visitor"]];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
        weakSelf.commitView.hidden = (!self.ordinaryTickets.count && !self.hotelRooms.count);
        [weakSelf calculationtotalPriceData];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

// 提交订单数据
- (void)postOrderData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"home/ticket/order/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:self.params];
    [params addEntriesFromDictionary:self.postParams];
    params[@"pay_type"] = @"alipay";
    params[@"visitor_id"] = self.userVisitor.biz_visitor_id;
    
    if (self.specialTickets.count) {
        NSString *specialTicketIDParamsName = nil;
        NSString *specialTicketDateParamsName = nil;
        NSString *specialTicketNOParamsName = nil;
        NSArray *cells = self.tableView.visibleCells;
        for (NSInteger i = 0; i < cells.count; i++) {
            id cell = cells[i];
            if ([cell isKindOfClass:[HomeShopBaseOrderSpecialTicketCell class]]) {
                HomeShopBaseOrderSpecialTicketCell *specialTicketCell = (HomeShopBaseOrderSpecialTicketCell *)cell;
                if (specialTicketCell.openType == CellOpenTypeOpen) {
                    specialTicketIDParamsName = [NSString stringWithFormat:@"ticket_id[%zd][id]", i + self.ordinaryTickets.count - 1];
                    specialTicketDateParamsName = [NSString stringWithFormat:@"ticket_id[%zd][date]", i + self.ordinaryTickets.count - 1];
                    specialTicketNOParamsName = [NSString stringWithFormat:@"ticket_id[%zd][number]", i + self.ordinaryTickets.count - 1];
                    params[specialTicketIDParamsName] = specialTicketCell.ticket.biz_ticket_id;
                    params[specialTicketDateParamsName] = specialTicketCell.ticket.date;
                    params[specialTicketNOParamsName] = @(specialTicketCell.ticket.ticket_num);
                }
            }
        }
    }
    
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        
    } otherCase:nil failure:nil];
}


#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (!self.ordinaryTickets.count && !self.hotelRooms.count && !self.userVisitor) ? 0 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return self.ordinaryTickets.count;
        }
            break;
        case 1:
        {
            return self.specialTickets.count;
        }
            break;
        case 2:
        {
            return self.hotelRooms.count;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.section == 1) {
       return [self homeShopBaseOrderSpecialTicketCellWithIndexPath:indexPath];
   } else if (indexPath.section == (self.tableView.numberOfSections - 1)) {
       return [self homeShopBaseOrderAddTouristCellTicketCellWithIndexPath:indexPath];
   } else {
       return [self homeShoppingCarOrderCellTicketCellWithIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ([tableView numberOfRowsInSection:section] == 0 || section == 1) ? NoneSpace : SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

#pragma mark - tableViewCell封装方法
- (HomeShopBaseOrderSpecialTicketCell *)homeShopBaseOrderSpecialTicketCellWithIndexPath:(NSIndexPath *)indexPath {
    HomeShopBaseOrderSpecialTicketCell *cell = [HomeShopBaseOrderSpecialTicketCell cellFromXibWithTableView:self.tableView];
    HomeTicket *ticket = self.specialTickets[indexPath.row];
    cell.ticket = ticket;
    cell.selectIndexPath = indexPath;
    WeakSelf(weakSelf)
    cell.openType = ([weakSelf.selectedIndexPaths containsObject:indexPath]) ? CellOpenTypeOpen : CellOpenTypeClose;
    cell.didSelected = ^(NSIndexPath *selectIndexPath, BOOL isSelected,NSInteger count) {
        if (isSelected) {
            if (![weakSelf.selectedIndexPaths containsObject:indexPath]) [weakSelf.selectedIndexPaths addObject:selectIndexPath];
        } else {
            if ([weakSelf.selectedIndexPaths containsObject:indexPath]) [weakSelf.selectedIndexPaths removeObject:selectIndexPath];
        }
        [weakSelf.tableView reloadData];
    };
    cell.countDidChange = ^(NSInteger count ,BOOL isSelected,NSIndexPath *selectIndexPath) {
        [weakSelf calculationtotalPriceData];
    };
    return cell;
}

- (HomeShoppingCarOrderCell *)homeShoppingCarOrderCellTicketCellWithIndexPath:(NSIndexPath *)indexPath {
    HomeShoppingCarOrderCell *cell = [HomeShoppingCarOrderCell cellFromXibWithTableView:self.tableView];
    if (indexPath.section == 0) {
        HomeShoppingCarTicket *ticket = self.ordinaryTickets[indexPath.row];
        cell.ticket = ticket;
    } else {
        HomeShoppingCarHotel *hotel = self.hotelRooms[indexPath.row];
        cell.hotel = hotel;
    }
    return cell;
}

- (HomeShopBaseOrderAddTouristCell *)homeShopBaseOrderAddTouristCellTicketCellWithIndexPath:(NSIndexPath *)indexPath {
    HomeShopBaseOrderAddTouristCell *cell = [HomeShopBaseOrderAddTouristCell cellFromXibWithTableView:self.tableView];
    cell.userVisitor = self.userVisitor;
    return cell;
}

#pragma mark - 计算当前总价
- (void)calculationtotalPriceData {
    CGFloat ticketPrice = 0.f;
    CGFloat hotelPrice = 0.f;
    CGFloat specialTicketPrice = 0.f;
    
    NSArray *cells = self.tableView.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        id cell = cells[i];
        if ([cell isKindOfClass:[HomeShoppingCarOrderCell class]]) {
            HomeShoppingCarOrderCell *orderCell = (HomeShoppingCarOrderCell *)cell;
            if (orderCell.ticket) ticketPrice += orderCell.ticket.totalPrice;
            if (orderCell.hotel) hotelPrice += orderCell.hotel.totalPrice;
        } else if ([cell isKindOfClass:[HomeShopBaseOrderSpecialTicketCell class]]) {
            HomeShopBaseOrderSpecialTicketCell *specialTicketCell = (HomeShopBaseOrderSpecialTicketCell *)cell;
            specialTicketPrice += specialTicketCell.ticket.need_pay;
        }
    }
    self.commitView.price = ticketPrice + hotelPrice + specialTicketPrice;
}

#pragma mark - addNSNotification
- (void)addNSNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShoppingCarOrderData) name:NeedReloadDataNotification object:nil];
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
