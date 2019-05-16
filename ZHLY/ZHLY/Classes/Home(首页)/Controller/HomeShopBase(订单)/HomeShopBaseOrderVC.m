//
//  HomeMuseumOrderVC.m
//  ZHLY
//  订单页 - 通用：包含普通景点和选座场馆（除购物车确认）
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderVC.h"
#import "HomeShopBaseOrderTopCell.h"
#import "HomeShopBaseOrderAddTouristCell.h"
#import "HomeShopBaseOrderTourGuideServiceCell.h"
#import "HomeShopBaseOrderSpecialTicketCell.h"
#import "HomeShopBaseOrderCommitView.h"
#import "Home.h"
#import "HomeShopBaseOrderSpecialTicketView.h"
#import "PaymentCell.h"
#import "HomeShoppingCarOrderCell.h"
#import "AppDelegate.h"
#import "Profile.h"

@interface HomeShopBaseOrderVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property (nonatomic, strong) HomeMuseumUserVisitor *userVisitor;
@property (nonatomic, weak) HomeShopBaseOrderCommitView *commitView;
@property (nonatomic, assign) NSInteger payType;
@end

@implementation HomeShopBaseOrderVC

- (NSMutableArray *)selectedIndexPaths {
    if (_selectedIndexPaths == nil) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return _selectedIndexPaths;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self addNSNotification];
}

- (void)setupValue {
    self.title = @"填写订单";
    self.payType = 3;
    self.userVisitor = self.ticketMainOrder.visitor_info;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isPush){
        [self requestOrderData];
    }
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
    tableView.placeholderText = @"未获取到数据";
    tableView.placeholderImage = SetImage(@"");
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight * 2, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupCommitView {
    HomeShopBaseOrderCommitView *commitView = [HomeShopBaseOrderCommitView viewFromXib];
    commitView.hidden = YES;
    commitView.y = MainScreenSize.height - commitView.height - NavHeight;
    [self.view addSubview:commitView];
    _commitView = commitView;
    if(self.ticketMainOrder){
        self.commitView.price = [self.ticketMainOrder.need_pay floatValue];
    }
    WeakSelf(weakSelf)
    commitView.didTap = ^{
        if (self.userVisitor.biz_visitor_id) {
            [LaiMethod alertControllerWithTitle:nil message:@"是否提交当前订单?" defaultActionTitle:@"提交" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
                [weakSelf postOrderData];
            }];
        } else {
            [SVProgressHUD showError:@"请选择游客"];
        }
    };
}

#pragma mark - 下单 获取订单数据
-(void)requestOrderData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"ticket/confirm"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.paramsArr[0]];
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        weakSelf.ticketMainOrder = [HomeTicketMainOrder mj_objectWithKeyValues:json[Data]];
        weakSelf.userVisitor = weakSelf.ticketMainOrder.visitor_info;
        [self setupCommitView];
        [self.tableView reloadData];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}
//MARK:支付 提交订单数据
- (void)postOrderData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifuSuccess) name:@"ZFSuccessNotification" object:nil];
    
    NSString *url = [MainURL stringByAppendingPathComponent:@"ticket/pay"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.paramsArr[0]];
    params[@"pay_type"] = @(self.payType);
    params[@"biz_visitor_id"] = self.userVisitor.biz_visitor_id;
    
    NSString *paramsTicketIdName = nil;
    NSString *paramsNumber = nil;
    NSInteger index = self.ordinaryTicketArr.count;
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        HomeShopBaseOrderSpecialTicketCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        paramsTicketIdName = [NSString stringWithFormat:@"ticket[%zd][biz_ticket_id]", index];
        paramsNumber = [NSString stringWithFormat:@"ticket[%zd][ticket_number]", index];
        params[paramsTicketIdName] = cell.ticket.biz_ticket_id;
        params[paramsNumber] = @(cell.ticket.totalCount);
        index++;
    }
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        HomeTicketPayInfo *payInfo = [HomeTicketPayInfo mj_objectWithKeyValues:json[Data]];

