
//
//  TravelsSendTravelsVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsSendTravelsVC.h"
#import "TravelsSendTravelsTitleLabelCell.h"
#import "Travels.h"
#import "TravelsSendTravelsConentCell.h"
#import "TravelsSendTravelsConentVC.h"
#import "TravelsSendTravelsTextContentCell.h"

@interface TravelsSendTravelsVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *stadiums;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, strong) NSArray *selectedTags;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *photoUrls;
@property (nonatomic, copy) NSString *contentStr;
@end

@implementation TravelsSendTravelsVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTableView];
    [self setupBottomView];
    [self getTravelsLabelData];
    [self addNotification];
}

- (void)setupValue {
    self.title = @"发布";
    self.contentStr = nil;
    [SaveTool removeObjectForKey:@"travelsContentStr"];
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
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

- (void)setupBottomView {
    NormalBottomView *bottomView = [NormalBottomView viewFromXib];
    bottomView.title = @"确认发布";
    self.tableView.tableFooterView = bottomView;
    WeakSelf(weakSelf)
    bottomView.didTap = ^{
        [weakSelf.view endEditing:YES];
        weakSelf.contentStr = [SaveTool objectForKey:@"travelsContentStr"];
        if (!weakSelf.titleText || [weakSelf.titleText isEqualToString:@""]) {
            [SVProgressHUD showError:@"请填写标题"];
        } else if (weakSelf.selectedTags.count ==0) {
            [SVProgressHUD showError:@"请至少选择一个标签"];
        }
        else if (weakSelf.photos == 0) {
            [SVProgressHUD showError:@"请上传封面"];
        }
        else if (!weakSelf.contentStr || [weakSelf.contentStr isEqualToString:@""]) {
            [SVProgressHUD showError:@"请编辑内容"];
        } else {
            [weakSelf uploadImage];
        }
    };
}

#pragma mark - 接口
// 获取标签数据
- (void)getTravelsLabelData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"notes/stadium"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        weakSelf.stadiums = [TravelStadium mj_objectArrayWithKeyValuesArray:json[Data][@"list"]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } otherCase:nil failure:^(NSError *error) {
    
    }];
}

// 上传图片
- (void)uploadImage {
    NSString *url = [MainURL stringByAppendingPathComponent:@"main/imageUpload"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    NSMutableArray *formDataArray = [NSMutableArray array];
    for (int i = 0 ; i < self.photos.count; i++) {
        FormData *formData = [FormData setData:UIImageJPEGRepresentation(self.photos[i], 0.6) name:[NSString stringWithFormat:@"%d", i] mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"image%zd.jpg", i]];
        [formDataArray addObject:formData];
    }
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params progress:nil formDataArray:formDataArray success:^(id json) {
        weakSelf.photoUrls = json[Data];
        [weakSelf postTravelsRequest];
    } otherCase:nil failure:^(NSError *error) {
    }];
}

// 提交数据
- (void)postTravelsRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"notes/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = [SaveTool objectForKey:Token];
    params[@"image"] = self.photoUrls.firstObject;
    params[@"title"] = self.titleText;
    params[@"content"] = self.contentStr;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    NSString *paramsName = nil;
    for (int i = 0; i < self.selectedTags.count; i++) {
        paramsName = [NSString stringWithFormat:@"stadium_basic_id[%zd]", i];
        params[paramsName] = self.selectedTags[i];
    }
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"上传成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TravelsSendNotification" object:nil];
        });
    } otherCase:nil failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (indexPath.row == 0) {
        TravelsSendTravelsTitleLabelCell *cell = [TravelsSendTravelsTitleLabelCell cellFromXibWithTableView:tableView];
        cell.stadiums = self.stadiums;
        cell.inputTitle = ^(NSString *title) {
            weakSelf.titleText = title;
        };
        cell.selectedTag = ^(NSArray *tagId) {
            weakSelf.selectedTags = tagId;
        };
        return cell;
    } else if (indexPath.row == 1) {
        ItemAddPhotoCell *cell = [ItemAddPhotoCell cellFromXibWithTableView:tableView];
        cell.titleColor = SetupColor(170, 170, 170);
        cell.title = @"上传封面";
        cell.addImage = SetImage(@"添加");
        cell.photoCount = 1;
        cell.selectedPhoto = ^(NSArray<UIImage *> *photos) {
            weakSelf.photos = photos;
        };
        return cell;
    } else {
        TravelsSendTravelsTextContentCell *cell = [TravelsSendTravelsTextContentCell cellFromXibWithTableView:tableView];
        NSString *content = [SaveTool objectForKey:@"travelsContentStr"];
        cell.info = (content.length >= 1) ? @"修改" : @"添加";
        cell.didTap = ^{
            [weakSelf.view endEditing:YES];
            [SVProgressHUD showMessage:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 0.25) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LaiMethod runtimePushVcName:@"TravelsSendTravelsConentVC" dic:nil nav:weakSelf.navigationController];
            });
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - navItemAction
- (void)cancel {
    [self.view endEditing:YES];
    WeakSelf(weakSelf)
    [LaiMethod alertControllerWithTitle:nil message:@"是否退出当前编辑?" defaultActionTitle:@"退出" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - addNotification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadInfoData) name:@"TravelsReturnValueNotification" object:nil];
}

- (void)reloadInfoData {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
