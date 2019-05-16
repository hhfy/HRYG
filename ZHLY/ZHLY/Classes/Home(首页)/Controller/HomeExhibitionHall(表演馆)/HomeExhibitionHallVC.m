//
//  HomeExhibitionHallViewController.m
//  ZHLY
//  展览馆
//  Created by LTWL on 2017/12/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeExhibitionHallVC.h"
#import "HomeExhibitionHallHeaderView.h"
#import "HomeExhibitionHallChoiceCell.h"
#import "HomeExhibitionHallDetialCell.h"
#import "HomeExhibitionHallSelectSeatView.h"

@interface HomeExhibitionHallVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *whiteItem;
@property (nonatomic, strong) UIBarButtonItem *blackItem;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *topBgImageView;
@property (nonatomic, weak) HomeExhibitionHallHeaderView *headerView;
@property (nonatomic, weak) UIRefreshControl *refresh;
@end

@implementation HomeExhibitionHallVC

#pragma mark - 懒加载
- (UIBarButtonItem *)whiteItem
{
    if (_whiteItem == nil)
    {
        _whiteItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) title:LeftArrowIconUnicode nomalColor:[UIColor whiteColor] hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:-25 bottom:0 right:0];
    }
    return _whiteItem;
}

- (UIBarButtonItem *)blackItem
{
    if (_blackItem == nil)
    {
        _blackItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) title:LeftArrowIconUnicode nomalColor:SetupColor(51, 51, 51) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:-25 bottom:0 right:0];
    }
    return _blackItem;
}

- (UIImage *)shadowImage
{
    if (_shadowImage == nil)
    {
        _shadowImage = [UINavigationController new].navigationBar.shadowImage;
    }
    return _shadowImage;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:(iPhoneX) ? SetImage(@"navigationbarBackgroundWhite_X") : SetImage(@"navigationbarBackgroundWhite") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:self.shadowImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = nil;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setupNav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupHeaderView];
    [self setupBottomView];
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
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor whiteColor];
    [tableView addSubview:refresh];
    [refresh addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    [[refresh.subviews objectAtIndex:0] setCenter:CGPointMake(self.view.centerX, 50)];
}

- (void)pullToRefresh:(UIRefreshControl *)refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refresh endRefreshing];
    });
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = self.whiteItem;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setupHeaderView {
    HomeExhibitionHallHeaderView *headerView = [HomeExhibitionHallHeaderView viewFromXib];
    self.tableView.tableHeaderView = headerView;
    _headerView = headerView;
    
    UIImageView *topBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, headerView.height - 10)];
    topBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    topBgImageView.clipsToBounds = YES;
    topBgImageView.backgroundColor = SetupColor(222, 222, 222);
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr loadImageWithURL:SetURL(@"http://123.206.204.145:8082/Uploads/171127524772.png") options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        topBgImageView.image = [UIImage boxBlurImage:image withLevel:0.1];
    }];
    
    
    [self.view insertSubview:topBgImageView atIndex:0];
    _topBgImageView = topBgImageView;
    
    UIView *cover = [[UIView alloc] initWithFrame:topBgImageView.bounds];
    cover.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
    [topBgImageView addSubview:cover];
}

- (void)setupBottomView {
    HomeExhibitionHallSelectSeatView *bottomView = [HomeExhibitionHallSelectSeatView viewFromXib];
    bottomView.y = self.view.height - bottomView.height;
    [self.view addSubview:bottomView];
    WeakSelf(weakSelf)
    bottomView.selectSeat = ^{
        [LaiMethod runtimePushVcName:@"HomeExhibitionHallOrderVC" dic:nil nav:weakSelf.navigationController];
    };
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeExhibitionHallChoiceCell *cell = [HomeExhibitionHallChoiceCell cellFromXibWithTableView:tableView];
        return cell;
    } else if (indexPath.section == 1) {
        ItemArrowCell *cell = [ItemArrowCell cellFromXibWithTableView:tableView];
        cell.title = @"购票须知";
        cell.cellHeight = 45;
        cell.titleFont = TextBoldFont(15);
        WeakSelf(weakSelf)
        cell.didTap = ^{
            [LaiMethod runtimePushVcName:@"HomeExhibitionHallSelectSeatVC" dic:nil nav:weakSelf.navigationController];
        };
        return cell;
    }
    else {
        HomeExhibitionHallDetialCell *cell = [HomeExhibitionHallDetialCell cellFromXibWithTableView:tableView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat down = -scrollView.contentOffset.y;
    self.topBgImageView.y = down;
    CGFloat scale = down / self.headerView.height;
    if (scale > 0) self.topBgImageView.transform = CGAffineTransformMakeScale(1 + scale, 1 + scale);
    if (self.topBgImageView.y >= 0 && down >= 0) self.topBgImageView.y = 0;
    
    CGFloat alpha = scrollView.contentOffset.y / (NavHeight + 100);
    if (alpha >= 1) {
        if (self.navigationController.navigationBar.shadowImage != self.shadowImage && self.navigationItem.leftBarButtonItem != self.blackItem) {
            self.title = @"表演馆";
            alpha = 1;
            self.navigationController.navigationBar.shadowImage = self.shadowImage;
            self.navigationItem.leftBarButtonItem = self.blackItem;
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
        }
    } else {
        self.title = nil;
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.navigationItem.leftBarButtonItem = self.whiteItem;
        UIImage *image = [UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - back
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
