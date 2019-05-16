//
//  ProfileOrderDetailVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/5.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileOrderDetailVC.h"
#import "HomeShopBaseOrderSpecialTicketView.h"
#import "ProfileOrderListCell.h"
#import "Profile.h"
#import "ProfileOrderDetailTopCell.h"
#import "ProfileOrderDetailGoodsCell.h"
#import "ProfileOrderDetailInfoCell.h"
#import "ProfileOrderRefundInfoCell.h"

@interface ProfileOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) ProfileOrderDetail *orderDetail;
@end

@implementation ProfileOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isFromXiaDanChengGong && [self.isFromXiaDanChengGong isEqualToString:@"YES"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:2 target:self action:@selector(cancel)];
    }
    [self getOrderDetailData];
}

-(void)cancel {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)getOrderDetailData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"order/detail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"biz_order_id"] = self.bizOrderId;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:NO progress:nil success:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.orderDetail = [ProfileOrderDetail mj_objectWithKeyValues:json[Data]];
        
        [weakSelf.tableView reloadData];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView reloadData];
    }];
}
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - NavHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 30.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.orderDetail){
        NSInteger num = 3;
        if (self.orderDetail.order_info.refund_reason && self.orderDetail.order_info.refund_reason.length>0) {
            num ++;
            if (self.orderDetail.order_info.refund_rreason && self.orderDetail.order_info.refund_rreason.length>0) {
                num ++;
            }
        }
       return num;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? self.orderDetail.ticket_list.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ProfileOrderDetailTopCell *cell = [ProfileOrderDetailTopCell cellFromXibWithTableView:tableView];
        cell.orderInfo = self.orderDetail.order_info;
        return cell;
    }
    else if (indexPath.section == 1){
        ProfileOrderDetailGoodsCell *cell = [ProfileOrderDetailGoodsCell cellFromXibWithTableView:tableView];
        cell.orderTicket = self.orderDetail.ticket_list[indexPath.row];
        //    ProfileOrderIndex *ticket = self.orderInfoArr[indexPath.section];
        //    if(ticket && ticket.ticket_list.count>0) {
        //        cell.ticket = ticket.ticket_list[indexPath.row];
        //    }
        return cell;
    }
    else if (indexPath.section == 2){
        ProfileOrderDetailInfoCell *cell = [ProfileOrderDetailInfoCell cellFromXibWithTableView:tableView];
        cell.orderInfo = self.orderDetail.order_info;
        return cell;
    }
    else {
        ProfileOrderRefundInfoCell *cell = [ProfileOrderRefundInfoCell cellFromXibWithTableView:tableView];
        if (indexPath.section == 3) {
            cell.name = @"退款原因";
            cell.info = self.orderDetail.order_info.refund_reason;
        }
        else {
            cell.name = @"退款拒绝原因";
            cell.info = self.orderDetail.order_info.refund_rreason;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 2 ? 45 : NoneSpace;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeShopBaseOrderSpecialTicketView *sectionHeaderView = [HomeShopBaseOrderSpecialTicketView headerFooterViewFromXibWithTableView:tableView];
    sectionHeaderView.title = @"订单信息";
    return (section == 2) ? sectionHeaderView : nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section <= 1) ? SpaceHeight : NoneSpace;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

@end
