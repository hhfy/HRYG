//
//  ProfileOrderListVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/2.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileOrderListVC.h"
#import "ProfileOrderListCell.h"
#import "Profile.h"
#import "ProfileOrderHeaderView.h"
#import "ProfileOrderFooterView.h"
#import "Home.h"
#import "PubTopPageOfBtnView.h"

@interface ProfileOrderListVC ()<UITableViewDelegate, UITableViewDataSource,PubTopPageOfBtnViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, strong) ProfileOrderModel *profileOrder;
@property (nonatomic, strong) NSMutableArray *orderInfoArr;
@property (nonatomic, strong) PubTopPageOfBtnView *topPageOfBtnView;
@end

@implementation ProfileOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    if (!self.fromAllOrder && !_topPageOfBtnView) {
        _topPageOfBtnView = [[PubTopPageOfBtnView alloc]initWithFrame:CGRectMake(0, 0, MainScreenSize.width, 44) withCount:4 withShowType:self.indexType];
        [_topPageOfBtnView topScrollViewClick:_topPageOfBtnView.selectedBtn];
        _topPageOfBtnView.delegate = self;
        [self.view addSubview:_topPageOfBtnView];
    }
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewData)];
}

#pragma mark ----- 切换顶部状态 -----
- (void)pubTopPageDelegateOfBtnAction:(NSInteger)tag {
    self.indexType = tag;
    [self getNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewData];
}

- (void)setupTableView {
    if(!_tableView){
        CGFloat height = (self.fromAllOrder) ? self.view.height - NavHeight : self.view.height - NavHeight -45;
        CGFloat y = (self.fromAllOrder) ? 0 : 44;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.width, height) style:UITableViewStyleGrouped];
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
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ProfileOrderIndex *ticket = self.orderInfoArr[section];
    return ticket.ticket_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileOrderListCell *cell = [ProfileOrderListCell cellFromXibWithTableView:tableView];
    ProfileOrderIndex *ticket = self.orderInfoArr[indexPath.section];
    if(ticket && ticket.ticket_list.count>0) {
        cell.ticket = ticket.ticket_list[indexPath.row];
        cell.orderBlock = ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"bizOrderId"] = ticket.biz_order_id;
            [LaiMethod runtimePushVcName:@"ProfileOrderDetailVC" dic:params nav:CurrentViewController.navigationController];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ProfileOrderHeaderView *sectionHeaderView = [ProfileOrderHeaderView headerFooterViewFromXibWithTableView:tableView];
    ProfileOrderIndex *ticket = self.orderInfoArr[section];
    sectionHeaderView.orderIndex = ticket;
    sectionHeaderView.btnTap = ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"bizOrderId"] = ticket.biz_order_id;
        [LaiMethod runtimePushVcName:@"ProfileOrderDetailVC" dic:params nav:CurrentViewController.navigationController];
    };
    return sectionHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 55;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ProfileOrderFooterView *sectionFooterView = [ProfileOrderFooterView headerFooterViewFromXibWithTableView:tableView];
    ProfileOrderIndex *ticket = self.orderInfoArr[section];
    sectionFooterView.orderIndex = ticket;
    sectionFooterView.btnBlock = ^(NSInteger tag) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"biz_order_id"] = ticket.biz_order_id;
        params[Token] = self.token;
        switch (ticket.order_status) {
            case 2://未付款
            {
                if (tag == 1) {
                    [self payAgain:params];
                }
                else {
                    [LaiMethod alertControllerWithTitle:nil message:@"是否取消该订单" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
                        [self cancelOrder:params];
                    }];
                }
            }
                break;
            case 3://已付款
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"biz_order_id"] = ticket.biz_order_id;
                [LaiMethod runtimePushVcName:@"ProfileOrderRefundReasonVC" dic:dic nav:CurrentViewController.navigationController];
            }
                break;
            case 4://使用中
                break;
            case 5: //已完成
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"bizOrderId"] = ticket.biz_order_id;
                dic[@"orderIndex"] = ticket;
                [LaiMethod runtimePushVcName:@"ProfileReviewsVC" dic:dic nav:CurrentViewController.navigationController];
            }
                break;
            case 6://已评价
                [self deleteOrder:params];
                break;
            case 11://已取消
               [self deleteOrder:params];
                break;
            case 12://已关闭
               [self deleteOrder:params];
                break;
            default:
                break;
        }
    };
    return sectionFooterView;
}


- (void)getNewData {
    self.page = 1;
    [self getOrderData];
}

- (void)getMoreStudyData {
    self.page++;
    [self getOrderData];
}

