
//
//  HomeGoodsOrderVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeGoodsOrderVC.h"
#import "HomeGoodsOrderCell.h"

@interface HomeGoodsOrderVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation HomeGoodsOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
}

- (void)setupValue {
    self.title = @"确认订单";
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


#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ItemTextCell *cell = [ItemTextCell cellFromXibWithTableView:tableView];
        cell.cellHeight = 45;
        cell.textAlignment = NSTextAlignmentRight;
        switch (indexPath.row) {
            case 0:
            {
                HomeGoodsOrderCell *cell = [HomeGoodsOrderCell cellFromXibWithTableView:tableView];
                return cell;
            }
                break;
            case 1:
            {
                cell.title = @"已选规格";
                cell.text = @"礼盒装";
            }
                break;
            case 2:
            {
                cell.title = @"数量";
                cell.text = @"x3";
            }
                break;
            default:
                break;
            }
        return cell;
    } else {
        PaymentCell *cell = [PaymentCell cellFromXibWithTableView:tableView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

@end
