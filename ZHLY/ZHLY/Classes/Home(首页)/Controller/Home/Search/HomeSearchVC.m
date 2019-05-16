//
//  HomeSearchVC.m
//  ZHDJ
//
//  Created by Moussirou Serge Alain on 2018/3/12.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "HomeSearchVC.h"
#import "HomeSeasonTicketCell.h"
#import "TravelsTravelsCell.h"
#import "HomeShopBaseCell.h"
#import "Home.h"
#import "Travels.h"
#import "HomeSearchSectionHeaderView.h"

@interface HomeSearchVC ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITextField *searchTextField;
@property (nonatomic, strong) HomeSearchInfo *searchInfo;
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation HomeSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupNav {
    self.navigationItem.title = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightAction) title:@"搜索" nomalColor:SetupColor(167, 167, 167) hightLightColor:SetupColor(180, 180, 180) titleFont:TextSystemFont(16) top:0 left:0 bottom:0 right:0];
    
    UITextField *searchTextField = [[UITextField alloc] init];
    searchTextField.width = self.view.width - 120;
    searchTextField.height = 30;
    searchTextField.font = TextSystemFont(13);
    searchTextField.backgroundColor = [UIColor clearColor];
    searchTextField.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    searchTextField.placeholder = @"搜索门票、套票、游记等";
    [searchTextField setValue:SetupColor(189, 189, 189) forKeyPath:@"_placeholderLabel.textColor"];
    searchTextField.layer.cornerRadius = searchTextField.height * 0.35;
    searchTextField.clipsToBounds = YES;
    searchTextField.delegate = self;
    //设置半透明效果
    UIView *backView = [[UIView alloc]initWithFrame:searchTextField.frame];
    backView.backgroundColor = SetupColor(244, 244, 244);
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 15;
    self.navigationItem.titleView = backView;
    
    UILabel *searchIconLabel = [[UILabel alloc] init];
    searchIconLabel.textColor = SetupColor(89, 93, 116);
    searchIconLabel.height = searchTextField.height;
    searchIconLabel.width = searchIconLabel.height;
    searchIconLabel.x = 15;
    searchIconLabel.font = IconFont(15);
    searchIconLabel.textAlignment = NSTextAlignmentCenter;
    searchIconLabel.text = @"\U0000e662";
    searchTextField.leftView = searchIconLabel;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    //    self.navigationItem.titleView = searchTextField;
    [backView addSubview:searchTextField];
    _searchTextField = searchTextField;
    self.view.y = -(NavHFit);
}

-(void)rightAction {
    [self.searchTextField resignFirstResponder];
    [self getData];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.searchStr = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder];
    [self getData];
    return YES;
}
#pragma mark - 接口
- (void)getData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"search/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"search"] = self.searchStr;
    params[Channel_pot_id] = ChannelPotId;
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params isHiddeHUD:YES progress:nil success:^(id json) {
        weakSelf.searchInfo = [HomeSearchInfo mj_objectWithKeyValues:json[Data]];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } otherCase:^(NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-NavHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.estimatedRowHeight = 45.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, SpaceHeight, 0);
    [self.view addSubview:tableView];
    _tableView = tableView;
    _tableView.isHideNoDataView = YES;
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getData)];
}

#pragma mark - tableView数据源和代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.searchInfo ? 3 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.searchInfo.ticket.count;
    }
    else if(section == 1){
        return self.searchInfo.tickets.count;
    }
    return self.searchInfo.note.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeShopBaseCell *cell = [HomeShopBaseCell cellFromXibWithTableView:tableView];
        HomeTicket *ticket = self.searchInfo.ticket[indexPath.row];
        cell.ticket = ticket;
        return cell;
    }
    else if (indexPath.section == 1){
        HomeSeasonTicketCell *cell = [HomeSeasonTicketCell cellFromXibWithTableView:tableView];
        HomeMuseumSeasonTickets *seasonTicket = self.searchInfo.tickets[indexPath.row];
        cell.seasonTicket = seasonTicket;
        return cell;
    }
    else {
        TravelsTravelsCell *cell = [TravelsTravelsCell cellFromXibWithTableView:tableView];
        TravelNoteTip *noteTip = self.searchInfo.note[indexPath.row];
        cell.noteTip = noteTip;
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeSearchSectionHeaderView *header = [HomeSearchSectionHeaderView headerFooterViewFromXibWithTableView:tableView];
    if (section == 0) {
        header.title = @"普通票";
        return self.searchInfo.ticket.count>0 ? header : nil;
    }
    else if(section == 1){
        header.title = @"套票";
        return self.searchInfo.tickets.count>0 ? header : nil;
    }
    else {
       header.title = @"游记";
        return self.searchInfo.note.count>0 ? header : nil;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.searchInfo.ticket.count>0 ? 47 : NoneSpace;
    }
    else if (section == 1) {
       return self.searchInfo.tickets.count>0 ? 47 : NoneSpace;
    }
    else {
       return self.searchInfo.note.count>0 ? 47 : NoneSpace;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

@end
