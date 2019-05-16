//
//  HomeHotelVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/19.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHotelVC.h"
#import "HomeHotelHeaderView.h"
#import "HomeHotelRoomCell.h"
#import "Home.h"
#import "RoomListSectionHeaderView.h"
#import "HomeShopBaseCell.h"
#import "HomeShopBaseDownSheetView.h"

@interface HomeHotelVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) HomeHotelHeaderView *headerView;
//@property (nonatomic, strong) HomeHotelInfo *hotelInfo;
@property (nonatomic, strong) NSMutableArray *roomList;
@property (nonatomic, strong) HomeHotelRoomInfo *roomInfo;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *indexPaths;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, weak) RoomListSectionHeaderView *dateView;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) HomeMuseumInfo *museumInfo;
@property (nonatomic, copy) NSString *hotelId;
@property (nonatomic, strong) HomeTicket *ticket;
@property (nonatomic, strong) NSArray *tickets;
@end

@implementation HomeHotelVC

- (NSMutableArray *)indexPaths {
    if (_indexPaths == nil) {
        _indexPaths = [NSMutableArray array];
    }
    return _indexPaths;
}

- (NSMutableArray *)roomList {
    if (_roomList == nil) {
        _roomList = [NSMutableArray array];
    }
    return _roomList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)naviShowNotice {
    [self.navigationController.navigationBar setBackgroundImage:(iPhoneX) ? SetImage(@"navigationbarBackgroundWhite_X") : SetImage(@"navigationbarBackgroundWhite") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UINavigationController new].navigationBar.shadowImage];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeaderView];
    [self setupTableView];
    [self getHotelInfoData];
//    [self getNewRoomsData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewRoomsData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getMoreRoomsData)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(naviShowNotice) name:@"HomeHotelVCNavShowNotification" object:nil];
}

- (void)setHeaderView {
    HomeHotelHeaderView *headerView = [HomeHotelHeaderView viewFromXib];
    [self.view addSubview:headerView];
    _headerView = headerView;
    WeakSelf(weakSelf)
    headerView.didSelectedDate = ^(NSDate *selectedDate) {
        weakSelf.selectedDate = selectedDate;
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY, self.view.width, self.view.height - self.headerView.height) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 20;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight, 0);
    tableView.placeholderText = @"暂无房间信息";
    tableView.placeholderImage = SetImage(@"暂无商品");
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupHeaderData {
    HomeShopBaseInfo *info = [HomeShopBaseInfo new];
    info.date = self.museumInfo.date;
    info.banner = self.museumInfo.scene_image;
    info.bannerCount = self.museumInfo.scene_photo_album_count;
    info.shopName = self.museumInfo.scene_name;
    info.address = self.museumInfo.scene_address;
    info.scene_latitude = self.museumInfo.scene_latitude;
    info.scene_longitude = self.museumInfo.scene_longitude;
    info.commentCount = [self.museumInfo.scene_evaluate_num integerValue];
    info.shopId = self.museumInfo.supplier_scene_id;
    NSString *museumUrl = [NSString stringWithFormat:@"scene/detail/%@?channel_pot_id=%@",self.key,ChannelPotId];
    info.detialApi = [MainURL stringByAppendingPathComponent:museumUrl];
    self.headerView.info = info;
}
#pragma mark - 接口
//MARK: 获取酒店信息数据
- (void)getHotelInfoData {
    NSString *museumUrl = [NSString stringWithFormat:@"scene/index/%@",self.key];
    NSString *url = [MainURL stringByAppendingPathComponent:museumUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
         weakSelf.museumInfo = [HomeMuseumInfo mj_objectWithKeyValues:json[Data]];
        weakSelf.hotelId = weakSelf.museumInfo.biz_hotel_id;
        if(weakSelf.museumInfo){
            [weakSelf setupHeaderData];
            [self getNewRoomsData];
        }
        if(weakSelf.museumInfo.date.count>0){
        }
        else {
            [self.tableView reloadData];
        }
    } otherCase:^(NSInteger code) {
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
    }];
}

// 获取房间数据
- (void)getNewRoomsData {
    self.currentPage = 1;
    [self getHotelRoomData];
}

- (void)getMoreRoomsData {
    self.currentPage++;
    [self getHotelRoomData];
}

