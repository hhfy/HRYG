
//
//  HomeMuseumScoreVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseScoreVC.h"
#import "HomeShopBaseScoreCell.h"
#import "Home.h"

@interface HomeShopBaseScoreVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *userScores;
@end

@implementation HomeShopBaseScoreVC

- (NSMutableArray *)userScores
{
    if (_userScores == nil)
    {
        _userScores = [NSMutableArray array];
    }
    return _userScores;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self getNewUserScoreData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewUserScoreData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getMoreUserScoreData)];
}

- (void)setupValue {
    self.title = @"用户评价";
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
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight, 0);
    tableView.placeholderText = @"暂无用户评价";
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
// 获取用户评价数据
- (void)getNewUserScoreData {
    self.currentPage = 1;
    WeakSelf(weakSelf)
    [self getUserScoreDataWithSuccessHandle:^{
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
    }];
}

- (void)getMoreUserScoreData {
    self.currentPage++;
    [self getUserScoreDataWithSuccessHandle:nil];
}

- (void)getUserScoreDataWithSuccessHandle:(void (^)(void))successHandle {
    NSString *commentUrl = [NSString stringWithFormat:@"scene/comments/%@",self.shopId];
    NSString *url = [MainURL stringByAppendingPathComponent:commentUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"shop_id"] = self.shopId;
    params[Token] = self.token;
    params[Page] = @(self.currentPage);
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.userScores removeAllObjects];
        NSInteger oldCount = weakSelf.userScores.count;
        NSArray *userScoreArr = [HomeMuseumScoreList mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.userScores addObjectsFromArray:userScoreArr];
        if (weakSelf.userScores.count == [json[Data][Total] integerValue]) {
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
        [weakSelf.userScores removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userScores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeShopBaseScoreCell *cell = [HomeShopBaseScoreCell cellFromXibWithTableView:tableView];
    HomeMuseumScoreList *scoreList = self.userScores[indexPath.row];
    cell.scoreList = scoreList;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}


@end

