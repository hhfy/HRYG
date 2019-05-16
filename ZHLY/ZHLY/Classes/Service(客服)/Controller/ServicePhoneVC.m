
//
//  ServicePhoneVC.m
//  ZHLY
//
//  Created by LTWL on 2017/11/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServicePhoneVC.h"
#import "ServicePhoneCell.h"
#import "ServicePhoneView.h"
#import "Service.h"

@interface ServicePhoneVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *phones;
@end

@implementation ServicePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self getServicePhoneData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getServicePhoneData)];
}

- (void)setupValue {
    self.title = @"客服电话";
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 45.f;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight + Height44 + SpaceHeight * 2, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
// 获取客服电话数据
- (void)getServicePhoneData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"customer/phone"];
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:nil isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.phones = [ServicePhone mj_objectArrayWithKeyValuesArray:json[Data]];
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

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.phones.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ServicePhone *servicePhone = self.phones[section];
    return servicePhone.phone_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServicePhoneCell *cell = [ServicePhoneCell cellFromXibWithTableView:tableView];
    ServicePhone *servicePhone = self.phones[indexPath.section];
    ServicePhoneDetial *phoneDetial = servicePhone.phone_data[indexPath.row];
    cell.phoneDetial = phoneDetial;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ServicePhoneView *headerView = [ServicePhoneView headerFooterViewFromXibWithTableView:tableView];
    ServicePhone *servicePhone = self.phones[section];
    headerView.servicePhone = servicePhone;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

@end
