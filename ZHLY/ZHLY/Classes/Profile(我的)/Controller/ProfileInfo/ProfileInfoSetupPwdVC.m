//
//  ProfileInfoSetupPwdVC.m
//
//  Created by LTWL on 2017/8/19.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileInfoSetupPwdVC.h"

@interface ProfileInfoSetupPwdVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *originalPwd;
@property (nonatomic, copy) NSString *currentPwd;
@property (nonatomic, copy) NSString *confirmPwd;
@property (nonatomic, weak) NormalBottomView *confirmView;
@end

@implementation ProfileInfoSetupPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self setupBottomView];
}

- (void)setupValue {
    self.title = @"修改密码";
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupBottomView {
    NormalBottomView *confirmView = [NormalBottomView viewFromXib];
    confirmView.title = @"确定提交";
    [confirmView addTarget:self action:@selector(confirmViewAction)];
    self.tableView.tableFooterView = confirmView;
    _confirmView = confirmView;
}

#pragma mark - 接口
- (void)postSetupPwdRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"member/password"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"old_password"] = self.originalPwd;
    params[@"password"] = self.currentPwd;
    params[@"confirm_password"] = self.confirmPwd;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } otherCase:nil failure:nil];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTextFiledCell *cell = [ItemTextFiledCell cellFromXibWithTableView:tableView];
    cell.cellHeight = 55;
    cell.tag = indexPath.row;
    cell.placeholderColor = SetupColor(167, 142, 142);
    cell.isSecureTextEntry = YES;
    switch (indexPath.row) {
        case 0:
        {
            cell.placeholderText = @"请输入当前密码";
            cell.textDidChange = ^(NSString *text) {
                self.originalPwd = text;
            };
        }
            break;
        case 1:
        {
            cell.placeholderText = @"请输入新密码";
            cell.textDidChange = ^(NSString *text) {
                self.currentPwd = text;
            };
        }
            break;
        case 2:
        {
            cell.placeholderText = @"请再次输入新密码";
            cell.textDidChange = ^(NSString *text) {
                self.confirmPwd = text;
            };
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
    return SpaceHeight * 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - confirmViewAction
- (void)confirmViewAction {
    [self.view endEditing:YES];
    if (!self.originalPwd || [self.originalPwd isEqualToString:@""]) {
        [SVProgressHUD showError:@"请输入当前密码"];
        [LaiMethod wrongInputAnimationWith:[self itemTextFiledCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
        return;
    } else if (!self.currentPwd || [self.currentPwd isEqualToString:@""]) {
        [LaiMethod wrongInputAnimationWith:[self itemTextFiledCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
        [SVProgressHUD showError:@"请输入新密码"];
        return;
    } else if (self.currentPwd.length<6 || self.currentPwd.length>18) {
       [LaiMethod wrongInputAnimationWith:[self itemTextFiledCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
        [SVProgressHUD showError:@"密码必须为6-18位数字字母"];
        return;
    } else if (!self.confirmPwd || [self.confirmPwd isEqualToString:@""]) {
        [LaiMethod wrongInputAnimationWith:[self itemTextFiledCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]];
        [SVProgressHUD showError:@"请再次输入新密码"];
        return;
    } else if (![self.currentPwd isEqualToString:self.confirmPwd]) {
        [SVProgressHUD showError:@"两次输入的密码不一致"];
        [LaiMethod wrongInputAnimationWith:[self itemTextFiledCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
        [LaiMethod wrongInputAnimationWith:[self itemTextFiledCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]];
        return;
    }
    [self postSetupPwdRequest];
}

- (ItemTextFiledCell *)itemTextFiledCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

@end
