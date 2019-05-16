
//
//  HomeShoppingCarCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShoppingCarTicketCell.h"
#import "Home.h"

@interface HomeShoppingCarTicketCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIView *countTextFiledBgView;
@property (nonatomic, assign) NSInteger count;
@end

@implementation HomeShoppingCarTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.selectedBtn.titleLabel.font = IconFont(22);
    self.selectedBtn.isIgnore = YES;
    [self.selectedBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.selectedBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
    
    self.count = 1;
    self.countTextField.text = @(self.count).description;
    self.minusBtn.isIgnore = self.plusBtn.isIgnore = YES;
    self.minusBtn.enabled = NO;
    self.countTextFiledBgView.layer.borderWidth = 0.5;
    self.countTextFiledBgView.layer.borderColor = SetupColor(224, 157, 91).CGColor;
    self.minusBtn.titleLabel.font = self.plusBtn.titleLabel.font = IconFont(15);
    self.minusBtn.adjustsImageWhenHighlighted = self.plusBtn.adjustsImageWhenHighlighted = NO;
    [self.minusBtn setTitle:MinusIconUnicode forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
    [self.plusBtn setTitle:PlusIconUnicode forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
    [self.countTextField addTarget:self action:@selector(countTextField:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setIsSelectedStatus:(BOOL)isSelectedStatus {
    _isSelectedStatus = isSelectedStatus;
    self.selectedBtn.selected = isSelectedStatus;
}

- (void)setTicket:(HomeShoppingCarTicket *)ticket {
    _ticket = ticket;
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(SmallImage(ticket.ticket_image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    NSString *siteName = (ticket.site_name && ticket.site_name.length>0) ? [NSString stringWithFormat:@"(%@)",ticket.site_name] : @"";
    self.titleTextLabel.text = [NSString stringWithFormat:@"%@%@",ticket.ticket_name,siteName];
    NSString *date = [NSString dateStr:ticket.ticket_check_stime formatter:@"yyyy-MM-dd HH:mm:ss" formatWithOtherFormatter:@"yyyy-MM-dd"];
    self.dateLabel.text = [NSString stringWithFormat:@"使用日期:￥%@",date];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",ticket.ticket_sale_price];
    self.count = ticket.ticket_lock_num;
    self.countTextField.text = @(self.count).description;
    self.minusBtn.enabled = (self.count > 1);
    self.ticket.totalPrice = self.count * self.ticket.ticket_sale_price.floatValue;
    self.ticket.totalCount = self.count;
    
    NSInteger minCount = (self.ticket.ticket_num) ? self.ticket.ticket_num : 1;
    self.minusBtn.enabled = !(self.ticket.ticket_lock_num == minCount);
//    if (self.ticket.ticket_store_isopen == 1 && self.ticket.ticket_store_num) {
//        NSInteger maxCount = self.ticket.ticket_store_num;
//        self.plusBtn.enabled = !(self.ticket.nums == maxCount);
//    }
}

- (IBAction)selectedBtn:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.isSelected) {
//        [LaiMethod animationWithView:button];
        self.ticket.totalPrice = self.count * self.ticket.ticket_sale_price.floatValue;
        self.ticket.totalCount = self.count;
    }
    if (self.changeStatus) self.changeStatus(self.indexPath, button.isSelected);
}

- (IBAction)minusBtnTap:(UIButton *)button {
    self.count--;
    NSInteger minCount = (self.ticket.ticket_num) ? self.ticket.ticket_num : 1;
    if (self.count <= minCount) {
        self.count = minCount;
        button.enabled = NO;
    }
    [self minusRequest:self.ticket];
//    [LaiMethod animationWithView:self.countTextField];
    
}

//数量-1
-(void)minusRequest:(HomeShoppingCarTicket *)ticket {
    NSString *url = [MainURL stringByAppendingPathComponent:@"cart/delete"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"biz_cart_id"] = ticket.biz_cart_id;
    params[@"delete_num"] = @"1";
    params[@"biz_ticket_id"] = ticket.biz_ticket_id;
    params[@"token"] = [SaveTool objectForKey:Token];
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];

    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        self.countTextField.text = @(self.count).description;
        self.plusBtn.enabled = YES;
        [self updateDataAndStatus];
    } otherCase:nil failure:^(NSError *error) {
    }];
}

- (IBAction)plusBtnTap:(UIButton *)button {
    self.count++;
    if (self.ticket.ticket_store_isopen == 1) {
        if (self.count >= self.ticket.ticket_remain_num) {
            self.count = self.ticket.ticket_remain_num;
            button.enabled = NO;
        }
    }
    [self postAddShoppingCarRequeset:self.ticket];
//    [LaiMethod animationWithView:self.countTextField];
}

//数量+1
- (void)postAddShoppingCarRequeset:(HomeShoppingCarTicket *)ticket {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"biz_ticket_id"] = ticket.biz_ticket_id;
    dic[@"ticket_lock_num"] = @"1";
    if(ticket.end_date && ticket.start_date){
        dic[@"start_date"] = ticket.end_date;
        dic[@"end_date"] = ticket.start_date;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithObject:dic];
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *url = [MainURL stringByAppendingPathComponent:@"cart/add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ticket_list"] = json;
    params[@"token"] = [SaveTool objectForKey:Token];
    params[@"sign"] = [LaiMethod getSign];
    params[@"nonce_str"] = [NSString stringWithFormat:@"%d", rand()];
    
    [HttpTool postWithURL:url params:params isHiddeHUD:YES success:^(id json) {
        self.countTextField.text = @(self.count).description;
        self.minusBtn.enabled = YES;
        [self updateDataAndStatus];
    } otherCase:nil failure:^(NSError *error){
    }];
}

- (void)countTextField:(UITextField *)textField {
    self.plusBtn.enabled = self.minusBtn.enabled = YES;
    
    if (textField.text.integerValue == 0 || [textField.text isEqualToString:@""]) {
        [SVProgressHUD showError:@"数量不能为空或者为0"];
        textField.text = @"1";
        self.plusBtn.enabled = NO;
    }

    self.count = textField.text.integerValue;
    
    if (self.ticket.ticket_store_isopen == 1) {
        self.plusBtn.enabled = (self.count <= self.ticket.ticket_remain_num);
        if (self.count >= self.ticket.ticket_remain_num) {
            if (self.count > self.ticket.ticket_remain_num) [SVProgressHUD showError:@"超过库存量"];
            self.count = self.ticket.ticket_remain_num;
            textField.text = @(self.count).description;
            self.plusBtn.enabled = NO;
        }
    }
    
    NSInteger minCount = (self.ticket.ticket_num) ? self.ticket.ticket_num : 1;
    if (self.count < minCount) {
        self.count = self.ticket.ticket_num;
        textField.text = @(self.count).description;
        [SVProgressHUD showError:@"不能小于最低起售"];
        self.minusBtn.enabled = NO;
    }
    [self updateDataAndStatus];
}

- (void)updateDataAndStatus {
    self.ticket.totalPrice = self.count * self.ticket.ticket_sale_price.floatValue;
    self.ticket.totalCount = self.count;
    if (self.changeStatus) self.changeStatus(self.indexPath, YES);
    if (self.selectedBtn.selected == NO) self.selectedBtn.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
    return YES;
}

@end
