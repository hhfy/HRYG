
//
//  ServiceVC.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceVC.h"
#import "ServiceHeaderView.h"
#import "ServiceSectionHeaderView.h"
#import "ServiceContentCell.h"
#import "Service.h"

@interface ServiceVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) ServiceHeaderView *headerView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property (nonatomic, strong) NSArray *questions;
@end

@implementation ServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupHeaderView];
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getCommonProblemData)];
    [self reloadDataHandle];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isPush){
        [self getCommonProblemData];
    }
}
- (void)setupValue {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupHeaderView {
    ServiceHeaderView *headerView = [ServiceHeaderView viewFromXib];
    [self.view addSubview:headerView];
    _headerView = headerView;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY, self.view.width, self.view.height - self.headerView.height - NavHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 45.f;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight + Height44 + SpaceHeight * 2, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)reloadDataHandle {
    WeakSelf(weakSelf)
    self.reloadData = ^{
        [weakSelf getCommonProblemData];
    };
    self.networkForOnline = ^{
        [weakSelf getCommonProblemData];
    };
}

#pragma mark - 接口
// 获取常见问题数据
- (void)getCommonProblemData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"customer/index"];
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:nil isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.questions = [ServiceCommonQuestion mj_objectArrayWithKeyValuesArray:json[Data]];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ServiceCommonQuestion *commonQuestion = self.questions[section];
    return commonQuestion.question.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceContentCell *cell = [ServiceContentCell cellFromXibWithTableView:tableView];
    ServiceCommonQuestion *commonQuestion = self.questions[indexPath.section];
    ServiceCommonQuestionDetial *questionDetial = commonQuestion.question[indexPath.row];
    cell.questionDetial = questionDetial;
    if (indexPath == self.selectedIndexPath) {
        cell.openType = CellOpenTypeOpen;
    } else {
        cell.openType = CellOpenTypeClose;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ServiceSectionHeaderView *headerView = [ServiceSectionHeaderView headerFooterViewFromXibWithTableView:tableView];
    ServiceCommonQuestion *commonQuestion = self.questions[section];
    headerView.commonQuestion = commonQuestion;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = SetupColor(242, 242, 242);
    return (section == self.questions.count - 1) ? nil : view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.lastSelectedIndexPath = self.selectedIndexPath;
    if (cell.openType == CellOpenTypeOpen) {
        self.selectedIndexPath = nil;
        cell.openType = CellOpenTypeClose;
    } else {
        self.selectedIndexPath = indexPath;
        cell.openType = CellOpenTypeOpen;
    }
    [tableView reloadData];
}

@end
