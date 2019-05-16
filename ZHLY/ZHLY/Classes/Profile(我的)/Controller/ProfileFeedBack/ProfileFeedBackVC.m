

//
//  ProfileFeedBackVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/7.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileFeedBackVC.h"
#import "ServiceLeaveMsgTypeCell.h"
#import "ServiceLeaveMsgTextViewCell.h"
#import "Profile.h"

@interface ProfileFeedBackVC () <UITableViewDelegate, UITableViewDataSource, CustomDatePickerDelegate, CustomDatePickerDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *quesetionType;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) ProfileFeedbackType *feedbackType;
@property (nonatomic, strong) NSArray *feedbackTypes;
@property (nonatomic, weak) CustomDatePicker *pickerView;
@end

@implementation ProfileFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self setupCommitView];
}

- (void)setupValue {
    self.title = @"意见反馈";
    [self setupNav];
}
- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(myFeedBackMsg) title:@"我的反馈" nomalColor:SetupColor(51, 51, 51) hightLightColor:SetupColor(180, 180, 180) titleFont:TextSystemFont(14) top:0 left:0 bottom:0 right:0];
}

-(void)myFeedBackMsg {
    [LaiMethod runtimePushVcName:@"ProfileMyFeedBackVC" dic:nil nav:self.navigationController];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 20;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupCommitView {
    WeakSelf(weakSelf)
    NormalBottomView *commitView = [NormalBottomView viewFromXib];
    commitView.title = @"确认提交";
    commitView.didTap = ^{
        [weakSelf.view endEditing:YES];
        if (!weakSelf.feedbackType) {
            [SVProgressHUD showError:@"请选择意见类型"];
        } else if (!self.mobile) {
            [SVProgressHUD showError:@"请输入手机号"];
        } else if (!self.text) {
            [SVProgressHUD showError:@"请输入您要反馈的意见"];
        } else {
            [weakSelf postFeedBackRequset];
        }
    };
    self.tableView.tableFooterView = commitView;
}

#pragma mark - 接口
// 获取意见类型数据
- (void)getFeedBackTypeData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"feedback/type"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;

    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:NO progress:nil success:^(id json) {
        weakSelf.feedbackTypes = [ProfileFeedbackType mj_objectArrayWithKeyValuesArray:json[Data]];
        if (weakSelf.feedbackTypes.count == 0) {
            [SVProgressHUD showError:@"赞无意见类型"];
        } else {
            weakSelf.pickerView = [LaiMethod setupCustomPickerWithTitle:@"选择问题类型" delegate:weakSelf dataSource:weakSelf tintColor:MainThemeColor];
        }
    } otherCase:nil failure:nil];
}

// 提交意见
- (void)postFeedBackRequset {
    NSString *url = [MainURL stringByAppendingPathComponent:@"feedback/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    params[@"sys_fd_type_id"] = self.feedbackType.sys_fd_type_id;
    params[@"sys_fd_content"] = self.text;
    params[@"mobile"] = self.mobile;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"留言成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } otherCase:nil failure:nil];
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (indexPath.section == 0) {
        ServiceLeaveMsgTypeCell *cell = [ServiceLeaveMsgTypeCell cellFromXibWithTableView:tableView];
        cell.typeText = (self.quesetionType) ? self.quesetionType : @"请选择您要反馈的意见类型";
        cell.didTap = ^{
            [weakSelf getFeedBackTypeData];
        };
        return cell;
    } else if (indexPath.section == 1) {
        ItemTextFiledCell *cell = [ItemTextFiledCell cellFromXibWithTableView:tableView];
        cell.cellHeight = 50;
        cell.textLeftSpace = 10;
        cell.title = @"手机号";
        cell.placeholderText = @"请输入您的手机号";
        cell.keyboardType = UIKeyboardTypeNumberPad;
        cell.textMaxLenght = 11;
        cell.exceedMsg = @"手机号不超过11位";
        cell.textDidChange = ^(NSString *text) {
            weakSelf.mobile = text;
        };
        return cell;
    } else {
        ServiceLeaveMsgTextViewCell *cell = [ServiceLeaveMsgTextViewCell cellFromXibWithTableView:tableView];
        cell.placeholder = @"请输入您要反馈的意见...";
        cell.didInput = ^(NSString *text) {
            weakSelf.text = text;
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 2) ? SpaceHeight : NoneSpace;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - CustomDatePicker 数据源和代理
- (NSInteger)pickerView:(UIPickerView *)pickerView firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex numberOfRowsInPicker:(NSInteger)component {
    return self.feedbackTypes.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * cellTitle = [[UILabel alloc] init];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.font = TextSystemFont(20);
    cellTitle.textAlignment = NSTextAlignmentCenter;
    ProfileFeedbackType *feedbackType = self.feedbackTypes[row];
    cellTitle.text = feedbackType.sys_fd_type_title;
    return cellTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row {
    self.feedbackType = self.feedbackTypes[row];
    self.quesetionType = self.feedbackType.sys_fd_type_title;
    [self.tableView reloadData];
    [self.pickerView dismisView];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForPicker:(NSInteger)component {
    return Height44;
}

@end
