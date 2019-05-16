
//
//  TravelsHotVenueVC.m
//  ZHLY
//
//  Created by LTWL on 2017/11/30.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsHotVenueVC.h"
#import "TravelsHotVenueHeaderView.h"
#import "TravelsHotVenueSectionHeaderView.h"
#import "TravelsHotVenueSectionFooerView.h"
#import "TravelsHotVenueHeaderCell.h"
#import "TravelsListCell.h"
#import "TravelsStrategyListCell.h"
#import "Travels.h"

@interface TravelsHotVenueVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *topBgImageView;
@property (nonatomic, weak) TravelsHotVenueHeaderView *headerView;
@property (nonatomic, weak) UIView *cover;
@property (nonatomic, strong) TravelStadium *stadium;
@property (nonatomic, strong) NSArray *notes;
@property (nonatomic, strong) NSArray *tips;
@property (nonatomic, strong) UIBarButtonItem *whiteItem;
@property (nonatomic, strong) UIBarButtonItem *blackItem;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) UIRefreshControl *refresh;
@end

@implementation TravelsHotVenueVC

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
    [self getHotVenueData];
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = self.whiteItem;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
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
    [refresh addTarget:self action:@selector(getHotVenueData) forControlEvents:UIControlEventValueChanged];
    [[refresh.subviews objectAtIndex:0] setCenter:CGPointMake(self.view.centerX, 50)];
    _refresh = refresh;
}

- (void)setupHeaderView {
    TravelsHotVenueHeaderView *headerView = [TravelsHotVenueHeaderView viewFromXib];
    self.tableView.tableHeaderView = headerView;
    _headerView = headerView;
    UIImageView *topBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, headerView.height)];
    topBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    topBgImageView.clipsToBounds = YES;
    topBgImageView.backgroundColor = SetupColor(222, 222, 222);
    [self.view insertSubview:topBgImageView atIndex:0];
    _topBgImageView = topBgImageView;
    
    UIView *cover = [[UIView alloc] initWithFrame:topBgImageView.bounds];
    cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [topBgImageView addSubview:cover];
    _cover = cover;
}

#pragma mark - 接口
// 热门场馆
- (void)getHotVenueData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"home/travel/index/stadium"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"stadium_id"] = self.stadiumId;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.stadium = [TravelStadium mj_objectWithKeyValues:json[Data][@"stadium"]];
        weakSelf.tips = [TravelNoteTip mj_objectArrayWithKeyValuesArray:json[Data][@"tips"]];
        weakSelf.notes = [TravelNoteTip mj_objectArrayWithKeyValuesArray:json[Data][@"notes"]];
        [weakSelf refreshData];
        [weakSelf.refresh endRefreshing];
        [weakSelf.tableView reloadData];
        [UITableViewAnmtionTool alphaAnimationWithTableView:weakSelf.tableView];
    } otherCase:^(NSInteger code) {
        [weakSelf.refresh endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.refresh endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)refreshData {
    [self.topBgImageView sd_setImageWithURL:SetURL(self.stadium.stadium_image)];
    self.headerView.stadium = self.stadium;
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.tips.count == 0 && self.notes.count == 0) {
        return 1;
    } else if (self.tips.count != 0 && self.notes.count != 0) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return (self.notes.count) ? self.notes.count : self.tips.count;
            break;
        case 2:
            return self.tips.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TravelsHotVenueHeaderCell *cell = [TravelsHotVenueHeaderCell cellFromXibWithTableView:tableView];
        cell.stadium = self.stadium;
        return cell;
    } else if (indexPath.section == 1) {
        if (self.notes.count) {
            TravelsListCell *cell = [TravelsListCell cellFromXibWithTableView:tableView];
            TravelNoteTip *noteTip = self.notes[indexPath.row];
            cell.noteTip = noteTip;
            return cell;
        } else {
            TravelsStrategyListCell *cell = [TravelsStrategyListCell cellFromXibWithTableView:tableView];
            TravelNoteTip *noteTip = self.tips[indexPath.row];
            cell.noteTip = noteTip;
            return cell;
        }
    } else {
        TravelsStrategyListCell *cell = [TravelsStrategyListCell cellFromXibWithTableView:tableView];
        TravelNoteTip *noteTip = self.tips[indexPath.row];
        cell.noteTip = noteTip;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TravelsHotVenueSectionHeaderView *headerView = [TravelsHotVenueSectionHeaderView headerFooterViewFromXibWithTableView:tableView];
    switch (section) {
        case 0:
            headerView.title = @"场馆简介";
            break;
        case 1:
            headerView.title = @"相关游记";
            break;
        case 2:
            headerView.title = @"相关攻略";
            break;
        default:
            break;
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TravelsHotVenueSectionFooerView *fooerView = [TravelsHotVenueSectionFooerView headerFooterViewFromXibWithTableView:tableView];
    fooerView.didTap = ^{
        switch (section) {
            case 1:
                [LaiMethod runtimePushVcName:@"TravelsTravelsVC" dic:@{@"stadiumId" : self.stadium.supplier_stadium_id} nav:CurrentViewController.navigationController];
                
                break;
            case 2:
                [LaiMethod runtimePushVcName:@"TravelsStrategyVC" dic:@{@"stadiumId" : self.stadium.supplier_stadium_id} nav:CurrentViewController.navigationController];
                break;
            default:
                break;
        }
    };
    return (section == 0) ? nil : fooerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 0) ? SpaceHeight : 55;
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
            self.title = self.titleText;
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
