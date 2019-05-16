//
//  TravelsMonentVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsMonentVC.h"
#import "TravelsMomentCell.h"
#import "Travels.h"

@interface TravelsMonentVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *moments;
@end

@implementation TravelsMonentVC

- (NSMutableArray *)moments
{
    if (_moments == nil)
    {
        _moments = [NSMutableArray array];
    }
    return _moments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTableView];
    [self getTravelsNewMomentData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getTravelsNewMomentData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getTravelsMoreMomentData)];
    [self addNotification];
}

- (void)setupValue {
    self.title = self.urlStr ? @"我的动态" :@"精彩动态";
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(sendMomentAction) title:EditIconUnicode nomalColor:SetupColor(51, 51, 51) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:0 bottom:0 right:0];
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
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
// 获取动态数据
- (void)getTravelsNewMomentData {
    self.currentPage = 1;
    WeakSelf(weakSelf)
    [self getTravelsMomentDataWithSuccessHandle:^{
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
    }];
}

- (void)getTravelsMoreMomentData {
    self.currentPage++;
    [self getTravelsMomentDataWithSuccessHandle:nil];
}

- (void)getTravelsMomentDataWithSuccessHandle:(void (^)(void))successHandle {
    NSString *stringInfo = self.urlStr ? self.urlStr : @"tweet/index";
    NSString *url = [MainURL stringByAppendingPathComponent:stringInfo];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Page] = @((self.currentPage) ? self.currentPage : 1);
    params[Token] = self.token;
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.moments removeAllObjects];
        NSInteger oldCount = weakSelf.moments.count;
        NSArray *momentArr = [TravelMoment mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.moments addObjectsFromArray:momentArr];
        if (weakSelf.moments.count == [json[Data][Total] integerValue]) {
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
        [weakSelf.moments removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelsMomentCell *cell = [TravelsMomentCell cellFromXibWithTableView:tableView];
    TravelMoment *moment = self.moments[indexPath.row];
    cell.moment = moment;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

#pragma mark - sendMomentAction
- (void)sendMomentAction {
    [LaiMethod runtimePushVcName:@"TravelsSendMomentVC" dic:nil nav:self.navigationController];
}

#pragma mark - addNotification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(travelReloadData) name:@"DynamicSendNotification" object:nil];
}

- (void)travelReloadData {
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
