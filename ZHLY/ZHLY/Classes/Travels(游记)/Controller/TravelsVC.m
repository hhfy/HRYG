
//
//  TravelsVC.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsVC.h"
#import "TravelsHotCell.h"
#import "TravelsListCell.h"
#import "TravelsStrategyListCell.h"
#import "Travels.h"
#import "TravelsHeaderView.h"

@interface TravelsVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *ads;
@property (nonatomic, strong) NSArray *stadiums;
@property (nonatomic, strong) NSArray *noteTips;
@property (nonatomic, weak) TravelsHeaderView *headerView;
@end

@implementation TravelsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupHeaderView];
//
    [self reloadDataHandle];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isPush){
        [self getTravelsData];
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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight + Height44 + SpaceHeight * 2, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    WeakSelf(weakSelf)
    [LaiMethod setupElasticPullRefreshWithTableView:tableView loadingViewCircleColor:MainThemeColor ElasticPullFillColor:[UIColor whiteColor] actionHandler:^{
        [weakSelf getTravelsData];
    }];
}

- (void)setupHeaderView {
    TravelsHeaderView *headerView = [TravelsHeaderView viewFromXib];
    self.tableView.tableHeaderView = headerView;
    _headerView = headerView;
}

- (void)reloadDataHandle {
    WeakSelf(weakSelf)
    self.reloadData = ^{
        [weakSelf getTravelsData];
    };
    self.networkForOnline = ^{
        [weakSelf getTravelsData];
    };
}

#pragma mark - 接口
// 获取游记首页的数据
- (void)getTravelsData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"travel/index"];
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:nil isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.headerView.adUrls = [TravelTrafficAd mj_objectArrayWithKeyValuesArray:json[Data][@"ad"]];
        weakSelf.stadiums = [TravelStadium mj_objectArrayWithKeyValuesArray:json[Data][@"stadium"]];
        weakSelf.noteTips = [TravelNoteTip mj_objectArrayWithKeyValuesArray:json[Data][@"note_tip"]];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return (self.stadiums.count) ? 1 : 0;
            break;
        case 1:
            return self.noteTips.count;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TravelsHotCell *cell = [TravelsHotCell cellFromXibWithTableView:tableView];
        cell.title = @"热门场馆";
        cell.stadiums = self.stadiums;
        return cell;
    } else  {
        TravelNoteTip *noteTip = self.noteTips[indexPath.row];
        if (noteTip.type == 1) {
            TravelsListCell *cell = [TravelsListCell cellFromXibWithTableView:tableView];
            cell.noteTip = noteTip;
            return cell;
        } else {
            TravelsStrategyListCell *cell = [TravelsStrategyListCell cellFromXibWithTableView:tableView];
            cell.noteTip = noteTip;
            return cell;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return (self.stadiums.count) ? SpaceHeight : NoneSpace;
    } else {
        return (self.noteTips.count) ? SpaceHeight : NoneSpace;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.navigationController.navigationBar.shadowImage != [NavigationController new].navigationBar.shadowImage) self.navigationController.navigationBar.shadowImage = [NavigationController new].navigationBar.shadowImage;
        });
    }
}


- (void)dealloc {
    [self.tableView removeJElasticPullToRefreshView];
}

@end
