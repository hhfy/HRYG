//
//  ProfileInfoVC.m
//  GXBG
//
//  Created by LTWL on 2017/11/20.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileInfoVC.h"
#import "LoginVC.h"
#import "Profile.h"
#import "HomePersonalCell.h"

@interface ProfileInfoVC () <UITableViewDataSource, UITableViewDelegate, CustomDatePickerDelegate, CustomDatePickerDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) CustomDatePicker *pickerView;
@property (nonatomic, strong) NSArray *sexs;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) ProfileInfo *profileInfo;
@property (nonatomic, copy) NSString *sex;
@end

@implementation ProfileInfoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self setupSaveView];
}

- (void)setupValue {
    self.title = @"个人资料";
    self.sexs = @[@"男", @"女"];
    self.profileInfo = [ProfileInfo mj_objectWithKeyValues:self.params];
    if (self.profileInfo) {
        WeakSelf(weakSelf)
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager loadImageWithURL:SetURL(self.profileInfo.member_profile_image) options:SDWebImageRetryFailed | SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image) weakSelf.photo = image;
        }];
        switch (self.profileInfo.member_sex) {
            case 0:
                self.sex = @"保密";
                break;
            case 1:
                self.sex = @"男";
                break;
            case 2:
                self.sex = @"女";
                break;
            default:
                break;
        }
    }
}

