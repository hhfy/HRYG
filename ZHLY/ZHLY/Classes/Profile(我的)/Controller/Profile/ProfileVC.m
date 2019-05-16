//
//  ProfileVC.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileVC.h"
#import "ProfileHeaderView.h"
#import "ProfileItemCell.h"
#import "Profile.h"
#import "ProfileOrderListVC.h"


@interface ProfileVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) ProfileHeaderView *headerView;

@end

@implementation ProfileVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getProfileData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupHeaderView];
}

- (void)setupHeaderView {
    ProfileHeaderView *headerView = [ProfileHeaderView viewFromXib];
    self.tableView.tableHeaderView = headerView;
    _headerView = headerView;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
    
    WeakSelf(weakSelf)
    [LaiMethod setupElasticPullRefreshWithTableView:tableView loadingViewCircleColor:MainThemeColor ElasticPullFillColor:[UIColor whiteColor] actionHandler:^{
         [weakSelf getProfileData];
    }];
}

#pragma mark - 接口
// 获取个人中心信息
- (void)getProfileData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"member/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.headerView.profileInfo = [ProfileInfo mj_objectWithKeyValues:json[Data]];
        [weakSelf.tableView stopLoading];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView stopLoading];
    } failure:^(NSError *error) {
        [weakSelf.tableView stopLoading];
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemArrowCell *cell = [ItemArrowCell cellFromXibWithTableView:tableView];
    cell.cellHeight = 50;
    cell.titleFont = TextSystemFont(15);
    cell.lineLeftW = 0;
    WeakSelf(weakSelf)
    switch (indexPath.section) {
        case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.title = @"我的订单";
                        cell.text = @"全部订单";
                        cell.textAlign = NSTextAlignmentRight;
                        cell.didTap = ^{
                            ProfileOrderListVC *orderVC = [[ProfileOrderListVC alloc]init];
                            orderVC.titleString = @"我的订单";
                            orderVC.fromAllOrder = YES;
                            [self.navigationController pushViewController:orderVC animated:YES];
                        };
                    }
                        break;
                    case 1:
                    {
                        ProfileItemCell *cell = [ProfileItemCell cellFromXibWithTableView:tableView];
                        cell.btnActionBlock = ^(NSInteger tag) {
                            ProfileOrderListVC *baseVC = [[ProfileOrderListVC alloc]init];
                            baseVC.titleString = @"我的订单";
                            baseVC.indexType = tag;
                            [self.navigationController pushViewController:baseVC animated:YES];
                        };
                        return cell;
                    }
                        break;
                    default:
                        break;
                }
            }
            break;
        case 1:
            {
                cell.title = @"飞马券";
                cell.icon = @"飞马券";
                cell.didTap = ^ {
                    [LaiMethod runtimePushVcName:@"ProfileCouponVC" dic:nil nav:weakSelf.navigationController];
                };
            }
            break;
        case 2:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.title = @"我的游记";
                        cell.icon = @"我的游记";
                        cell.lineLeftW = 15;
                        cell.didTap = ^{
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            params[@"urlStr"] = @"notes/mine";
                            [LaiMethod runtimePushVcName:@"TravelsTravelsVC" dic:params nav:weakSelf.navigationController];
                        };
                    }
                        break;
                    case 1:
                    {
                        cell.title = @"我的动态";
                        cell.icon = @"我的动态";
                        cell.lineLeftW = 15;
                        cell.didTap = ^{
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            params[@"urlStr"] = @"tweet/mine";
                            [LaiMethod runtimePushVcName:@"TravelsMonentVC" dic:params nav:weakSelf.navigationController];
                        };
                    }
                        break;
                    case 2:
                    {
                        cell.title = @"意见反馈";
                        cell.icon = @"意见反馈";
                        cell.didTap = ^{
                            [LaiMethod runtimePushVcName:@"ProfileFeedBackVC" dic:nil nav:weakSelf.navigationController];
                        };
                    }
                        break;
                    default:
                        break;
                }
            }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

- (void)dealloc {
    [self.tableView removeJElasticPullToRefreshView];
}

@end


