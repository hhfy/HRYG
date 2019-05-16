//
//  ProfileOrderRefundReasonVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/15.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileOrderRefundReasonVC.h"
#import "ContentTextViewCell.h"

@interface ProfileOrderRefundReasonVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) NSString *text;

@end

@implementation ProfileOrderRefundReasonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
}

- (void)setupValue {
    self.title = @"退款申请";
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
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    ContentTextViewCell *cell = [ContentTextViewCell cellFromXibWithTableView:tableView];
    cell.didInput = ^(NSString *text) {
        weakSelf.text = text;
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.width-40)/2, 5, 40, 40)];
    imgView.image = [UIImage imageNamed:@"退款"];
    [backView addSubview:imgView];
    return backView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WeakSelf(weakSelf)
    NormalBottomView *commitView = [NormalBottomView viewFromXib];
    commitView.title = @"确认退款";
    commitView.didTap = ^{
        [weakSelf.view endEditing:YES];
        if (!weakSelf.text) {
            [SVProgressHUD showError:@"请填写退款理由"];
        }
        else {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"biz_order_id"] = weakSelf.biz_order_id;
            params[Token] = weakSelf.token;
            params[@"refund_reason"] = weakSelf.text;
            NSString *url = [MainURL stringByAppendingPathComponent:@"order/refund"];
            [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
                [SVProgressHUD showSuccess:@"恭喜你,退款成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } otherCase:nil failure:nil];
        }
    };
    return commitView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
