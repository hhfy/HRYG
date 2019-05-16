
//
//  TravelsAlbumVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsAlbumVC.h"
#import "TravelsAlbumCell.h"

@interface TravelsAlbumVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, strong) NSArray *photos;
@end

@implementation TravelsAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self getAlbumData];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getAlbumData)];
}

- (void)setupValue {
    self.title = self.titleText;
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
}

#pragma mark - 接口
// 获取相册数据
- (void)getAlbumData {
    NSString *header = [NSString stringWithFormat:@"scene/files/%@",self.shopId];
    NSString *url = [MainURL stringByAppendingPathComponent:header];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"shop_id"] = self.shopId;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:nil isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.photos = json[Data];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - collectionView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.photos) ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelsAlbumCell *cell = [TravelsAlbumCell cellFromXibWithTableView:tableView];
    cell.photosUrl = self.photos;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

@end
