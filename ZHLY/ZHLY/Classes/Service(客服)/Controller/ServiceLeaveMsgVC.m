//
//  ServiceLeaveMsgVC.m
//  ZHLY
//
//  Created by LTWL on 2017/11/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceLeaveMsgVC.h"
#import "ServiceLeaveMsgTypeCell.h"
#import "ServiceLeaveMsgTextViewCell.h"
#import "ServiceLeaveMsgFooterView.h"
#import "Service.h"

@interface ServiceLeaveMsgVC () <UITableViewDelegate, UITableViewDataSource, CustomDatePickerDelegate, CustomDatePickerDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) CustomDatePicker *pickerView;
@property (nonatomic, copy) NSString *quesetionType;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray *msgTypes;
@property (nonatomic, strong) ServiceLeaveMsgType *msgType;
@end

@implementation ServiceLeaveMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTableView];
    [self setupFooterView];
}

- (void)setupValue {
    self.title = @"留言咨询";
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(myLeaveMsg) title:@"我的留言" nomalColor:SetupColor(51, 51, 51) hightLightColor:SetupColor(180, 180, 180) titleFont:TextSystemFont(14) top:0 left:0 bottom:0 right:0];
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

- (void)setupFooterView {
    ServiceLeaveMsgFooterView *footerView = [ServiceLeaveMsgFooterView viewFromXib];
    footerView.info = @"如有问题，请咨询客服电话：";
    footerView.phoneNumber = @"0510-86930666";
    self.tableView.tableFooterView = footerView;
}

#pragma mark - 接口
// 获取留言类型数据
- (void)getLeaveMsgTypeData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"customer/type"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:NO progress:nil success:^(id json) {
        weakSelf.msgTypes = [ServiceLeaveMsgType mj_objectArrayWithKeyValuesArray:json[Data]];
        if (weakSelf.msgTypes.count == 0) {
            [SVProgressHUD showError:@"赞无留言类型"];
        } else {
            weakSelf.pickerView = [LaiMethod setupCustomPickerWithTitle:@"选择问题类型" delegate:weakSelf dataSource:weakSelf tintColor:MainThemeColor];
        }
    } otherCase:nil failure:nil];
}

// 提交留言
- (void)postLeaveMsgRequset {
    NSString *url = [MainURL stringByAppendingPathComponent:@"customer/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"type_id"] = self.msgType.customer_consult_type_id;
    params[@"content"] = self.text;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"留言成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf myLeaveMsg];
        });
    } otherCase:nil failure:nil];
}

#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (indexPath.section == 0) {
        ServiceLeaveMsgTypeCell *cell = [ServiceLeaveMsgTypeCell cellFromXibWithTableView:tableView];
        cell.typeText = (self.quesetionType) ? self.quesetionType : @"请选择您要咨询的问题类型";
        cell.didTap = ^{
            [weakSelf getLeaveMsgTypeData];
        };
        return cell;
    } else {
        ServiceLeaveMsgTextViewCell *cell = [ServiceLeaveMsgTextViewCell cellFromXibWithTableView:tableView];
        cell.didInput = ^(NSString *text) {
            weakSelf.text = text;
        };
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WeakSelf(weakSelf)
    NormalBottomView *commitView = [NormalBottomView viewFromXib];
    commitView.title = @"提交";
    commitView.didTap = ^{
        [weakSelf.view endEditing:YES];
        if (!weakSelf.text) {
            [SVProgressHUD showError:@"请输入您要咨询的内容"];
        } else if (!self.msgType) {
            [SVProgressHUD showError:@"请选择留言类型"];
        } else {
            [weakSelf postLeaveMsgRequset];
        }
    };
    return (section == 0) ? nil : commitView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 1) ? 60 : NoneSpace;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - CustomDatePicker 数据源和代理
- (NSInteger)pickerView:(UIPickerView *)pickerView firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex numberOfRowsInPicker:(NSInteger)component {
    return self.msgTypes.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * cellTitle = [[UILabel alloc] init];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.font = TextSystemFont(20);
    cellTitle.textAlignment = NSTextAlignmentCenter;
    ServiceLeaveMsgType *msgType = self.msgTypes[row];
    cellTitle.text = msgType.name;
    return cellTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row {
    self.msgType = self.msgTypes[row];
    self.quesetionType = self.msgType.name;
    [self.tableView reloadData];
    [self.pickerView dismisView];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForPicker:(NSInteger)component {
    return Height44;
}

#pragma mark - myLeaveMsg
- (void)myLeaveMsg {
    [LaiMethod runtimePushVcName:@"ServiceMyMsgVC" dic:nil nav:self.navigationController];
}

@end
