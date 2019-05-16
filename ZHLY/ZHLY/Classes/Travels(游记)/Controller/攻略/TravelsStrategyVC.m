//
//  TravelsStrategyVC.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsStrategyVC.h"
#import "TravelsStrategyCell.h"
#import "Travels.h"

@interface TravelsStrategyVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *strategies;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation TravelsStrategyVC

- (NSMutableArray *)strategies {
    if (_strategies == nil){
        _strategies = [NSMutableArray array];
    }
    return _strategies;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self getTravelsNewStrategyData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getTravelsNewStrategyData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getTravelsMoreStrategyData)];
}

- (void)setupValue {
    self.title = @"攻略";
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
    tableView.placeholderText = @"暂无攻略";
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
// 获取游记攻略数据
- (void)getTravelsNewStrategyData {
    self.currentPage = 1;
    WeakSelf(weakSelf)
    [self getTravelsStrategyDataWithSuccessHandle:^{
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
    }];
}

- (void)getTravelsMoreStrategyData {
    self.currentPage++;
    [self getTravelsStrategyDataWithSuccessHandle:nil];
}

- (void)getTravelsStrategyDataWithSuccessHandle:(void (^)(void))successHandle {
    NSString *url = [MainURL stringByAppendingPathComponent:@"tips/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Page] = @(self.currentPage);
    params[@"stadium_basic_id"] = self.stadiumId;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.strategies removeAllObjects];
        NSInteger oldCount = weakSelf.strategies.count;
        NSArray *strategyArr = [TravelNoteTip mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.strategies addObjectsFromArray:strategyArr];
        if (weakSelf.strategies.count == [json[Data][Total] integerValue]) {
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
        if (successHandle) successHandle();
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        if (weakSelf.currentPage > 1) weakSelf.currentPage--;
        [weakSelf.strategies removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.strategies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelsStrategyCell *cell = [TravelsStrategyCell cellFromXibWithTableView:tableView];
    TravelNoteTip *noteTip = self.strategies[indexPath.row];
    cell.noteTip = noteTip;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

@end
