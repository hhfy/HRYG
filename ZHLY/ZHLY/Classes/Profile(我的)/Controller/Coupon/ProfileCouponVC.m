//
//  ProfileCouponVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/14.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileCouponVC.h"
#import "Profile.h"
#import "ProfileCouponCell.h"

@interface ProfileCouponVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, strong) NSMutableArray *couponArr;
@end

@implementation ProfileCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"领券中心";
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewData)];
    [self getNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - NavHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 30.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}
#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.couponArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCouponCell *cell = [ProfileCouponCell cellFromXibWithTableView:tableView];
    ProfileCoupon *coupon = self.couponArr[indexPath.section];
    cell.coupon = coupon;
    cell.couponBlock = ^{
        [self getNewData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)getNewData {
    self.page = 1;
    [self getCouponData];
}

- (void)getMoreStudyData {
    self.page++;
    [self getCouponData];
}
- (void)getCouponData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"promotion/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[Page] = @(self.page);
    
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:NO progress:nil success:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSArray *arr = [ProfileCoupon mj_objectArrayWithKeyValuesArray:json[Data][List]];
        if (arr) {
            [LaiMethod setupUpRefreshWithTableView:weakSelf.tableView target:self action:@selector(getMoreStudyData)];
        }
        if (weakSelf.page >1) {
            [weakSelf.couponArr addObjectsFromArray:arr];
        }
        else {
            if (arr) {
                weakSelf.couponArr = [[NSMutableArray alloc] initWithArray:arr];
            }
        }
        if (arr.count<15) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        if (weakSelf.page > 1) weakSelf.page--;
        [weakSelf.couponArr removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}



@end