- (void)setupSaveView {
    NormalBottomView *saveView = [NormalBottomView viewFromXib];
    saveView.title = @"保存";
    [saveView addTarget:self action:@selector(saveAction)];
    self.tableView.tableFooterView = saveView;
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
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight + Height44 + SpaceHeight * 2, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
/// 上传图片
- (void)uploadImage {
    NSString *url = [MainURL stringByAppendingPathComponent:@"main/imageUpload"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    
    FormData *formData = [FormData setData:UIImageJPEGRepresentation(self.photo, 0.6) name:@"0" mimeType:@"image/jpg" fileName:@"image%01.jpg"];

    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params progress:nil formDataArray:@[formData] success:^(id json) {
        NSArray *images = json[Data];
        weakSelf.profileInfo.member_profile_image = images.firstObject;
        [weakSelf postProfileInfoRequest];
    } otherCase:nil failure:nil];
}

/// 提交修改信息
- (void)postProfileInfoRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"member/update"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"member_nickname"] = self.profileInfo.member_nickname;
    params[@"member_sex"] = ([self.sex isEqualToString:@"男"]) ? @1 : @2;
    params[@"member_birthday"] = ([self.profileInfo.member_birthday rangeOfString:@"-"].location == NSNotFound) ? [NSString stringFromTimestampFromat:self.profileInfo.member_birthday formatter:FmtYMD] : self.profileInfo.member_birthday;
    params[@"member_profile_image"] = self.profileInfo.member_profile_image;
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    HomePersonalCell *cell = [HomePersonalCell cellFromXibWithTableView:tableView];
    cell.cellHeight = 50;
    cell.textAlign = NSTextAlignmentRight;
    cell.lineLeftW = 15;
    switch (indexPath.row) {
        case 0:
        {
            ItemAvatarCell *cell = [ItemAvatarCell cellFromXibWithTableView:tableView];
            cell.title = @"头像";
            cell.lineLeftW = 15;
            cell.icon = self.profileInfo.member_profile_image;
            cell.didSelected = ^(UIImage *photoImage) {
                weakSelf.photo = photoImage;
            };
            return cell;
        }
            break;
        case 1:
        {
            cell.title = @"昵称";
            cell.placeholderText = @"请输入昵称";
            cell.text = self.profileInfo.member_nickname;
            cell.textDidChange = ^(NSString *text) {
                weakSelf.profileInfo.member_nickname = text;
            };
        }
            break;
        case 2:
        {
            ItemArrowCell *cell = [ItemArrowCell cellFromXibWithTableView:tableView];
            cell.title = @"性别";
            cell.text = (self.sex) ? self.sex : @"请选择性别";
            cell.textColor = (self.sex) ? SetupColor(51, 51, 51) : SetupColor(153, 153, 153);
            cell.cellHeight = 50;
            cell.textAlign = NSTextAlignmentRight;
            cell.lineLeftW = 15;
            return cell;
        }
            break;
        case 3:
            {
                ItemArrowCell *cell = [ItemArrowCell cellFromXibWithTableView:tableView];
                cell.title = @"生日";
                NSString *date = [NSString dateStr:self.profileInfo.member_birthday formatter:@"yyyy-MM-dd HH:mm:ss" formatWithOtherFormatter:@"yyyy-MM-dd"];
                cell.text = (self.profileInfo.member_birthday && ![self.profileInfo.member_birthday isEqualToString:@"0"]) ? date : @"请选择生日";
                cell.textColor = (self.profileInfo.member_birthday && ![self.profileInfo.member_birthday isEqualToString:@"0"]) ? SetupColor(51, 51, 51) : SetupColor(153, 153, 153);
                cell.cellHeight = 50;
                cell.textAlign = NSTextAlignmentRight;
                cell.lineLeftW = 15;
                return cell;
            }
            break;
        case 4:
        {
            ItemArrowCell *cell = [ItemArrowCell cellFromXibWithTableView:tableView];
            cell.title = @"密码";
            cell.text = @"修改密码";
            cell.textColor = SetupColor(153, 153, 153);
            cell.cellHeight = 50;
            cell.textAlign = NSTextAlignmentRight;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight * 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self.view endEditing:YES];
        self.pickerView = [LaiMethod setupCustomPickerWithTitle:@"选择性别" delegate:self dataSource:self tintColor:MainThemeColor];
    } else if (indexPath.row == 3) {
        [self.view endEditing:YES];
        WeakSelf(weakSelf)
        [LaiMethod setupKSDatePickerWithMinDate:nil maxDate:[NSDate localDate] dateMode:UIDatePickerModeDate headerColor:MainThemeColor result:^(NSDate *selected) {
            weakSelf.profileInfo.member_birthday = [NSString stringFormDateFromat:selected formatter:FmtYMD];
            [weakSelf.tableView reloadData];
        }];
    } else if (indexPath.row == 4) {
        [LaiMethod runtimePushVcName:@"ProfileInfoSetupPwdVC" dic:nil nav:self.navigationController];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - CustomDatePicker数据源和代理
- (NSInteger)pickerView:(UIPickerView *)pickerView  firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex numberOfRowsInPicker:(NSInteger)component {
    return self.sexs.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * cellTitle = [[UILabel alloc] init];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.font = TextSystemFont(20);
    cellTitle.textAlignment = NSTextAlignmentCenter;
    cellTitle.text = self.sexs[row];
    return cellTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row {
    self.sex = self.sexs[row];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.pickerView dismisView];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForPicker:(NSInteger)component {
    return Height44;
}

#pragma mark - SaveAction
- (void)saveAction {
    [self.view endEditing:YES];
    if (!self.photo) {
        [SVProgressHUD showError:@"请选择头像"];
    }
    else if (!self.profileInfo.member_nickname || [self.profileInfo.member_nickname isEqualToString:@""]) {
        [SVProgressHUD showError:@"请填写昵称"];
    } else if (!self.sex) {
        [SVProgressHUD showError:@"请选择性别"];
    } else if (!self.profileInfo.member_birthday) {
        [SVProgressHUD showError:@"请选择生日"];
    } else {
        WeakSelf(weakSelf)
        [LaiMethod alertSPAlerSheetControllerWithTitle:nil message:@"确定保存当前用户信息?" defaultActionTitles:nil destructiveTitle:@"确定" cancelTitle:@"取消" handler:^(NSInteger actionIndex) {
            [weakSelf uploadImage];
        }];
    }
}

@end
