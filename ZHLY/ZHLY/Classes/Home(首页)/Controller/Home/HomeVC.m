//
//  HomeVC.m
//  ZHLY
//
//  Created by LTWL on 2017/12/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeVC.h"
#import "HomeHeaderView.h"
#import "HomeItemCell.h"
#import "Home.h"
#import "HomeNoticeView.h"
#import "HomeHotSpotCell.h"
#import "HomeFlowViewCell.h"
#import "MyImageViewer.h"

@interface HomeVC () <UITableViewDelegate, UITableViewDataSource,HomeNoticeViewDelegate,UITextFieldDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITextField *searchTextField;
@property (nonatomic, strong) HomeHomeModel *homeModel;
@property (nonatomic, strong) HomeHeaderView *header;
@property (nonatomic, strong) HomeNoticeView *noticeView;
//
@property (nonatomic, strong) NSArray *showImgArr;
@property (strong, nonatomic) UIView *blankview ;
@end

@implementation HomeVC

- (UIImage *)shadowImage {
    if (_shadowImage == nil) {
        _shadowImage = [UINavigationController new].navigationBar.shadowImage;
    }
    return _shadowImage;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.noticeView shutDownTimer];
    [self.navigationController.navigationBar setBackgroundImage:(iPhoneX) ? SetImage(@"navigationbarBackgroundWhite_X") : SetImage(@"navigationbarBackgroundWhite") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:self.shadowImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNav];
    if(self.isPush){
        [self getRequest];
    }
    if(self.homeModel && self.homeModel.notify.count>0){
        self.noticeView.texts = self.homeModel.notify;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupHeaderView];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 20;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, NavHeight, 0);
    tableView.placeholderText = @"暂无数据";
    tableView.placeholderImage = SetImage(@"暂无商品");
    [self.view addSubview:tableView];
    _tableView = tableView;
    WeakSelf(weakSelf)
    [LaiMethod setupElasticPullRefreshWithTableView:tableView loadingViewCircleColor:MainThemeColor ElasticPullFillColor:[UIColor whiteColor] actionHandler:^{
        [self getRequest];
        [weakSelf.tableView stopLoading];
    }];
}

- (void)setupHeaderView {
    HomeHeaderView *header = [HomeHeaderView viewFromXib];
    self.tableView.tableHeaderView = header;
    _header = header;
}

- (void)setupNav {
//    self.navigationItem.title = nil;
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftAction) title:ScanIconUnicode nomalColor:SetupColor(89, 93, 116) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(25) top:0 left:0 bottom:0 right:0];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightAction) title:ShoppingCarIconUnicode nomalColor:SetupColor(89, 93, 116) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(25) top:0 left:0 bottom:0 right:0];
//
//    UITextField *searchTextField = [[UITextField alloc] init];
//    searchTextField.width = self.view.width - 120;
//    searchTextField.height = 30;
//    searchTextField.font = TextSystemFont(13);
//    searchTextField.backgroundColor = [UIColor clearColor];
//    searchTextField.placeholder = @"马术表演";
//    [searchTextField setValue:SetupColor(89, 93, 116) forKeyPath:@"_placeholderLabel.textColor"];
//    searchTextField.layer.cornerRadius = searchTextField.height * 0.35;
//    searchTextField.clipsToBounds = YES;
//    searchTextField.delegate = self;
//    UIButton *btn = [[UIButton alloc]initWithFrame:searchTextField.frame];
//    [btn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchDown];
//
//    //设置半透明效果
//    UIView *backView = [[UIView alloc]initWithFrame:searchTextField.frame];
//    backView.backgroundColor = [SetupColor(240, 240, 240)colorWithAlphaComponent:0.8];
//    backView.layer.masksToBounds = YES;
//    backView.layer.cornerRadius = 5;
//    self.navigationItem.titleView = backView;
//
//    UILabel *searchIconLabel = [[UILabel alloc] init];
//    searchIconLabel.textColor = SetupColor(89, 93, 116);
//    searchIconLabel.height = searchTextField.height;
//    searchIconLabel.width = searchIconLabel.height;
//    searchIconLabel.x = 15;
//    searchIconLabel.font = IconFont(15);
//    searchIconLabel.textAlignment = NSTextAlignmentCenter;
//    searchIconLabel.text = SearchIconUnicode;
//    searchTextField.leftView = searchIconLabel;
//    searchTextField.leftViewMode = UITextFieldViewModeAlways;
////    self.navigationItem.titleView = searchTextField;
//    [backView addSubview:searchTextField];
//    _searchTextField = searchTextField;
//    [backView addSubview:btn];
    
    self.navigationItem.title = nil;
    if (_blankview == nil) {
        CGFloat topY = iPhoneX ? -44 : -20;
        _blankview = [[UIView alloc] initWithFrame:CGRectMake(0, topY, MainScreenSize.width, NavHFit)];
        //        _blankview.backgroundColor = [UIColor whiteColor];
    }
    self.navigationItem.titleView = self.blankview;
    if (self.blankview.subviews.count==0) {
        UIView *searchblankView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, MainScreenSize.width-45, 30)];
        searchblankView.backgroundColor = [UIColor lightGrayColor];
        searchblankView.layer.cornerRadius = 4.0;
        [self.blankview addSubview:searchblankView];
        
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 14, 14)];
        [imgview setImage:[UIImage imageNamed:@"homepageV4search_icon"]];
        [searchblankView addSubview:imgview];
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 0xf2f2f2-60, 14)];
        textlabel.text = @"搜索文献、药品、题库及其他";
        textlabel.textColor = [UIColor grayColor];
        textlabel.font = [UIFont systemFontOfSize:12];
        [searchblankView addSubview:textlabel];
        UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterSearchVC:)];
        [self.blankview addGestureRecognizer:searchTap];
        
        //        UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        takePhotoBtn.frame = CGRectMake(WIDTH-50, 20, 50, 40);
        //        [takePhotoBtn setImage:[UIImage imageNamed:@"searchhomephoto_icon"] forState:0];
        //        [takePhotoBtn addTarget:self action:@selector(enterQuickCaseVC) forControlEvents:UIControlEventTouchUpInside];
        //        [self.blankview addSubview:takePhotoBtn];
    }
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.view.y = -(NavHFit);
}

