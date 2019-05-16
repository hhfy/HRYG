
//
//  TravelsSendMomentVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsSendMomentVC.h"
#import "TravelsSendMomentContentCell.h"
#import "TravelsSendMomentTitleCell.h"

@interface TravelsSendMomentVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray *photoUrls;
@end

@implementation TravelsSendMomentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTableView];
}

- (void)setupValue {
    self.title = @"发布";
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(commit) title:@"提交" nomalColor:MainThemeColor hightLightColor:SetupColor(180, 180, 180) titleFont:TextSystemFont(15) top:0 left:0 bottom:0 right:0];
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
// 发布动态
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
        [weakSelf postTravelsMomentRequest];
    } otherCase:nil failure:^(NSError *error) {
    }];
}

- (void)postTravelsMomentRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"tweet/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"text"] = self.text;
    
    NSString *paramsName = nil;
    for (int i = 0; i < self.photoUrls.count; i++) {
        paramsName = [NSString stringWithFormat:@"images[%zd]", i];
        params[paramsName] = self.photoUrls[i];
    }
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"发布成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DynamicSendNotification" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } otherCase:nil failure:nil];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (indexPath.row == 0) {
        TravelsSendMomentContentCell *cell = [TravelsSendMomentContentCell cellFromXibWithTableView:tableView];
        cell.inputText = ^(NSString *text) {
            weakSelf.text = text;
            [weakSelf judgeEditCondition];
        };
        return cell;
    } else {
        ItemAddPhotoCell *cell = [ItemAddPhotoCell cellFromXibWithTableView:tableView];
        cell.titleColor = SetupColor(170, 170, 170);
        cell.title = @"上传图片";
        cell.addImage = SetImage(@"添加");
        cell.photoCount = 9;
        cell.selectedPhoto = ^(NSArray<UIImage *> *photos) {
            weakSelf.photos = photos;
            [weakSelf judgeEditCondition];
        };
        cell.needReload = ^{
            [tableView beginUpdates];
            [tableView endUpdates];
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

#pragma mark - 判断编辑文本条件
- (void)judgeEditCondition {
    if (self.text.length > 0 && self.photos > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - navItemAction
- (void)commit {
    [self.view endEditing:YES];
    [self uploadImage];
}

- (void)cancel {
    [self.view endEditing:YES];
    WeakSelf(weakSelf)
    [LaiMethod alertControllerWithTitle:nil message:@"是否退出当前编辑?" defaultActionTitle:@"退出" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
@end
