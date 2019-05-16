//
//  HomeNoticeListVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/1.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "HomeNoticeListVC.h"
#import "Home.h"
#import "HomeNoticeCell.h"

@interface HomeNoticeListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *noticeList;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation HomeNoticeListVC

- (NSMutableArray *)noticeList {
    if (_noticeList == nil){
        _noticeList = [NSMutableArray array];
    }
    return _noticeList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告";
    [self getNewNoticeData];
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewNoticeData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getMoreNoticeData)];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight, 0);
    tableView.placeholderText = @"暂无数据";
    tableView.placeholderImage = SetImage(@"暂无商品");
    [self.view addSubview:tableView];
    _tableView = tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 接口
// 获取套票数据
- (void)getNewNoticeData {
    self.currentPage = 1;
    [self getNoticeData];
}

- (void)getMoreNoticeData {
    self.currentPage++;
    [self getNoticeData];
}

- (void)getNoticeData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"notify/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Page] = @(self.currentPage);
//    params[Token] = self.token;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.noticeList removeAllObjects];
        NSInteger oldCount = weakSelf.noticeList.count;
        NSArray *seasonTicketArr = [HomeNotice mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.noticeList addObjectsFromArray:seasonTicketArr];
        if (weakSelf.noticeList.count == [json[Data][Total] integerValue]) {
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
        [weakSelf.noticeList removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noticeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeNoticeCell *cell = [HomeNoticeCell cellFromXibWithTableView:tableView];
    HomeNotice *notice = self.noticeList[indexPath.row];
    cell.notice = notice;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = NoneSpace;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

@end
