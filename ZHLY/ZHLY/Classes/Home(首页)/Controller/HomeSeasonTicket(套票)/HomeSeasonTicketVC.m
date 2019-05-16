//
//  HomeSeasonTicketViewController.m
//  ZHLY
//
//  Created by LTWL on 2017/12/13.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeSeasonTicketVC.h"
#import "HomeSeasonTicketCell.h"
#import "Home.h"

@interface HomeSeasonTicketVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *seasonTickets;
@end

@implementation HomeSeasonTicketVC

- (NSMutableArray *)seasonTickets {
    if (_seasonTickets == nil){
        _seasonTickets = [NSMutableArray array];
    }
    return _seasonTickets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewSeasonTicketData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getMoreSeasonTicketData)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isPush){
        [self getNewSeasonTicketData];
    }
}

- (void)setupValue {
    self.title = @"套票";
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
    tableView.placeholderText = @"暂无套票";
    tableView.placeholderImage = SetImage(@"没票");
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
// 获取套票数据
- (void)getNewSeasonTicketData {
    self.currentPage = 1;
    [self getSeasonTicketData];
}

- (void)getMoreSeasonTicketData {
    self.currentPage++;
    [self getSeasonTicketData];
}

//MARK:套票数据
- (void)getSeasonTicketData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"tickets/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = Token;
    params[Page] = @(self.currentPage);
    params[Channel_pot_id] = ChannelPotId;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.seasonTickets removeAllObjects];
        NSInteger oldCount = weakSelf.seasonTickets.count;
        NSArray *seasonTicketArr = [HomeMuseumSeasonTickets mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.seasonTickets addObjectsFromArray:seasonTicketArr];
        if (weakSelf.seasonTickets.count == [json[Data][Total] integerValue]) {
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
        [weakSelf.seasonTickets removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.seasonTickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeSeasonTicketCell *cell = [HomeSeasonTicketCell cellFromXibWithTableView:tableView];
    HomeMuseumSeasonTickets *seasonTicket = self.seasonTickets[indexPath.row];
    cell.seasonTicket = seasonTicket;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

@end
