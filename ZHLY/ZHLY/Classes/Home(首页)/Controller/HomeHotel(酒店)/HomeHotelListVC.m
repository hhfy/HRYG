//
//  HomeHotelListVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/21.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHotelListVC.h"
#import "Home.h"
#import "HomeHotellistCell.h"

@interface HomeHotelListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *hotelList;
@end

@implementation HomeHotelListVC

- (NSMutableArray *)hotelList {
    if (_hotelList == nil) {
        _hotelList = [NSMutableArray array];
    }
    return _hotelList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"酒店";
    [self setupTableView];
    [self getNewHotelData];
    
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewHotelData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getMoreHotelData)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:(iPhoneX) ? SetImage(@"navigationbarBackgroundWhite_X") : SetImage(@"navigationbarBackgroundWhite") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[NavigationController new].navigationBar.shadowImage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:(iPhoneX) ? SetImage(@"navigationbarBackgroundWhite_X") : SetImage(@"navigationbarBackgroundWhite") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[NavigationController new].navigationBar.shadowImage];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight, 0);
    tableView.placeholderText = @"暂无酒店数据";
    tableView.placeholderImage = SetImage(@"暂无商品");
    [self.view addSubview:tableView];
    _tableView = tableView;
}
// 获取数据
- (void)getNewHotelData {
    self.currentPage = 1;
    [self getHotelData];
}

- (void)getMoreHotelData {
    self.currentPage++;
    [self getHotelData];
}

//MARK: 获取酒店列表
- (void)getHotelData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"home/hotel/info/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Page] = @(self.currentPage);
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.hotelList removeAllObjects];
        NSInteger oldCount = weakSelf.hotelList.count;
        NSArray *listArr = [HomeHotelInfo mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.hotelList addObjectsFromArray:listArr];
        if (weakSelf.hotelList.count == [json[Data][Total] integerValue]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        if (oldCount > 0 && weakSelf.currentPage > 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(oldCount - 1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        if (weakSelf.currentPage > 1) weakSelf.currentPage--;
        [weakSelf.hotelList removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hotelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeHotellistCell *cell = [HomeHotellistCell cellFromXibWithTableView:tableView];
    HomeHotelInfo *info = self.hotelList[indexPath.row];
    cell.hotelInfo = info;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

@end
