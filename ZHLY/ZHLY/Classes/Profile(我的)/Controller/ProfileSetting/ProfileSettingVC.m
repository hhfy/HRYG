
//
//  ProfileSettingVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileSettingVC.h"
#import "LoginVC.h"

@interface ProfileSettingVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation ProfileSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVlaue];
    [self setupTableView];
    [self setupBottomView];
}

- (void)setupVlaue {
    self.title = @"设置";
}

- (void)setupBottomView {
    NormalBottomView *logoutView = [NormalBottomView viewFromXib];
    logoutView.title = @"退出账号";
    logoutView.btnBgColor = MainThemeColor;
    self.tableView.tableFooterView = logoutView;
    logoutView.didTap = ^{
        [LaiMethod alertSPAlerSheetControllerWithTitle:nil message:nil defaultActionTitles:nil destructiveTitle:@"退出登录" cancelTitle:@"取消" handler:^(NSInteger actionIndex) {
            [SaveTool setBool:NO forKey:IsLoginOut];
            [LaiMethod loginAndLogoutAnmitonWithTargetVc:[[NavigationController alloc] initWithRootViewController:[LoginVC new]] subtype:kCATransitionFromBottom];
        }];
    };
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
}


#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemArrowCell *cell = [ItemArrowCell cellFromXibWithTableView:tableView];
    cell.cellHeight = 50;
    cell.textAlign = NSTextAlignmentRight;
    cell.icon = nil;
    switch (indexPath.row) {
        case 0:
        {
            NSString *caches = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"default"];
            NSString *cacheSize = [NSString getBytesFromDataLength:caches.fileSize];
            cell.title = @"清除缓存";
            cell.text = cacheSize;
        }
            break;
        case 1:
            cell.title = @"欢迎页";
            break;
        case 2:
            cell.title = @"关于我们";
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
    return SpaceHeight * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            {
                WeakSelf(weakSelf)
                [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
                    NSString *caches = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"default"];
                    NSString *cacheSize = [NSString getBytesFromDataLength:caches.fileSize];
                    NSFileManager *mgr = [NSFileManager defaultManager];
                    // 删除cache文件夹
                    [[SDImageCache sharedImageCache] clearMemory];
                    [mgr removeItemAtPath:caches error:nil];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        if ([cacheSize isEqualToString:@"0B"]) {
                            [SVProgressHUD showSuccess:@"缓存已清理"];
                        }
                        else
                        {
                            [SVProgressHUD showSuccess:[NSString stringWithFormat:@"成功清理%@缓存", cacheSize]];
                            [weakSelf.tableView reloadData];
                        }
                    }];
                }];
            }
            break;
        case 2:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"titleText"] = @"关于我们";
            params[@"apiUrl"] = [MainURL stringByAppendingPathComponent:@"home/system/about"];
            [LaiMethod runtimePushVcName:@"ProfileDetailWebVC" dic:params nav:self.navigationController];
        }
            break;
        default:
            break;
    }
}

@end
