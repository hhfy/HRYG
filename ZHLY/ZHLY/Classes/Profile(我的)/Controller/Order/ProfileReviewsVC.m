//
//  ProfileReviewsVC.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/6.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileReviewsVC.h"
#import "Profile.h"
#import "ProfileOrderListCell.h"
#import "ProfileStartCell.h"
#import "TravelsSendMomentContentCell.h"
#import "ItemAddPhotoCell.h"

@interface ProfileReviewsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *scoreArr;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) NSMutableArray *textArr;
@property (nonatomic, strong) NSMutableArray *photoUrls;
@property (nonatomic, strong) ProfileReviews *reviews;

@end

@implementation ProfileReviewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单评价";
    _scoreArr = [NSMutableArray array];
    _imagesArr = [NSMutableArray array];
    _textArr = [NSMutableArray array];
    _photoUrls = [NSMutableArray array];
    for (int i=0; i<self.orderIndex.ticket_list.count; i++) {
        [_scoreArr addObject:@"5"];
        NSArray *noImg = [NSArray arrayWithObject:@""];
        [_imagesArr addObject:noImg];
        [_textArr addObject:@""];
        [_photoUrls addObject:@""];
    }
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - NavHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 30.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    [self setupBottomView];
}
- (void)setupBottomView {
    NormalBottomView *bottomView = [NormalBottomView viewFromXib];
    bottomView.title = @"确认提交";
    self.tableView.tableFooterView = bottomView;
    WeakSelf(weakSelf)
    bottomView.didTap = ^{
        [weakSelf.view endEditing:YES];
        for (int i=0; i<self.orderIndex.ticket_list.count; i++) {
            NSArray *array = self.imagesArr[i];
            if([weakSelf.scoreArr[i] isEqualToString:@"0"]){
                [SVProgressHUD showError:@"请给商品评分"];
                return ;
            }
            else if([weakSelf.textArr[i] isEqualToString:@""]){
                [SVProgressHUD showError:@"请输入评价内容"];
                return ;
            }
            else if([array[0] isEqual:@""]){
                [SVProgressHUD showError:@"请添加图片"];
                return ;
            }
        }
        [self uploadImage];
    };
}
#pragma mark - tableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderIndex.ticket_list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        ProfileOrderListCell *cell = [ProfileOrderListCell cellFromXibWithTableView:tableView];
        cell.ticket = self.orderIndex.ticket_list[indexPath.section];
        return cell;
    }
    else if (indexPath.row==1) {
        ProfileStartCell *cell = [ProfileStartCell cellFromXibWithTableView:tableView];
        cell.currentScore = self.scoreArr[indexPath.section];
        cell.starBlock = ^(CGFloat currentScore) {
            NSString *score = [NSString stringWithFormat:@"%.0f",currentScore];
            [self.scoreArr replaceObjectAtIndex:indexPath.section withObject:score];
        };
        return cell;
    }
    else if (indexPath.row==2) {
        TravelsSendMomentContentCell *cell = [TravelsSendMomentContentCell cellFromXibWithTableView:tableView];
        cell.content = self.textArr[indexPath.section];
        cell.inputText = ^(NSString *text) {
            [self.textArr replaceObjectAtIndex:indexPath.section withObject:text];
        };
        return cell;
    }
    else {
        ItemAddPhotoCell *cell = [ItemAddPhotoCell cellFromXibWithTableView:tableView];
        cell.titleColor = SetupColor(170, 170, 170);
        cell.title = @"上传图片";
        cell.addImage = SetImage(@"添加");
        cell.photoCount = 9;
        NSArray *array = self.imagesArr[indexPath.section];
        if (array.count>0 && ![array[0] isEqual:@""]) {
            cell.selectedPhotos = self.imagesArr[indexPath.section];
        }
        else {
            cell.selectedPhotos = [NSMutableArray array];
        }
        cell.selectedPhoto = ^(NSArray<UIImage *> *photos) {
             [self.imagesArr replaceObjectAtIndex:indexPath.section withObject:photos];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = NoneSpace;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    [_tableView reloadData];
}

- (void)uploadImage {
    NSString *url = [MainURL stringByAppendingPathComponent:@"main/imageUpload"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;;
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    NSMutableArray *formDataArray = [NSMutableArray array];
    int count = 0;
    for (NSInteger index = 0; index < self.orderIndex.ticket_list.count; index ++) {
        NSArray *arr = self.imagesArr[index];
        for (int i = 0 ; i < arr.count; i++) {
            FormData *formData = [FormData setData:UIImageJPEGRepresentation(arr[i], 0.6) name:[NSString stringWithFormat:@"%d", count] mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"image%zd.jpg", count]];
            [formDataArray addObject:formData];
            count ++;
        }
    }
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params progress:nil formDataArray:formDataArray success:^(id json) {
        int num = 0;
        for (NSInteger index = 0; index < self.orderIndex.ticket_list.count; index ++){
            NSArray *arr = self.imagesArr[index];
            NSArray *array = [json[Data] subarrayWithRange:NSMakeRange(num, arr.count)];
            num += arr.count;
            [weakSelf.photoUrls replaceObjectAtIndex:index withObject:array];
        }
        [weakSelf evaluateData];
    } otherCase:nil failure:^(NSError *error) {
    }];
}

- (void)evaluateData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"order/evaluate"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    params[@"biz_order_id"] = self.bizOrderId;
    for (int i=0; i<self.orderIndex.ticket_list.count; i++) {
        ProfileOrderTicketList *ticList = self.orderIndex.ticket_list[i];
        NSString *idKey = [NSString stringWithFormat:@"evaluate[%zd][supplier_ticket_id]",i];
        params[idKey] = ticList.supplier_ticket_id;
        NSString *scoreKey = [NSString stringWithFormat:@"evaluate[%zd][score]",i];
        params[scoreKey] = self.scoreArr[i];
        NSString *imagesKey = [NSString stringWithFormat:@"evaluate[%zd][evaluate_images]",i];
        params[imagesKey] = [NSString jsonStrFromatWithArray:self.photoUrls[i]];
        NSString *textKey = [NSString stringWithFormat:@"evaluate[%zd][evaluate_text]",i];
        params[textKey] = self.textArr[i];
    }
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params isHiddeHUD:NO success:^(id json) {
        [SVProgressHUD showSuccess:@"评论成功"];
        NSLog(@"评论成功");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } otherCase:^(NSInteger code) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}
@end
