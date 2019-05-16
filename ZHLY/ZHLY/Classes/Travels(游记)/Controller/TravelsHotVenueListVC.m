//
//  TravelsHotVenueListVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/5.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "TravelsHotVenueListVC.h"
#import "Home.h"
#import "TravelsHotVenueSectionHeaderView.h"
#import "TravelsHotVenueSectionFooerView.h"
#import "Travels.h"
#import "TravelsListCell.h"
#import "TravelsStrategyListCell.h"
#import "TravelsShopBaseHeaderView.h"

@interface TravelsHotVenueListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) HomeMuseumInfo *museumInfo;
@property (nonatomic, strong) NSMutableArray *strategies;
@property (nonatomic, strong) NSMutableArray *travels;
@property (nonatomic, weak) TravelsShopBaseHeaderView *travelsHeaderView;
@end

@implementation TravelsHotVenueListVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fromTravels = YES;
    [self setupTableView];
    [self getHotVenueData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 20;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight, 0);
    tableView.placeholderText = @"暂无数据";
    tableView.placeholderImage = SetImage(@"暂无商品");
    [self.view addSubview:tableView];
    _tableView = tableView;
}


- (void)setupHeaderData {
    TravelsShopBaseHeaderView *headerView = [TravelsShopBaseHeaderView viewFromXib];
    _travelsHeaderView = headerView;
    HomeShopBaseInfo *info = [HomeShopBaseInfo new];
    info.banner = self.museumInfo.scene_image;
    info.bannerCount = self.museumInfo.scene_photo_album_count;
    info.shopName = self.museumInfo.scene_name;
    info.address = self.museumInfo.scene_address;
    info.commentCount = [self.museumInfo.scene_evaluate_num integerValue];
    info.leftViewTitle = @"景点介绍";
    info.leftViewDetialText = @"开放时间、注意事项";
    info.shopId = self.museumInfo.supplier_scene_id;
    NSString *museumUrl = [NSString stringWithFormat:@"scene/detail/%@?channel_pot_id=%@",self.key,ChannelPotId];
    info.detialApi = [MainURL stringByAppendingPathComponent:museumUrl];
    self.travelsHeaderView.info = info;
    self.tableView.tableHeaderView = self.travelsHeaderView;
}

#pragma mark - 接口
// 景点
- (void)getHotVenueData {
    NSString *museumUrl = [NSString stringWithFormat:@"scene/index/%@",self.key];
    NSString *url = [MainURL stringByAppendingPathComponent:museumUrl];
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:nil isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.museumInfo = [HomeMuseumInfo mj_objectWithKeyValues:json[Data]];
        if(weakSelf.museumInfo){
            [weakSelf setupHeaderData];
            [self getStrategyData];
        }
    } otherCase:^(NSInteger code) {
    } failure:^(NSError *error) {
    }];
}

-(void)getStrategyData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"tips/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"stadium_basic_id"] = self.stadiumId;
    params[Page] = @(1);
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        NSArray *strategyArr = [TravelNoteTip mj_objectArrayWithKeyValuesArray:json[Data][List]];
        weakSelf.strategies = [NSMutableArray arrayWithArray:strategyArr];
        [self getTravelsData];
    } otherCase:^(NSInteger code) {
        [self getTravelsData];
    } failure:^(NSError *error) {
    }];
}

-(void)getTravelsData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"notes/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"stadium_basic_id"] = self.stadiumId;
    params[Token] = self.token;
    params[Page] = @(1);
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        NSArray *strategyArr = [TravelNoteTip mj_objectArrayWithKeyValuesArray:json[Data][List]];
        weakSelf.travels = [NSMutableArray arrayWithArray:strategyArr];
        
        [weakSelf.tableView reloadData];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.strategies.count;
            break;
        case 1:
            return self.travels.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TravelsListCell *cell = [TravelsListCell cellFromXibWithTableView:tableView];
        TravelNoteTip *noteTip = self.strategies[indexPath.row];
        cell.noteTip = noteTip;
        return cell;
    }
    else {
        TravelsStrategyListCell *cell = [TravelsStrategyListCell cellFromXibWithTableView:tableView];
        TravelNoteTip *noteTip = self.travels[indexPath.row];
        cell.noteTip = noteTip;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return (self.strategies.count>0) ? 55 : NoneSpace;
    }
    else {
        return (self.travels.count>0) ? 55 : NoneSpace;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TravelsHotVenueSectionHeaderView *headerView = [TravelsHotVenueSectionHeaderView headerFooterViewFromXibWithTableView:tableView];
    if (section == 0) {
        headerView.title = @"相关游记";
        return (self.strategies.count>0) ? headerView : nil;
    }
    else {
        headerView.title = @"相关攻略";
        return (self.travels.count>0) ? headerView : nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TravelsHotVenueSectionFooerView *fooerView = [TravelsHotVenueSectionFooerView headerFooterViewFromXibWithTableView:tableView];
    fooerView.didTap = ^{
        switch (section) {
            case 0:
                [LaiMethod runtimePushVcName:@"TravelsTravelsVC" dic:@{@"stadiumId" : self.stadiumId} nav:CurrentViewController.navigationController];
                
                break;
            case 1:
                [LaiMethod runtimePushVcName:@"TravelsStrategyVC" dic:@{@"stadiumId" : self.stadiumId} nav:CurrentViewController.navigationController];
                break;
            default:
                break;
        }
    };
    if (section == 0) {
        return (self.strategies.count>0) ? fooerView : nil;
    }
    else {
        return (self.travels.count>0) ? fooerView : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return (self.strategies.count>0) ? 55 : NoneSpace;
    }
    else {
        return (self.travels.count>0) ? 55 : NoneSpace;
    }
}



@end