//        if ([payInfo.sign isEqualToString:params[@"sign"]]) {
//            [SVProgressHUD showSuccess:@"下单成功"];
//        }
//        else {
//            [SVProgressHUD showError:@"数据非法"];
//        }
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"biz_order_id"] = payInfo.order_info.biz_order_id;
//        [LaiMethod runtimePushVcName:@"HomeOrderSuccessVC" dic:params nav:self.navigationController];
        
        //支付宝支付设置
        if (self.payType == 3) {
            AppDelegate *delegate = [AppDelegate app];
            delegate.payType = PayTypeZFBShopping;
            if ([payInfo.pay_info isKindOfClass:[NSString class]] && payInfo.pay_info.length >0) {
                [[AlipaySDK defaultService] payOrder:payInfo.pay_info fromScheme:AppSchemah callback:^(NSDictionary *resultDic) {
                    if([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                        //跳转
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        params[@"biz_order_id"] = payInfo.order_info.biz_order_id;
                        [LaiMethod runtimePushVcName:@"HomeOrderSuccessVC" dic:params nav:self.navigationController];
//                        [SVProgressHUD showSuccess:@"恭喜你,支付成功"];
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                            [weakSelf.navigationController popViewControllerAnimated:YES];
//                            [LaiMethod runtimePushVcName:@"HomeOrderSuccessVC" dic:nil nav:self.navigationController];
//                        });
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
    } otherCase:nil failure:^(NSError *error) {
    }];
}

-(void)zhifuSuccess {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.ticketMainOrder && !self.ticketMainOrder.ticket_link.count) {
        return 0;
    } else {
        self.commitView.hidden = NO;
        return (self.ticketMainOrder.ticket_link.count) ? 4 : 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.ordinaryTicketArr.count;
    }
    else if(section == 1) {
        return (self.ticketMainOrder.ticket_link && self.ticketMainOrder.ticket_link.count>0) ? self.ticketMainOrder.ticket_link.count : 1;
    }
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeShoppingCarOrderCell *cell = [HomeShoppingCarOrderCell cellFromXibWithTableView:tableView];
        HomeShoppingCarTicket *ticket = self.ordinaryTicketArr[indexPath.row];
        ticket.ticket_buy_intro = self.ordinaryTicket.ticket_buy_intro;
        ticket.ticket_refund_intro = self.ordinaryTicket.ticket_refund_intro;
        ticket.ticket_use_intro = self.ordinaryTicket.ticket_use_intro;
        ticket.date = self.ordinaryTicket.ticket_deadline_text;
        ticket.totalCount = self.ordinaryTicket.totalCount;
        cell.ticket = ticket;
        cell.showImg = YES;//显示购买须知
        return cell;
    }
    else if (indexPath.section == 1) {
        return (self.ticketMainOrder.ticket_link.count) ? [self homeShopBaseOrderSpecialTicketCellWithTableView:tableView indexPath:indexPath] : [self homeShopBaseOrderAddTouristCellWithTableView:tableView];
    }
    else if (indexPath.section == 2) {
        return (self.ticketMainOrder.ticket_link.count) ? [self homeShopBaseOrderAddTouristCellWithTableView:tableView] : [self paymentCellWithTableView:tableView indexPath:indexPath];
    }
    else {
        return [self paymentCellWithTableView:tableView indexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return SpaceHeight;
            break;
        case 1:
            return (self.ticketMainOrder.ticket_link.count) ? 45 : NoneSpace;
        default:
            return NoneSpace;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeShopBaseOrderSpecialTicketView *sectionHeaderView = [HomeShopBaseOrderSpecialTicketView headerFooterViewFromXibWithTableView:tableView];
    return (section == 1 && self.ticketMainOrder.ticket_link.count) ? sectionHeaderView : nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - tableViewCell的封装方法
- (HomeShopBaseOrderSpecialTicketCell *)homeShopBaseOrderSpecialTicketCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    HomeShopBaseOrderSpecialTicketCell *cell = [HomeShopBaseOrderSpecialTicketCell cellFromXibWithTableView:tableView];
    HomeTicket *ticket = self.ticketMainOrder.ticket_link[indexPath.row];
    cell.ticket = ticket;
    cell.selectIndexPath = indexPath;
    WeakSelf(weakSelf)
    cell.openType = ([weakSelf.selectedIndexPaths containsObject:indexPath]) ? CellOpenTypeOpen : CellOpenTypeClose;
    cell.didSelected = ^(NSIndexPath *selectIndexPath, BOOL isSelected ,NSInteger count) {
        ticket.totalCount = count; //改变model中的当前特殊票的选择数量和金额
        ticket.need_pay = [ticket.ticket_sale_price floatValue]*ticket.totalCount;
        if (isSelected) {
            if (![weakSelf.selectedIndexPaths containsObject:indexPath]) [weakSelf.selectedIndexPaths addObject:selectIndexPath];
        } else {
            if ([weakSelf.selectedIndexPaths containsObject:indexPath]) [weakSelf.selectedIndexPaths removeObject:selectIndexPath];
        }
        [weakSelf.tableView reloadData];
    };
    cell.countDidChange = ^(NSInteger count,BOOL isSelected,NSIndexPath *selectIndexPath) {
        ticket.totalCount = count;//改变model中的当前特殊票的选择数量和金额
        ticket.need_pay = [ticket.ticket_sale_price floatValue]*ticket.totalCount;
        [self.tableView reloadData];
    };
    [self calculationTicketTotalPrice];
    return cell;
}

-(PaymentCell*)paymentCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    PaymentCell *cell = [PaymentCell cellFromXibWithTableView:tableView];
    cell.payTypeList = self.ticketMainOrder.pay_list;
    cell.paymentSeletedType = ^(NSInteger index) {
        self.payType = index;
    };
    return cell;
}

-(void)calculationTicketTotalPrice {
    //计算特殊票总金额
    CGFloat specialTicketPrice = 0;
    for (int i =0; i<self.ticketMainOrder.ticket_link.count; i++) {
        HomeTicket *ticket = self.ticketMainOrder.ticket_link[i];
        specialTicketPrice += ticket.need_pay;
    }
    //刷新总价
    self.commitView.price = specialTicketPrice + [self.ticketMainOrder.need_pay floatValue];
}

- (HomeShopBaseOrderAddTouristCell *)homeShopBaseOrderAddTouristCellWithTableView:(UITableView *)tableView {
    HomeShopBaseOrderAddTouristCell *cell = [HomeShopBaseOrderAddTouristCell cellFromXibWithTableView:tableView];
    cell.userVisitor = self.userVisitor;
    return cell;
}

//导游服务
//- (HomeShopBaseOrderTourGuideServiceCell *)homeMuseumOrderTourGuideServiceCellWithTableView:(UITableView *)tableView {
//    HomeShopBaseOrderTourGuideServiceCell *cell = [HomeShopBaseOrderTourGuideServiceCell cellFromXibWithTableView:tableView];
//    return cell;
//}

#pragma mark - addNSNotification
- (void)addNSNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderData) name:NeedReloadDataNotification object:nil];
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
