//
//  HomeShoppingVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShoppingCarVC.h"
#import "HomeShoppingCarTicketCell.h"
#import "HomeShoppingCarHotelCell.h"
#import "HomeShoppingCarCommitView.h"
#import "Home.h"
#import "HomeShoppingCarSectionHeaderView.h"
#import "HomeShoppingCarOrderVC.h"

@interface HomeShoppingCarVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) HomeShoppingCarCommitView *commitView;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property (nonatomic, strong) NSMutableArray *tickets;
@property (nonatomic, strong) NSMutableArray *hotels;
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) BOOL isJustOnlySection;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *postParams;
@end

@implementation HomeShoppingCarVC
- (NSMutableArray *)selectedIndexPaths {
    if (_selectedIndexPaths == nil) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return _selectedIndexPaths;
}

- (NSMutableDictionary *)params {
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (NSMutableDictionary *)postParams {
    if (_postParams == nil) {
        _postParams = [NSMutableDictionary dictionary];
    }
    return _postParams;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTableView];
    [self setupCommitView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getShoppingCarData)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if(self.isPush){
        [self getShoppingCarData];
//    }
}

- (void)setupValue {
    self.title = @"购物车";
    self.isJustOnlySection = NO;
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(deleteAction) title:[NSString stringWithFormat:@"%@ 删除", DelettIconUnicode] nomalColor:SetupColor(102, 102, 102) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(15) top:0 left:0 bottom:0 right:0];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)setupCommitView {
    HomeShoppingCarCommitView *commitView = [HomeShoppingCarCommitView viewFromXib];
    commitView.y = self.view.height - commitView.height - ((iPhoneX) ? NavHeightIphoneX : NavHeight);
    commitView.hidden = YES;
    [self.view addSubview:commitView];
    _commitView = commitView;
    WeakSelf(weakSelf) 
    commitView.checkAll = ^(BOOL isCheckAll) {
        [weakSelf checkAllWithIsCheckAll:isCheckAll];
    };
    commitView.commit = ^ {
        NSInteger index = 0;
        for (NSIndexPath *indexPath in weakSelf.selectedIndexPaths) {
            if (weakSelf.tickets.count) {
                if (indexPath.section == 0) {
                    [weakSelf addTicketParamsWithIndexPath:indexPath index:index];
                } else {
                    [weakSelf addHotelParamsWithIndexPath:indexPath index:index - self.tickets.count];
                }
            } else {
                [weakSelf addHotelParamsWithIndexPath:indexPath index:index];
            }
            index++;
        }
        weakSelf.params[Token] = weakSelf.token;;
        weakSelf.params[@"sign"] = [LaiMethod getSign];
        weakSelf.params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
        weakSelf.params[Channel_pot_id] = ChannelPotId;
        
        HomeShoppingCarOrderVC *shoppingCarOrderVc = [HomeShoppingCarOrderVC new];
        shoppingCarOrderVc.params = weakSelf.params;
        shoppingCarOrderVc.postParams = weakSelf.postParams;
        NSMutableArray *arr = [NSMutableArray arrayWithObject:self.params];
        if (weakSelf.selectedIndexPaths.count) {
            [weakSelf directBuy:arr];
        } else {
            [SVProgressHUD showError:@"请选择商品"];
        }
    };
}

//MARK:直接购买(购物车)
-(void)directBuy:(NSArray *)arr {
    NSMutableArray *arr1 = [NSMutableArray arrayWithObject:self.params];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *ticketsArr = [NSMutableArray array];
    for(NSIndexPath *indexPath in self.selectedIndexPaths){
        for (int i=0;i<self.tickets.count;i++) {
            if (indexPath.row == i) {
                [ticketsArr addObject:self.tickets[i]];
            }
        }
    }
    params[@"ordinaryTicketArr"] = ticketsArr;
    params[@"paramsArr"] = arr1;
    [LaiMethod runtimePushVcName:@"HomeShopCarOrderNewVC" dic:params nav:self.navigationController];
}