- (void)enterSearchVC:(UITapGestureRecognizer *)tap {
}
- (void)leftAction {

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}
-(void)searchAction {
    [LaiMethod runtimePushVcName:@"HomeSearchVC" dic:nil nav:CurrentViewController.navigationController];
}

- (void)rightAction {
    [LaiMethod runtimePushVcName:@"HomeShoppingCarVC" dic:nil nav:CurrentViewController.navigationController];
}

#pragma mark - tableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.homeModel){
        NSInteger count=0;
        if (self.homeModel.ad2 && self.homeModel.ad2.count>0) {
            count++;
        }
        if(self.homeModel.scene && self.homeModel.scene.count>0){
            count++;
        }
        return count+1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        HomeItemCell *cell = [HomeItemCell cellFromXibWithTableView:tableView];
        if(self.homeModel){
            cell.homeModel = self.homeModel;
        }
        return cell;
    }
    else if(indexPath.section == 1) {
        HomeHotSpotCell *cell = [HomeHotSpotCell cellFromXibWithTableView:tableView];
        cell.ad2 = self.homeModel.ad2;
        return cell;
    }
    else {
        HomeFlowViewCell *cell = [HomeFlowViewCell cellFromXibWithTableView:tableView];
        if(self.homeModel){
            cell.sceneArr = self.homeModel.scene;
            cell.imgTapBack = ^(NSArray *imgArr) {
               self.showImgArr = [NSArray arrayWithArray:imgArr];
                //博物馆全屏大图展示
                MyImageViewer *view = [[MyImageViewer alloc] init];
                [view showImagesWithImageURLs:self.showImgArr atIndex:0];
            };
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SpaceHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 50 : 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 0){
        if(!self.noticeView){
            self.noticeView = [HomeNoticeView headerFooterViewFromXibWithTableView:tableView];
            self.noticeView.delegate = self;
        }
        if(self.homeModel && self.homeModel.notify.count>0){
            self.noticeView.texts = self.homeModel.notify;
        }
        return self.homeModel ? self.noticeView : nil;
    }
    return nil;
}

#pragma mark - HomeNoticeViewDelegate
- (void)homeNoticeView:(HomeNoticeView *)homeNoticeView didClickWithId:(NSString *)Id {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"apiUrl"] = [MainURL stringByAppendingPathComponent:@"notify/detail"];
    params[@"Id"] = Id;
    params[@"titleText"] = @"公告详情";
    params[@"IdKey"] = @"app_notify_id";
    [LaiMethod runtimePushVcName:@"HomeDetialWebVC" dic:params nav:CurrentViewController.navigationController];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextField resignFirstResponder];
    if (scrollView.contentOffset.y < 0) {
        [UIView animateWithDuration:KeyboradDuration animations:^{
            self.navigationController.navigationBar.alpha = 0.f;
        }];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:KeyboradDuration animations:^{
                self.navigationController.navigationBar.alpha = 1;
            }];
        });
    }
    
    CGFloat alpha = scrollView.contentOffset.y / (200);
    if (alpha >= 1) {
        if (self.navigationController.navigationBar.shadowImage != self.shadowImage) {
            alpha = 1;
            self.navigationController.navigationBar.shadowImage = self.shadowImage;
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
        }
    } else {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        UIImage *image = [UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:((alpha <= 0.2) ? 0.2 : alpha)]];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

//MARK:获取首页数据
-(void)getRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"main/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = self.token;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:NO progress:nil success:^(id json) {
        weakSelf.homeModel = [HomeHomeModel mj_objectWithKeyValues:json[Data]];
        if(weakSelf.homeModel.ad1.count>0){
            self.header.ad1 = weakSelf.homeModel.ad1;
        }
        [weakSelf.tableView reloadData];
    } otherCase:nil failure:^(NSError *error) {
//        [weakSelf.tableView reloadData];
    }];
}

@end

@interface FlowTravelsAlbumPhotoView ()
@property (nonatomic, strong) UIActivityIndicatorView *loaddingView;
@end

@implementation FlowTravelsAlbumPhotoView

- (UIActivityIndicatorView *)loaddingView {
    if (_loaddingView == nil){
        _loaddingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_loaddingView setHidesWhenStopped:YES];
        [self addSubview:_loaddingView];
    }
    return _loaddingView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
    self.backgroundColor = SetupColor(236, 234, 230);
}

- (void)setPhoto:(NSString *)photo {
    _photo = [photo copy];
    WeakSelf(weakSelf)
    [self.loaddingView startAnimating];
    self.userInteractionEnabled = NO;
    [self sd_setImageWithURL:SetURL(SmallImage(photo)) placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.userInteractionEnabled = YES;
        [weakSelf.loaddingView stopAnimating];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.loaddingView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}


@end

