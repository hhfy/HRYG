//
//  HomeOrderSuccessVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/19.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "HomeOrderSuccessVC.h"
#import "HomeOrderSuccessTopCell.h"
#import "HomeOrderSuccessCenterCell.h"
#import "ProfileOrderRefundInfoCell.h"
#import "HomeShopBaseOrderSpecialTicketView.h"

@interface HomeOrderSuccessVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation HomeOrderSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付结果";
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    tableView.placeholderImage = SetImage(@"暂无商品");
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight * 2, 0);
    tableView.isHideNoDataView = YES;
    [self.view addSubview:tableView];
    _tableView = tableView;
}
#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeOrderSuccessTopCell *cell = [HomeOrderSuccessTopCell cellFromXibWithTableView:tableView];
        return cell;
    }
    else {
        HomeOrderSuccessCenterCell *cell = [HomeOrderSuccessCenterCell cellFromXibWithTableView:tableView];
        cell.biz_order_id = self.biz_order_id;
        return cell;
    }
//    else {
//        ProfileOrderRefundInfoCell *cell = [ProfileOrderRefundInfoCell cellFromXibWithTableView:tableView];
//        if (indexPath.row == 0) {
//            cell.name = @"有效时间";
//            cell.info = @"";
//        }
//        else if (indexPath.row == 0) {
//            cell.name = @"景点地址";
//            cell.info = @"";
//        }
//        else {
//            cell.name = @"退改规则";
//            cell.info = @"";
//        }
//        return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section==1 ? SpaceHeight : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    HomeShopBaseOrderSpecialTicketView *sectionHeaderView = [HomeShopBaseOrderSpecialTicketView headerFooterViewFromXibWithTableView:tableView];
//    sectionHeaderView.title = [NSString stringWithFormat:@"%@·%@",@"马文化博物馆",@"成人票"];
    return  nil;
}

@end