- (void)addTicketParamsWithIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index {
    NSString *paramsTickeIdName = nil;
    NSString *paramsTickeNumberName = nil;
    NSString *paramsHotelStartDateName = nil;
    NSString *paramsHotelEndDateName = nil;
    HomeShoppingCarTicketCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    paramsTickeIdName = [NSString stringWithFormat:@"ticket[%zd][biz_ticket_id]", index];
    paramsTickeNumberName = [NSString stringWithFormat:@"ticket[%zd][ticket_number]", index];
    paramsHotelStartDateName = [NSString stringWithFormat:@"ticket[%zd][start_date]", index];
    paramsHotelEndDateName = [NSString stringWithFormat:@"ticket[%zd][end_date]", index];
    self.params[paramsTickeIdName] = cell.ticket.biz_ticket_id;
    self.params[paramsTickeNumberName] = @(cell.ticket.totalCount);
    if(cell.ticket.start_date && cell.ticket.end_date){
        self.params[paramsHotelStartDateName] = cell.ticket.start_date;
        self.params[paramsHotelEndDateName] = cell.ticket.end_date;
    }
}

//酒店舍弃了，下面代码未修改过（旧）
- (void)addHotelParamsWithIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index {
    NSString *paramsHotelIdName = nil;
    NSString *paramsRoomIdName = nil;
    NSString *paramsHotelNumberName = nil;
    NSString *paramsHotelStartDateName = nil;
    NSString *paramsHotelEndDateName = nil;
    NSString *paramsTicketCartIdName = nil;
    HomeShoppingCarHotelCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    paramsHotelIdName = [NSString stringWithFormat:@"hotel[%zd][hotel_id]", index];
    paramsRoomIdName = [NSString stringWithFormat:@"hotel[%zd][room_id]", index];
    paramsHotelNumberName = [NSString stringWithFormat:@"hotel[%zd][number]", index];
    paramsHotelStartDateName = [NSString stringWithFormat:@"hotel[%zd][s_date]", index];
    paramsHotelEndDateName = [NSString stringWithFormat:@"hotel[%zd][e_date]", index];
    paramsTicketCartIdName = [NSString stringWithFormat:@"ticket_cart_id[%zd]", index + self.tickets.count];
    self.params[paramsHotelIdName] = cell.hotel.hotel_id;
    self.params[paramsRoomIdName] = cell.hotel.room_id;
    self.params[paramsHotelNumberName] = @(cell.hotel.totalCount);
    self.params[paramsHotelStartDateName] = cell.hotel.room_start_time;
    self.params[paramsHotelEndDateName] = cell.hotel.room_end_time;
    self.postParams[paramsTicketCartIdName] = cell.hotel.biz_cart_id;
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
    tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, SpaceHeight)];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
}

// 全选和全取消
- (void)checkAllWithIsCheckAll:(BOOL)isCheckAll {
    for (int i = 0; i < self.tickets.count; i++) {
        if (self.tickets.count) [self checkAllTicketWithisCheckAll:isCheckAll index:i];
    }
    for (int i = 0; i < self.hotels.count; i++) {
        [self checkAllHotelWithisCheckAll:isCheckAll index:i];
    }
    if (!isCheckAll) [self.selectedIndexPaths removeAllObjects];
    self.commitView.isCheckAll = isCheckAll;
    if (!self.commitView.hidden) self.navigationItem.rightBarButtonItem.enabled = isCheckAll;
    [self calculationCurrentSelectedData];
}

- (void)checkAllTicketWithisCheckAll:(BOOL)isCheckAll index:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    HomeShoppingCarTicketCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.isSelectedStatus = isCheckAll;
    if (isCheckAll && ![self.selectedIndexPaths containsObject:indexPath]) [self.selectedIndexPaths addObject:indexPath];
}

- (void)checkAllHotelWithisCheckAll:(BOOL)isCheckAll index:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    HomeShoppingCarHotelCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.isSelectedStatus = isCheckAll;
    if (isCheckAll && ![self.selectedIndexPaths containsObject:indexPath]) [self.selectedIndexPaths addObject:indexPath];
}