-(void)getRefundData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"order/index_refund"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[Page] = @(self.page);
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.profileOrder = [ProfileOrderModel mj_objectWithKeyValues:json[Data]];
        if (weakSelf.profileOrder.list) {
            [LaiMethod setupUpRefreshWithTableView:weakSelf.tableView target:self action:@selector(getMoreStudyData)];
        }
        if (weakSelf.page >1) {
            [weakSelf.orderInfoArr addObjectsFromArray:weakSelf.profileOrder.list];
        }
        else {
            if (weakSelf.profileOrder.list) {
                weakSelf.orderInfoArr = [[NSMutableArray alloc] initWithArray:weakSelf.profileOrder.list];
            }
        }
        if (weakSelf.profileOrder.list.count<15) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        if (weakSelf.page > 1) weakSelf.page--;
        [weakSelf.orderInfoArr removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

-(void)getOtherData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"order/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[Page] = @(self.page);
    if (!self.fromAllOrder) {
        params[@"order_status"] = [self getOrderStatusIndex:self.indexType];
    }
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:NO progress:nil success:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.profileOrder = [ProfileOrderModel mj_objectWithKeyValues:json[Data]];
        if (weakSelf.profileOrder.list) {
            [LaiMethod setupUpRefreshWithTableView:weakSelf.tableView target:self action:@selector(getMoreStudyData)];
        }
        if (weakSelf.page >1) {
            [weakSelf.orderInfoArr addObjectsFromArray:weakSelf.profileOrder.list];
        }
        else {
            if (weakSelf.profileOrder.list) {
                weakSelf.orderInfoArr = [[NSMutableArray alloc] initWithArray:weakSelf.profileOrder.list];
            }
        }
        if (weakSelf.profileOrder.list.count<15) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        if (weakSelf.page > 1) weakSelf.page--;
        [weakSelf.orderInfoArr removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)getOrderData {
    if(self.indexType == 3){
        [self getRefundData];
    }
    else {
        [self getOtherData];
    }
}

-(NSString *)getOrderStatusIndex:(NSInteger)type {
    NSString *status = @"0";
    switch (type) {
        case 0:
            status = @"2";
            break;
        case 1:
            status = @"3";
            break;
        case 2:
            status = @"5";
            break;
//        case 3:
//            status = @"999";
//            break;
        default:
            break;
    }
    return status;
}

//-(NSString *)getOrderStatusType:(OrderStatusType)orderStatusType {
//    NSString *status = @"0";
//    switch (orderStatusType) {
//        case OrderTypeUnpaid:
//            status = @"2";
//            break;
//        case OrderTypeUnconsumed:
//            status = @"3";
//            break;
//        case OrderTypeCompleted:
//            status = @"5";
//            break;
//        case OrderTypeRefunded:
//            status = @"99";
//            break;
//        default:
//            break;
//    }
//    return status;
//}

-(void)payAgain:(NSMutableDictionary *)params {
    NSString *url = [MainURL stringByAppendingPathComponent:@"order/pay"];
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        HomeTicketPayInfo *payInfo = [HomeTicketPayInfo mj_objectWithKeyValues:json[Data]];
//        //        if ([payInfo.sign isEqualToString:params[@"sign"]]) {
//        //            [SVProgressHUD showSuccess:@"下单成功"];
//        //        }
//        //        else {
//        //            [SVProgressHUD showError:@"数据非法"];
//        //             break;
//        //        }
        if ([payInfo.pay_type intValue] == 3) {//支付宝
            AppDelegate *delegate = [AppDelegate app];
            delegate.payType = PayTypeZFBShopping;
            if ([payInfo.pay_info isKindOfClass:[NSString class]] && payInfo.pay_info.length >0) {
                [[AlipaySDK defaultService] payOrder:payInfo.pay_info fromScheme:AppSchemah callback:^(NSDictionary *resultDic) {
                    if([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                        [SVProgressHUD showSuccess:@"恭喜你,支付成功"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf getNewData];
                        });
                    }
                    else {
                        [SVProgressHUD showError:@"支付失败,请重试!"];
                    }
                }];
            }
        }
        else {
            //微信
        }
    } otherCase:nil failure:nil];
}
-(void)cancelOrder:(NSMutableDictionary *)params {
    NSString *url = [MainURL stringByAppendingPathComponent:@"order/cancel"];
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        [SVProgressHUD showSuccess:@"恭喜你,取消成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf getNewData];
        });
    } otherCase:nil failure:nil];
}
-(void)deleteOrder:(NSMutableDictionary *)params {
    WeakSelf(weakSelf)
    NSString *url = [MainURL stringByAppendingPathComponent:@"order/delete"];
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        [SVProgressHUD showSuccess:@"恭喜你,删除成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf getNewData];
        });
    } otherCase:nil failure:nil];
}
-(void)refundOrder:(NSMutableDictionary *)params {
    WeakSelf(weakSelf)
    NSString *url = [MainURL stringByAppendingPathComponent:@"order/refund"];
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        [SVProgressHUD showSuccess:@"恭喜你,退款成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf getNewData];
        });
    } otherCase:nil failure:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
