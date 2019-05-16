//
//  HomeExhibitionHallOrderVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/25.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeExhibitionHallOrderVC.h"
#import "HomeExhibitionHallOrderHeaderCell.h"
#import "HomeShopBaseOrderAddTouristCell.h"
#import "HomeShopBaseOrderCommitView.h"
#import "Home.h"

@interface HomeExhibitionHallOrderVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) HomeMuseumUserVisitor *userVisitor;
@end

@implementation HomeExhibitionHallOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self setupBottomView];
    [self addNSNotification];
}

- (void)setupValue {
    self.title = @"填写订单";
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 20;
    tableView.estimatedSectionFooterHeight = 20;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupBottomView {
    HomeShopBaseOrderCommitView *commitView = [HomeShopBaseOrderCommitView viewFromXib];
    commitView.y = self.view.height - commitView.height - (NavHFit);
    [self.view addSubview:commitView];
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeExhibitionHallOrderHeaderCell *cell = [HomeExhibitionHallOrderHeaderCell cellFromXibWithTableView:tableView];
        return cell;
    } else if (indexPath.section == 1) {
        HomeShopBaseOrderAddTouristCell *cell = [HomeShopBaseOrderAddTouristCell cellFromXibWithTableView:tableView];
        cell.userVisitor = self.userVisitor;
        return cell;
    } else if (indexPath.section == 2) {
        ItemSelectBtnCell *cell = [ItemSelectBtnCell cellFromXibWithTableView:tableView];
        cell.cellHeight = 45;
        cell.title = @"发票";
        cell.selectedBtnMode = SelectedBtnModeSingle;
        return cell;
    } else {
        PaymentCell *cell = [PaymentCell cellFromXibWithTableView:tableView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

#pragma mark - addNSNotification
- (void)addNSNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserVisitor:) name:NeedAcceptDataNotification object:nil];
}

- (void)getUserVisitor:(NSNotification *)note {
    self.userVisitor = [HomeMuseumUserVisitor mj_objectWithKeyValues:note.userInfo];
    NSArray *cells = self.tableView.visibleCells;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (id cell in cells) {
        if ([cell isKindOfClass:[HomeShopBaseOrderAddTouristCell class]]) {
            [indexPaths addObject:[self.tableView indexPathForCell:cell]];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
@end