// 计算当前选中的总价和总数量
- (void)calculationCurrentSelectedData {
    NSInteger ticketCount = 0;
    CGFloat ticketPrice = 0.f;
    NSInteger hotelCount = 0;
    CGFloat hotelPrice = 0.f;
    
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        id cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[HomeShoppingCarTicketCell class]]) {
            HomeShoppingCarTicketCell *ticketCell = (HomeShoppingCarTicketCell *)cell;
            HomeShoppingCarTicket *ticket = ticketCell.ticket;
            ticketPrice += ticket.totalPrice;
            ticketCount += ticket.totalCount;
        } else if ([cell isKindOfClass:[HomeShoppingCarHotelCell class]]) {
            HomeShoppingCarHotelCell *hotelCell = (HomeShoppingCarHotelCell *)cell;
            HomeShoppingCarHotel *ticket = hotelCell.hotel;
            hotelPrice += ticket.totalPrice;
            hotelCount += ticket.totalCount;
        }
    }
    self.commitView.currentPrice = ticketPrice + hotelPrice;
    self.commitView.goodsCount = ticketCount + hotelCount;
}

#pragma mark - 接口
//MARK: 获取购物车数据
- (void)getShoppingCarData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"cart/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;

    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        weakSelf.tickets = [HomeShoppingCarTicket mj_objectArrayWithKeyValuesArray:json[Data]];
        [weakSelf updateData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf checkAllWithIsCheckAll:YES];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

// 删除商品
- (void)postDeleteGoodsRequestWithComplete:(void (^)(void))complete {
    NSString *url = [MainURL stringByAppendingPathComponent:@"cart/remove"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    NSInteger index = 0;
    NSMutableArray *ticArr = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        switch (indexPath.section) {
            case 0:
            {
                HomeShoppingCarTicket *ticket = self.tickets[indexPath.row];
                [ticArr addObject:ticket.biz_cart_id];
            }
                break;
            case 1:
            {
//                paramsName = [NSString stringWithFormat:@"ticket_cart_id[%zd]", index + self.tickets.count - 1];
//                HomeShoppingCarHotel *hotel = self.hotels[indexPath.row];
//                params[paramsName] = hotel.biz_cart_id;
            }
            default:
                break;
        }
        index++;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:ticArr options:kNilOptions error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    params[@"biz_cart_ids"] = json;
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        if (complete) complete();
    } otherCase:nil failure:nil];
}

