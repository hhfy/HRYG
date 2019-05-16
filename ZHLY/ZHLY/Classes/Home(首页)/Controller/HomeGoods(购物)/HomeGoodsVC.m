

//
//  HomeGoodsVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeGoodsVC.h"
#import "HomeGoodsCell.h"
#import "Home.h"

@interface HomeGoodsVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *goods;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation HomeGoodsVC

- (NSMutableArray *)goods
{
    if (_goods == nil)
    {
        _goods = [NSMutableArray array];
    }
    return _goods;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTableView];
    [self getNewGoodsData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewGoodsData)];
    [LaiMethod setupUpRefreshWithTableView:self.tableView target:self action:@selector(getMoreGoodsData)];
    [LaiMethod runtimePushVcName:@"HomeGoodsOrderVC" dic:nil nav:self.navigationController];
}

- (void)setupValue {
    self.title = @"商品";
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shoppingCarAction) title:ShoppingCarIconUnicode nomalColor:SetupColor(51, 51, 51) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(22) top:0 left:0 bottom:0 right:0];
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
    tableView.placeholderImage = SetImage(@"暂无商品");
    tableView.placeholderText = @"暂无商品";
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
// 获取商品数据
- (void)getNewGoodsData {
    self.currentPage = 1;
    [self getGoodsData];
}

- (void)getMoreGoodsData {
    self.currentPage++;
    [self getGoodsData];
}

- (void)getGoodsData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"home/goods/goods/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Page] = @(self.currentPage);
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.goods removeAllObjects];
        NSArray *goodArr = [HomeGoods mj_objectArrayWithKeyValuesArray:json[Data][List]];
        NSInteger oldCount = weakSelf.goods.count;
        [weakSelf.goods addObjectsFromArray:goodArr];
        if (weakSelf.goods.count == [json[Data][Total] integerValue]) {
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
        [weakSelf.goods removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeGoodsCell *cell = [HomeGoodsCell cellFromXibWithTableView:tableView];
    HomeGoods *goods = self.goods[indexPath.row];
    cell.goods = goods;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

#pragma mark - shoppingCarAction
- (void)shoppingCarAction {
    [LaiMethod runtimePushVcName:@"HomeShoppingCarVC" dic:nil nav:self.navigationController];
}

@end
