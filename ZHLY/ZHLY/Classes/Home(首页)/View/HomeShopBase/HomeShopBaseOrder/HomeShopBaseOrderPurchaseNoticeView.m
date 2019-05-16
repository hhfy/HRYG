//
//  HomeShopBaseOrderPurchaseNoticeView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/20.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderPurchaseNoticeView.h"
#import "HomeShopBaseOrderPurchaseNoticeCell.h"

@interface HomeShopBaseOrderPurchaseNoticeView () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@end

@implementation HomeShopBaseOrderPurchaseNoticeView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.height = MainScreenSize.height - 250;
    self.contentTableView.estimatedRowHeight = 45.0f;
    self.contentTableView.estimatedSectionHeaderHeight = 20;
    self.contentTableView.estimatedSectionFooterHeight = 0;
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.isHideNoDataView = YES;
}

- (void)setContent:(NSArray *)content {
    _content = content;
    [self.contentTableView reloadData];
}

- (IBAction)confirmBtn:(UIButton *)button {
    if (self.dismiss) self.dismiss();
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeShopBaseOrderPurchaseNoticeCell *cell = [HomeShopBaseOrderPurchaseNoticeCell cellFromXibWithTableView:tableView];
    switch (indexPath.row) {
        case 0:
            cell.title = @"购买须知";
            break;
        case 1:
            cell.title = @"退票须知";
            break;
        case 2:
            cell.title = @"使用须知";
            break;
//        case 3:
//            cell.title = @"费用不包含";
//            break;
        default:
            break;
    }
    cell.content = self.content[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}
@end