- (void)updateData {
    self.commitView.hidden = (self.tickets.count == 0 && self.hotels.count == 0);
    if (self.tickets.count && self.hotels.count) {
        self.isJustOnlySection = NO;
        self.sectionCount = 2;
    } else if (!self.tickets.count && !self.hotels.count) {
        self.sectionCount = 0;
    } else {
        self.isJustOnlySection = YES;
        self.sectionCount = 1;
    }
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.tickets.count;
            break;
        case 1:
            return self.hotels.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self homeShoppingCarTicketCellWithTableView:tableView indexPath:indexPath];
    } else {
        return [self homeShoppingCarHotelCellWithTableView:tableView indexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeShoppingCarSectionHeaderView *header = [HomeShoppingCarSectionHeaderView headerFooterViewFromXibWithTableView:tableView];
    switch (section) {
        case 0:
            header.title = (self.tickets.count) ? @"门票" : @"酒店";
            header.icon = (self.tickets.count) ? @"门票" : @"酒店";
            break;
        case 1:
            header.title = @"酒店";
            header.icon = @"酒店";
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;//([tableView numberOfRowsInSection:section] == 0) ? NoneSpace : 47;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - tableView数据源和代理方法封装区域(门票)
- (HomeShoppingCarTicketCell *)homeShoppingCarTicketCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    HomeShoppingCarTicketCell *cell = [HomeShoppingCarTicketCell cellFromXibWithTableView:tableView];
    HomeShoppingCarTicket *ticket = self.tickets[indexPath.row];
    cell.ticket = ticket;
    cell.indexPath = indexPath;
    cell.isSelectedStatus = ([self.selectedIndexPaths containsObject:indexPath]);
    WeakSelf(weakSelf)
    cell.changeStatus = ^(NSIndexPath *indexPath, BOOL isSelected) {
        if (isSelected) {
            if (![weakSelf.selectedIndexPaths containsObject:indexPath]) [weakSelf.selectedIndexPaths addObject:indexPath];
            if (weakSelf.selectedIndexPaths.count > 0) weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
            weakSelf.commitView.isCheckAll = (weakSelf.selectedIndexPaths.count == (weakSelf.tickets.count + weakSelf.hotels.count));
        } else {
            if ([weakSelf.selectedIndexPaths containsObject:indexPath]) [weakSelf.selectedIndexPaths removeObject:indexPath];
            if (weakSelf.selectedIndexPaths.count == 0) weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
            weakSelf.commitView.isCheckAll = NO;
        }
        [weakSelf calculationCurrentSelectedData];
    };
    return cell;
}

- (HomeShoppingCarHotelCell *)homeShoppingCarHotelCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath  {
    HomeShoppingCarHotelCell *cell = [HomeShoppingCarHotelCell cellFromXibWithTableView:tableView];
    HomeShoppingCarHotel *hotel = self.hotels[indexPath.row];
    cell.hotel = hotel;
    cell.indexPath = indexPath;
    cell.isSelectedStatus = ([self.selectedIndexPaths containsObject:indexPath]);
    WeakSelf(weakSelf)
    cell.changeStatus = ^(NSIndexPath *indexPath, BOOL isSelected) {
        if (isSelected) {
            if (![weakSelf.selectedIndexPaths containsObject:indexPath]) [weakSelf.selectedIndexPaths addObject:indexPath];
            if (weakSelf.selectedIndexPaths.count > 0) weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
            weakSelf.commitView.isCheckAll = (weakSelf.selectedIndexPaths.count == (weakSelf.tickets.count + weakSelf.hotels.count));
        } else {
            if ([weakSelf.selectedIndexPaths containsObject:indexPath]) [weakSelf.selectedIndexPaths removeObject:indexPath];
            if (weakSelf.selectedIndexPaths.count == 0) weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
            weakSelf.commitView.isCheckAll = NO;
        }
        [weakSelf calculationCurrentSelectedData];
    };
    return cell;
}

#pragma mark - deleteAction
- (void)deleteAction {
    WeakSelf(weakSelf)
    [LaiMethod alertSPAlerSheetControllerWithTitle:nil message:@"删除购物车中对应商品？" defaultActionTitles:nil destructiveTitle:@"删除" cancelTitle:@"取消" handler:^(NSInteger actionIndex) {
        [weakSelf postDeleteGoodsRequestWithComplete:^{
            NSMutableArray *deleteObjects = [NSMutableArray array];
            for (NSIndexPath *indexPath in weakSelf.selectedIndexPaths) {
                switch (indexPath.section) {
                    case 0:
                        if (weakSelf.tickets.count) [deleteObjects addObject:weakSelf.tickets[indexPath.row]];
                        break;
                    case 1:
                        if (weakSelf.hotels.count) [deleteObjects addObject:weakSelf.hotels[indexPath.row]];
                        break;
                    default:
                        break;
                }
            }
            [weakSelf.tickets removeObjectsInArray:deleteObjects];
            [weakSelf.hotels removeObjectsInArray:deleteObjects];
            weakSelf.commitView.hidden = (weakSelf.tickets.count + weakSelf.hotels.count == 0);
            weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
            [weakSelf.tableView deleteRowsAtIndexPaths:weakSelf.selectedIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.selectedIndexPaths removeAllObjects];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 0.8) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf getShoppingCarData];
            });
        }];
        
    }];
}

@end
