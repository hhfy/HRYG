//
//  HomeMuseumVC.m
//  ZHLY
//  非选座类景点
//  Created by LTWL on 2017/12/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeMuseumVC.h"
#import "HomeShopBaseCell.h"
#import "HomeShopBaseSectionHeaderView.h"
#import "Home.h"
#import "payRequsestHandler.h"
#import "HomeShopBaseDownSheetView.h"

@interface HomeMuseumVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HomeMuseumInfo *museumInfo;
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) HomeTicket *ticket;
@property (nonatomic, strong) NSMutableArray *indexPaths;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) HomeShopBaseDownSheetView *homeShopBaseDownSheetView;

@end

@implementation HomeMuseumVC

- (NSMutableArray *)indexPaths {
    if (_indexPaths == nil) {
        _indexPaths = [NSMutableArray array];
    }
    return _indexPaths;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getMuseumTicketData)];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isPush){
        [self getMuseumInfoData];
    }
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

#pragma mark - 接口 ：获取非选座类景点信息
- (void)getMuseumInfoData {
    NSString *museumUrl = [NSString stringWithFormat:@"scene/index/%@",self.key];
    NSString *url = [MainURL stringByAppendingPathComponent:museumUrl];
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:nil isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.museumInfo = [HomeMuseumInfo mj_objectWithKeyValues:json[Data]];
        if(weakSelf.museumInfo){
           [weakSelf setupHeaderData];
        }
        if(weakSelf.museumInfo.date.count>0){
            weakSelf.selectedDate = [LaiMethod getDateString:weakSelf.museumInfo.date[0] withFormat:@"yyyy-MM-dd"];
            [self getMuseumTicketData];
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

#pragma mark - 获取门票列表
- (void)getMuseumTicketData {
    NSString *date = (self.selectedDate) ? [NSString stringFormDateFromat:self.selectedDate formatter:FmtYMD] : [NSString stringFormDateFromat:[NSDate localDate] formatter:FmtYMD];
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
    info.leftViewTitle = @"景点介绍";
    info.leftViewDetialText = @"开放时间、注意事项";
    info.shopId = self.museumInfo.supplier_scene_id;
    NSString *museumUrl = [NSString stringWithFormat:@"scene/detail/%@?channel_pot_id=%@",self.key,ChannelPotId];
    info.detialApi = [MainURL stringByAppendingPathComponent:museumUrl];
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
        [self postAddShoppingCarRequeset:ticket with:YES];
    };
    cell.payfor = ^{
        if(ticket.biz_sess_id == 0){
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
        }
        else {
            [self pushSeatSelection:ticket];
        }
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeShopBaseSectionHeaderView *header = [HomeShopBaseSectionHeaderView headerFooterViewFromXibWithTableView:tableView];
    return (self.tickets && self.tickets.count>0) ? header : nil;
}

#pragma mark - 加入购物车
- (void)postAddShoppingCarRequeset:(HomeTicket *)ticket with:(BOOL)joinCar {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"biz_ticket_id"] = ticket.biz_ticket_id;
    dic[@"ticket_lock_num"] = @((self.count) ? self.count : 1);
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
    NSMutableArray *arr = [NSMutableArray arrayWithObject:requestParams];
    //
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *date = (self.selectedDate) ? [NSString stringFormDateFromat:self.selectedDate formatter:FmtYMD] : [NSString stringFormDateFromat:[NSDate localDate] formatter:FmtYMD];
    ticket.ticket_deadline_text = date;
    params[@"ordinaryTicket"] = ticket;
    params[@"ordinaryTicketArr"] = carArr;
    params[@"paramsArr"] = arr;
    [LaiMethod runtimePushVcName:@"HomeShopBaseOrderVC" dic:params nav:self.navigationController];
}

#pragma mark - 选座 （跳转到h5 选座页面）
-(void)pushSeatSelection:(HomeTicket *)ticket {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"apiUrl"] = @"http://192.168.1.98:9002/seat_detail.html";
    params[@"biz_sess_id"] = [NSString stringWithFormat:@"%zd",ticket.biz_sess_id];//场次ID
    params[@"titleText"] = @"在线选座";
    params[@"date"] = (self.selectedDate) ? [NSString stringFormDateFromat:self.selectedDate formatter:FmtYMD] : [NSString stringFormDateFromat:[NSDate localDate] formatter:FmtYMD];
    ticket.ticket_deadline_text = params[@"date"];
    params[@"ordinaryTicket"] = ticket;
    [LaiMethod runtimePushVcName:@"HomeSeatSelectionVC" dic:params nav:self.navigationController];
}

@end