//MARK: 获取酒店房间列表
- (void)getHotelRoomData {
    NSString *date = [NSString stringFormDateFromat:[NSDate localDate] formatter:FmtYMD];
    NSString *museumUrl = [NSString stringWithFormat:@"/ticket/index/%@/%@",self.key,date];
    NSString *url = [MainURL stringByAppendingPathComponent:museumUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Channel_pot_id] = ChannelPotId;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        weakSelf.tickets = [HomeTicket mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeShopBaseCell *cell = [HomeShopBaseCell cellFromXibWithTableView:tableView];
    HomeTicket *ticket = self.tickets[indexPath.row];
    cell.ticket = ticket;
    WeakSelf(weakSelf)
    cell.addShoppingCar = ^(NSInteger count) {
        weakSelf.ticket = ticket;
        weakSelf.count = count;
        [self postAddShoppingCarRequeset:ticket with:YES];
    };
    cell.payfor = ^{
        HomeShopBaseDownSheetView *shoppingCarSheetView = [HomeShopBaseDownSheetView viewFromXib];
        [shoppingCarSheetView show];
        shoppingCarSheetView.dismissCallBack = ^(NSInteger count,NSInteger tag) {
            ticket.totalCount = count;
            weakSelf.count = count;
            if(tag == 0){
                self.count = count;
                [self postAddShoppingCarRequeset:ticket with:YES];
            }
            else {
                [self postAddShoppingCarRequeset:ticket with:NO];
            }
        };
    };
    return cell;
    
//    HomeHotelRoomCell *cell = [HomeHotelRoomCell cellFromXibWithTableView:tableView];
////    HomeMuseumSeasonTickets *seasonTicket = self.seasonTickets[indexPath.row];
////    cell.seasonTicket = seasonTicket;
////    HomeHotelRoomInfo *room = self.roomList[indexPath.row];／
////    cell.roomInfo = room;
////    cell.hotelInfo = self.hotelInfo;
//    WeakSelf(weakSelf)
//    cell.addShoppingCar = ^(HomeHotelRoomInfo *roomInfo, NSInteger count) {
//        weakSelf.roomInfo = room;
//        weakSelf.count = count;
////        [self postAddShoppingCarRequeset:ticket with:NO];
//    };
//    cell.addRoomOrder = ^(HomeHotelRoomInfo *roomInfo, NSInteger count) {
//        weakSelf.roomInfo = room;
//        weakSelf.count = count;
////        [self postAddShoppingCarRequeset:ticket with:YES];
//    };
//    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RoomListSectionHeaderView *headerView = [RoomListSectionHeaderView show];
    _dateView = headerView;
    return headerView;
}

#pragma mark - 加入购物车
- (void)postAddShoppingCarRequeset:(HomeTicket *)ticket with:(BOOL)joinCar {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"biz_ticket_id"] = ticket.biz_ticket_id;
    dic[@"ticket_lock_num"] = @((self.count) ? self.count : 1);
    dic[@"start_date"] = self.dateView.checkTime;
    dic[@"end_date"] = self.dateView.checkoutTime;
    NSMutableArray *arr = [NSMutableArray arrayWithObject:dic];
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *url = [MainURL stringByAppendingPathComponent:@"cart/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ticket_list"] = json;
    params[Token] = self.token;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        NSArray *carArr = [HomeShoppingCarTicket mj_objectArrayWithKeyValuesArray:json[Data]];
        if (joinCar) {
            [SVProgressHUD showSuccess:@"添加购物车成功"];
        }
        else {
//            HomeShoppingCarTicket *ticket0 = [[HomeShoppingCarTicket alloc]init];
//
//            ticket0 = (HomeShoppingCarTicket *)ticket;
//
//            NSArray *carArr1 = [NSArray arrayWithObject:ticket0];
            [weakSelf directBuy:ticket with:carArr];
        }
    } otherCase:nil failure:^(NSError *error){
    }];
}

#pragma mark - 直接购买
-(void)directBuy:(HomeTicket *)ticket with:(NSArray *)carArr {
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionary];
    requestParams[@"ticket[0][ticket_number]"] = @(self.count);
    requestParams[@"ticket[0][biz_ticket_id]"] = ticket.biz_ticket_id;
    requestParams[Channel_pot_id] = ChannelPotId;
    requestParams[@"sign"] = [LaiMethod getSign];
    requestParams[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    requestParams[Token] = self.token;
    if(self.dateView.checkTime && self.dateView.checkoutTime){
        requestParams[@"ticket[0][start_date]"] = self.dateView.checkTime;
        requestParams[@"ticket[0][end_date]"] = self.dateView.checkoutTime;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithObject:requestParams];
    //
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ticket.start_date = self.dateView.checkTime;
    ticket.end_date = self.dateView.checkoutTime;
    params[@"ordinaryTicket"] = ticket;
    params[@"ordinaryTicketArr"] = carArr;
    params[@"paramsArr"] = arr;
//    params[@"ticket[0][start_date]"] = self.dateView.checkTime;
//    params[@"ticket[0][end_date]"] = self.dateView.checkoutTime;
    [LaiMethod runtimePushVcName:@"HomeShopBaseOrderVC" dic:params nav:self.navigationController];
}


@end
