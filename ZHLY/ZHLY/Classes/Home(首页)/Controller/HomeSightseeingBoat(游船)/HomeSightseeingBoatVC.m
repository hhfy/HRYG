
//
//  HomeSightseeingBoatVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeSightseeingBoatVC.h"
#import "Home.h"
#import "HomeShopBaseCell.h"
#import "HomeShopBaseSectionHeaderView.h"

@interface HomeSightseeingBoatVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HomeMuseumInfo *museumInfo;
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) HomeTicket *ticket;
@property (nonatomic, strong) NSMutableArray *indexPaths;
@property (nonatomic, assign) NSInteger count;
@end

@implementation HomeSightseeingBoatVC

- (NSMutableArray *)indexPaths {
    if (_indexPaths == nil) {
        _indexPaths = [NSMutableArray array];
    }
    return _indexPaths;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fromTravels = NO;
    [self setupValue];
    [self getMuseumInfoData];
    [self getMuseumTicketData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getMuseumTicketData)];
}

- (void)setupValue {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    WeakSelf(weakSelf)
    self.headerView.didSelectedDate = ^(NSDate *selectedDate) {
        weakSelf.selectedDate = selectedDate;
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

#pragma mark - 接口
// 获取游船信息数据
- (void)getMuseumInfoData {
    NSString *museumUrl = [NSString stringWithFormat:@"scene/index/%@",self.key];
    NSString *url = [MainURL stringByAppendingPathComponent:museumUrl];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"id"] = @1;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:nil isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.museumInfo = [HomeMuseumInfo mj_objectWithKeyValues:json[Data]];
        [weakSelf setupHeaderData];
    } otherCase:nil failure:nil];
}

// 获取门票列表
- (void)getMuseumTicketData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"home/ticket/info/ticket_list"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"shop_id"] = @1;
    params[Channel_pot_id] = ChannelPotId;
    params[@"date"] = (self.selectedDate) ? [NSString stringFormDateFromat:self.selectedDate formatter:FmtYMD] : [NSString stringFormDateFromat:[NSDate localDate] formatter:FmtYMD];
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
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

// 添加购物车
- (void)postAddShoppingCarRequeset {
    NSString *url = [MainURL stringByAppendingPathComponent:@"home/ticket/cart/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ticket_id"] = self.ticket.biz_ticket_id;
    params[@"nums"] = @((self.count) ? self.count : 1);
    params[Token] = self.token;
    params[@"date"] = (self.selectedDate) ? [NSString stringFormDateFromat:self.selectedDate formatter:FmtYMD] : [NSString stringFormDateFromat:[NSDate localDate] formatter:FmtYMD];
    
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        [SVProgressHUD showSuccess:@"添加购物车成功"];
    } otherCase:nil failure:nil];
}

- (void)setupHeaderData {
    HomeShopBaseInfo *info = [HomeShopBaseInfo new];
    info.banner = self.museumInfo.scene_image;
//    info.bannerCount = self.museumInfo.shop_image_number;
    info.shopName = self.museumInfo.scene_name;
    info.address = self.museumInfo.scene_address;
    info.commentCount = 1233;
    info.leftViewTitle = @"景点介绍";
    info.leftViewDetialText = @"开放时间、注意事项";
    info.shopId = @"1";
    info.startCount = 3.5;
    info.detialApi = [MainURL stringByAppendingPathComponent:@"home/shop/detail/index"];
    self.headerView.info = info;
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
        [weakSelf postAddShoppingCarRequeset];
    };
    cell.payfor = ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"ticketId"] = ticket.biz_ticket_id;
        params[@"buyCount"] = @1;
        params[@"date"] = (weakSelf.selectedDate) ? [NSString stringFormDateFromat:weakSelf.selectedDate formatter:FmtYMD] : [NSString stringFormDateFromat:[NSDate localDate] formatter:FmtYMD];
        [LaiMethod runtimePushVcName:@"HomeShopBaseOrderVC" dic:params nav:weakSelf.navigationController];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeShopBaseSectionHeaderView *header = [HomeShopBaseSectionHeaderView headerFooterViewFromXibWithTableView:tableView];
    return (self.tickets) ? header : nil;
}


@end
