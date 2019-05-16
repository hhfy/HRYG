//
//  HomeShopBaseVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseVC.h"

@interface HomeShopBaseVC ()

@end

@implementation HomeShopBaseVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeaderView];
    [self setupTableView];
}


- (void)setHeaderView {
    HomeShopBaseHeaderView *headerView = [HomeShopBaseHeaderView viewFromXib];
    [self.view addSubview:headerView];
    _headerView = headerView;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY, self.view.width, self.view.height - self.headerView.height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 20;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight, 0);
    tableView.placeholderText = @"暂无门票";
    tableView.placeholderImage = SetImage(@"没票");
//    tableView.isHideNoDataView = YES;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

@end
