//
//  HomeSeasonTicketOrderInfoView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/20.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeSeasonTicketOrderInfoView.h"
#import "HomeSeasonTicketOrderInfoWithCell.h"
#import "Home.h"

@interface HomeSeasonTicketOrderInfoView () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@end

@implementation HomeSeasonTicketOrderInfoView

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
}


-(void)setOrderPackage:(HomeSeasonTicketOrderPackage *)orderPackage {
    _orderPackage = orderPackage;
    [self.contentTableView reloadData];
}

- (IBAction)confirmBtn:(UIButton *)button {
    if (self.dismiss) self.dismiss();
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderPackage.ticket_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeSeasonTicketOrderInfoWithCell *cell = [HomeSeasonTicketOrderInfoWithCell cellFromXibWithTableView:tableView];
    HomeSeasonTicketOrderTicketList *ticket = self.orderPackage.ticket_list[indexPath.row];
    cell.ticket = ticket;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}
@end
