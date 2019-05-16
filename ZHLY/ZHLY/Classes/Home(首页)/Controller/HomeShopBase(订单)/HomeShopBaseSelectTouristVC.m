
//
//  HomeMuseumSelectTouristVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseSelectTouristVC.h"
#import "HomeShopBaseSelectTouristCell.h"
#import "HomeShopBaseSelectTouristAddView.h"
#import "Home.h"
#import "HomeShopBaseEditTouristVC.h"

@interface HomeShopBaseSelectTouristVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *tourists;
@property (nonatomic, weak) HomeShopBaseSelectTouristAddView *addView;
@end

@implementation HomeShopBaseSelectTouristVC

- (NSMutableArray *)tourists {
    if (_tourists == nil) {
        _tourists = [NSMutableArray array];
    }
    return _tourists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self setupAddView];
    [self getNewTouristData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewTouristData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getMoreTouristData)];
    [self addNSNotification];
}

- (void)setupValue {
    self.title = @"选择游客";
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
    tableView.placeholderText = @"暂无乘客";
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupAddView {
    HomeShopBaseSelectTouristAddView *addView = [HomeShopBaseSelectTouristAddView viewFromXib];
    addView.y = self.view.height - addView.height - NavHeight;
    [self.view addSubview:addView];
    _addView = addView;
}

#pragma mark - 接口
// 获取游客列表
- (void)getNewTouristData {
    self.currentPage = 1;
    WeakSelf(weakSelf)
    [self getTouristDataWithSuccessHandle:^{
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
    }];
}

- (void)getMoreTouristData {
    self.currentPage++;
    [self getTouristDataWithSuccessHandle:nil];
}

- (void)getTouristDataWithSuccessHandle:(void (^)(void))successHandle {
    NSString *url = [MainURL stringByAppendingPathComponent:@"visitor/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[Page] = @(self.currentPage);
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.tourists removeAllObjects];
        NSInteger oldCount = weakSelf.tourists.count;
        NSArray *touristArr = [HomeMuseumUserVisitor mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.tourists addObjectsFromArray:touristArr];
        if (weakSelf.tourists.count == [json[Data][Total] integerValue]) {
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
        [weakSelf.tourists removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

// 删除游客
- (void)postDeleteTouristRequestWithVisitorId:(NSString *)visitorId handel:(void(^)(void))handel {
    NSString *url = [MainURL stringByAppendingPathComponent:@"visitor/delete"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"biz_visitor_id"] = visitorId;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        if (handel) handel();
    } otherCase:nil failure:^(NSError *error) {
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tourists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeShopBaseSelectTouristCell *cell = [HomeShopBaseSelectTouristCell cellFromXibWithTableView:tableView];
    HomeMuseumUserVisitor *userVisitor = self.tourists[indexPath.row];
    cell.userVisitor = userVisitor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeMuseumUserVisitor *userVisitor = self.tourists[indexPath.row];
    NSDictionary *params = [NSDictionary createDictionayFromModelPropertiesWithObj:userVisitor];
    [[NSNotificationCenter defaultCenter] postNotificationName:NeedAcceptDataNotification object:nil userInfo:params];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除游客";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WeakSelf(weakSelf)
        [LaiMethod alertSPAlerSheetControllerWithTitle:nil message:@"删除当前游客信息" defaultActionTitles:nil destructiveTitle:@"删除" cancelTitle:@"取消" handler:^(NSInteger actionIndex) {
            HomeMuseumUserVisitor *userVisitor = weakSelf.tourists[indexPath.row];
            [weakSelf postDeleteTouristRequestWithVisitorId:userVisitor.biz_visitor_id handel:^{
                [weakSelf.tourists removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }];
        }];
    }
}

#pragma mark - addNSNotification
- (void)addNSNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewTouristData) name:NeedReloadDataNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
