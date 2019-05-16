//
//  TravelsTravelsVC.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsTravelsVC.h"
#import "TravelsTravelsCell.h"
#import "Travels.h"

@interface TravelsTravelsVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *travels;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation TravelsTravelsVC

- (NSMutableArray *)travels {
    if (_travels == nil) {
        _travels = [NSMutableArray array];
    }
    return _travels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTableView];
    [self getTravelsNewTravelData];
    [self addNotification];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getTravelsNewTravelData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getTravelsMoreTravelData)];
}

- (void)setupValue {
    self.title = self.urlStr ? @"我的游记" : @"游记";
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(sendTravelsAction) title:EditIconUnicode nomalColor:SetupColor(51, 51, 51) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:0 bottom:0 right:0];
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
    tableView.placeholderText = @"暂无游记";
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight + Height44 + SpaceHeight * 2, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
// 获取游记攻略数据
- (void)getTravelsNewTravelData {
    self.currentPage = 1;
    WeakSelf(weakSelf)
    [self getTravelsTravelDataSuccessHandle:^{
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
    }];
}

- (void)getTravelsMoreTravelData {
    self.currentPage++;
    [self getTravelsTravelDataSuccessHandle:nil];
}

- (void)getTravelsTravelDataSuccessHandle:(void (^)(void))successHandle {
    NSString *stringInfo = self.urlStr ? self.urlStr : @"notes/index";
    NSString *url = [MainURL stringByAppendingPathComponent:stringInfo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Page] = @(self.currentPage);
    params[@"stadium_basic_id"] = self.stadiumId;
    params[Token] = self.token;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.travels removeAllObjects];
        NSInteger oldCount = weakSelf.travels.count;
        NSArray *strategyArr = [TravelNoteTip mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.travels addObjectsFromArray:strategyArr];
        if (weakSelf.travels.count == [json[Data][Total] integerValue]) {
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
        [weakSelf.travels removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.travels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelsTravelsCell *cell = [TravelsTravelsCell cellFromXibWithTableView:tableView];
    TravelNoteTip *noteTip = self.travels[indexPath.row];
    cell.noteTip = noteTip;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

#pragma mark - sendTravelsAction
- (void)sendTravelsAction {
    [LaiMethod runtimePushVcName:@"TravelsSendTravelsVC" dic:nil nav:self.navigationController];
}

#pragma mark - addNotification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(travelReloadData) name:@"TravelsSendNotification" object:nil];
}

- (void)travelReloadData {
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
