//
//  HomeShopBaseEditTouristVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseEditTouristVC.h"
#import "Home.h"

@interface HomeShopBaseEditTouristVC () <UITableViewDataSource, UITableViewDelegate, CustomDatePickerDelegate, CustomDatePickerDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) CustomDatePicker *pickerView;
@property (nonatomic, strong) HomeMuseumUserVisitor *userVisitor;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) NSInteger isDefault;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *IDNO;
@property (nonatomic, copy) NSString *name;
@end

@implementation HomeShopBaseEditTouristVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTableView];
    Log(@"%@", self.userVisitor);
}

- (void)setupValue {
    self.userVisitor = [HomeMuseumUserVisitor mj_objectWithKeyValues:self.params];
    switch (self.operationType) {
        case OperationTypeAdd:
            self.title = @"添加游客";
            break;
        case OperationTypeEdit:
            self.title = @"编辑游客";
            self.name = self.userVisitor.visitor_name;
            self.IDNO = self.userVisitor.visitor_type_number;
            self.mobile = self.userVisitor.visitor_mobile;
            self.isDefault = self.userVisitor.is_default;
            break;
        default:
            break;
    }
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(done) title:@"完成" nomalColor:MainThemeColor hightLightColor:SetupColor(180, 180, 180) titleFont:TextSystemFont(15) top:0 left:0 bottom:0 right:0];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancel) title:@"取消" nomalColor:SetupColor(51, 51, 51) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(15) top:0 left:0 bottom:0 right:0];
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
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
// 提交添游客
- (void)postAddTouristRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"visitor/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"visitor_name"] = self.name;
    params[@"visitor_mobile"] = self.mobile;
    params[@"visitor_type_number"] = self.IDNO;
    params[@"visitor_type"] = @1;
    params[@"is_default"] = (self.isDefault) ? @(self.isDefault) : @2;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"添加成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NeedReloadDataNotification object:nil userInfo:params];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((JumpVcDuration * 1.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } otherCase:nil failure:^(NSError *error){
        
    }];
}

// 提交编辑游客
- (void)postEditTouristRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"visitor/update"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"visitor_name"] = self.name;
    params[@"visitor_mobile"] = self.mobile;
    params[@"visitor_type_number"] = self.IDNO;
    params[@"visitor_type"] = @1;
    params[@"is_default"] = (self.isDefault) ? @(self.isDefault) : @2;
    params[@"biz_visitor_id"] = self.userVisitor.biz_visitor_id;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"编辑成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NeedReloadDataNotification object:nil userInfo:params];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((JumpVcDuration * 1.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        });
    } otherCase:nil failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTextFiledCell *cell = [ItemTextFiledCell cellFromXibWithTableView:tableView];
    cell.cellHeight = 45;
    WeakSelf(weakSelf)
    switch (indexPath.row) {
        case 0:
        {
            cell.title = @"姓名";
            cell.placeholderText = @"请输入您的姓名";
            cell.text = self.name ? self.name : self.userVisitor.visitor_name;
            cell.keyboardType = UIKeyboardTypeDefault;
            cell.textDidChange = ^(NSString *text) {
                weakSelf.name = text;
            };
        }
            break;
        case 1:
        {
            ItemArrowCell *cell = [ItemArrowCell cellFromXibWithTableView:tableView];
            cell.cellHeight = 45;
            cell.title = @"证件类型";
            cell.text = @"身份证";
            cell.textColor = SetupColor(51, 51, 51);
            cell.didTap = ^{
                weakSelf.pickerView = [LaiMethod setupCustomPickerWithTitle:@"选择证件类型" delegate:weakSelf dataSource:weakSelf tintColor:MainThemeColor];
                [weakSelf.view endEditing:YES];
            };
            return cell;
        }
            break;
        case 2:
            {
                cell.title = @"证件号";
                cell.placeholderText = @"请输入您的证件号";
                cell.text = self.IDNO ? self.IDNO :self.userVisitor.visitor_type_number;
                cell.textMaxLenght = 18;
                cell.exceedMsg = @"身份证不超过18位";
                cell.keyboardType = UIKeyboardTypeDefault;
                cell.textDidChange = ^(NSString *text) {
                    weakSelf.IDNO = text;
                };
            }
            break;
        case 3:
            {
                cell.title = @"手机号";
                cell.placeholderText = @"请输入您的手机号";
                cell.text = self.mobile ? self.mobile :self.userVisitor.visitor_mobile;
                cell.textMaxLenght = 11;
                cell.exceedMsg = @"手机号不超过11位";
                cell.keyboardType = UIKeyboardTypeNumberPad;
                cell.textDidChange = ^(NSString *text) {
                    weakSelf.mobile = text;
                };
            }
            break;
        case 4:
        {
            ItemSelectBtnCell *cell = [ItemSelectBtnCell cellFromXibWithTableView:tableView];
            cell.selectedBtnMode = SelectedBtnModeSingle;
            cell.title = @"设为默认";
            cell.cellHeight = 45;
            cell.selectBtnIsSeleted = (self.userVisitor.is_default == 1) ? YES : NO;
            cell.didSelected = ^(NSInteger selectedIndex, BOOL isSelected) {
                weakSelf.isDefault = (isSelected) ? 1 : 2;
            };
            return cell;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - CustomDatePicker数据源和代理
- (NSInteger)pickerView:(UIPickerView *)pickerView  firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex numberOfRowsInPicker:(NSInteger)component {
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * cellTitle = [[UILabel alloc] init];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.font = TextSystemFont(20);
    cellTitle.textAlignment = NSTextAlignmentCenter;
    cellTitle.text = @"身份证";
    return cellTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row {
    [self.tableView reloadData];
    [self.pickerView dismisView];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForPicker:(NSInteger)component {
    return Height44;
}

#pragma mark - navItem点击
- (void)done {
    [self.view endEditing:YES];
    if (!self.name) {
        [SVProgressHUD showError:@"请输入姓名"];
    } else if (!self.IDNO) {
        [SVProgressHUD showError:@"请输入证件号"];
    } else if (![VerificationTool validateIdentityNumber:self.IDNO]) {
        [SVProgressHUD showError:@"请输入正确的证件号"];
    } else if (!self.mobile) {
        [SVProgressHUD showError:@"请输入手机号"];
    } else if (![VerificationTool validateTelNumber:self.mobile]) {
        [SVProgressHUD showError:@"请输入正确的手机号"];
    } else {
        WeakSelf(weakSelf)
        [LaiMethod alertControllerWithTitle:nil message:@"是否提交当前游客信息?" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
            switch (weakSelf.operationType) {
                case OperationTypeAdd:
                    [weakSelf postAddTouristRequest];
                    break;
                case OperationTypeEdit:
                    [weakSelf postEditTouristRequest];
                    break;
                default:
                    break;
            }
        }];
    }
}

- (void)cancel {
    [self.view endEditing:YES];
    WeakSelf(weakSelf)
    [LaiMethod alertControllerWithTitle:nil message:@"当前编辑内容尚未保存，确定退出?" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

@end
