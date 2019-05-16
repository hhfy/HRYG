//
//  TravelsTrafficGuideVC.m
//  ZHLY
//  交通指南
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsTrafficGuideVC.h"
#import "TravelsTrafficGuideHeaderView.h"
#import "TravelsTrafficGuideSetcionHeaderView.h"
#import "Travels.h"
#import "TravelsTrafficGuideCell.h"

@interface TravelsTrafficGuideVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *topBgImageView;
@property (nonatomic, weak) TravelsTrafficGuideHeaderView *headerView;
//@property (nonatomic, strong) NSArray *trafficLines;
//@property (nonatomic, strong) TravelTrafficAddress *trafficAddress;
@property (nonatomic, strong) TravelTrafficIndex *traffic;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation TravelsTrafficGuideVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupHeaderView];
    [self getTrafficGuideData];
}

- (void)setupHeaderView {
    TravelsTrafficGuideHeaderView *headerView = [TravelsTrafficGuideHeaderView viewFromXib];
    self.tableView.tableHeaderView = headerView;
    _headerView = headerView;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 20;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    WeakSelf(weakSelf)
    [LaiMethod setupElasticPullRefreshWithTableView:tableView loadingViewCircleColor:MainThemeColor ElasticPullFillColor:SetupColor(242, 242, 242) actionHandler:^{
        [weakSelf getTrafficGuideData];
    }];
}

#pragma mark - 接口
// 获取交通的数据
- (void)getTrafficGuideData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"traffic/index"];
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:nil isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.traffic = [TravelTrafficIndex mj_objectWithKeyValues:json[Data]];
        weakSelf.headerView.adUrls = weakSelf.traffic.ad;
//        weakSelf.headerView.adUrls = json[Data][@"ad"];
//        weakSelf.trafficAddress = [TravelTrafficAddress mj_objectWithKeyValues:json[Data][@"address"]];
//        weakSelf.trafficLines = [TravelTrafficLines mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView stopLoading];
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView reloadData];
        [weakSelf.tableView stopLoading];
    } failure:^(NSError *error) {
        [weakSelf.tableView reloadData];
        [weakSelf.tableView stopLoading];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.traffic.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelsTrafficGuideCell *cell = [TravelsTrafficGuideCell cellFromXibWithTableView:tableView];
    TravelTrafficLines *trafficLines = self.traffic.list[indexPath.row];
    cell.trafficLines = trafficLines;
    if (indexPath == self.selectedIndexPath) {
        cell.openType = CellOpenTypeOpen;
    } else {
        cell.openType = CellOpenTypeClose;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelsTrafficGuideCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.openType == CellOpenTypeOpen) {
        self.selectedIndexPath = nil;
        cell.openType = CellOpenTypeClose;
    } else {
        self.selectedIndexPath = indexPath;
        cell.openType = CellOpenTypeOpen;
    }
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TravelsTrafficGuideSetcionHeaderView *sectionHeaderView = [TravelsTrafficGuideSetcionHeaderView headerFooterViewFromXibWithTableView:tableView];
    sectionHeaderView.trafficAddress = self.traffic.address;
    return (self.traffic.address) ? sectionHeaderView : nil;
}


- (void)dealloc {
    [self.tableView removeJElasticPullToRefreshView];
}

@end
