
//
//  HomeMuseumOrderHeaderCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderHeaderCell.h"
#import "Home.h"
#import "HomeShopBaseOrderPurchaseNoticeView.h"

@interface HomeShopBaseOrderHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIView *countTextFiledBgView;
@property (weak, nonatomic) IBOutlet UIView *segmentingLineView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) HomeShopBaseOrderPurchaseNoticeView *purchaseNoticeView;
@property (nonatomic, strong) SPAlertController *alertController;
@end

@implementation HomeShopBaseOrderHeaderCell

- (HomeShopBaseOrderPurchaseNoticeView *)purchaseNoticeView
{
    if (_purchaseNoticeView == nil)
    {
        _purchaseNoticeView = [HomeShopBaseOrderPurchaseNoticeView viewFromXib];
//        _purchaseNoticeView.content = self.ticket.ticket_intro_content;
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:self.ticket.ticket_buy_intro,self.ticket.ticket_refund_intro,self.ticket.ticket_use_intro, nil];
        _purchaseNoticeView.content = arr;
        WeakSelf(weakSelf)
        _purchaseNoticeView.dismiss = ^{
            [weakSelf.alertController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _purchaseNoticeView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.count = 1;
    self.countTextField.text = @(self.count).description;
    self.minusBtn.isIgnore = self.plusBtn.isIgnore = YES;
    self.minusBtn.enabled = NO;

    self.countTextFiledBgView.layer.borderWidth = 0.5;
    self.countTextFiledBgView.layer.borderColor = SetupColor(224, 157, 91).CGColor;
    self.minusBtn.titleLabel.font = self.plusBtn.titleLabel.font = IconFont(20);
    self.minusBtn.adjustsImageWhenHighlighted = self.plusBtn.adjustsImageWhenHighlighted = NO;
    [self.minusBtn setTitle:MinusIconUnicode forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
    [self.plusBtn setTitle:PlusIconUnicode forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
    [self.countTextField addTarget:self action:@selector(countTextField:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setTicket:(HomeTicket *)ticket {
    _ticket = ticket;
    self.count = ticket.totalCount;
    self.titleTextLabel.text = ticket.ticket_name;
//    self.count = (ticket.ticket_num) ? ticket.ticket_num : 1;
    self.countTextField.text = @(self.count).description;
    self.dateLabel.text = ticket.ticket_deadline_text;
    self.ticket.need_pay = self.countTextField.text.integerValue * self.ticket.ticket_sale_price.floatValue;
//    self.ticket.totalCount = self.count;
    
    NSInteger minCount = (ticket.ticket_num) ? ticket.ticket_num : 1;
    self.minusBtn.enabled = !(ticket.ticket_num == minCount);
    if (self.ticket.ticket_store_isopen == 1 && self.ticket.ticket_remain_num) {
        NSInteger maxCount = self.ticket.ticket_remain_num;
        self.plusBtn.enabled = !(ticket.ticket_num == maxCount);
    }
}

- (void)setIsShowSegmentingLine:(BOOL)isShowSegmentingLine {
    _isShowSegmentingLine = isShowSegmentingLine;
    self.segmentingLineView.backgroundColor = (isShowSegmentingLine) ? SetupColor(227, 227, 227) : [UIColor clearColor];
}

- (IBAction)minusBtnTap:(UIButton *)button {
    self.count--;
    NSInteger minCount = (self.ticket.ticket_num) ? self.ticket.ticket_num : 1;
    if (self.count <= minCount) {
        self.count = minCount;
        button.enabled = NO;
    } 
    if (button.isEnabled) [LaiMethod animationWithView:self.countTextField];
    self.countTextField.text = @(self.count).description;
    [self updateData];
    self.plusBtn.enabled = YES;
}

- (IBAction)plusBtnTap:(UIButton *)button {
    self.count++;
    if (self.ticket.ticket_store_isopen == 1) {
        if (self.count >= self.ticket.ticket_remain_num) {
            self.count = self.ticket.ticket_remain_num;
            button.enabled = NO;
        }
    }
    if (button.isEnabled) [LaiMethod animationWithView:self.countTextField];
    self.countTextField.text = @(self.count).description;
    [self updateData];
    self.minusBtn.enabled = YES;
}

- (void)countTextField:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) return;
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.ticket.ticket_num) {
            if (textField.text.integerValue < weakSelf.ticket.ticket_num) {
                textField.text = @(weakSelf.ticket.ticket_num).description;
                [SVProgressHUD showError:[NSString stringWithFormat:@"至少%zd张起售", weakSelf.ticket.ticket_num]];
            }
        }
        if (weakSelf.ticket.ticket_store_isopen == 1) {
            if (textField.text.integerValue > weakSelf.ticket.ticket_remain_num) {
                textField.text = @(weakSelf.ticket.ticket_remain_num).description;
                [SVProgressHUD showError:[NSString stringWithFormat:@"最多出售%zd张", weakSelf.ticket.ticket_remain_num]];
            }
        }
        [self updateData];
    });
}

- (IBAction)purchaseNoticeBtnTap:(UIButton *)sender {
    WeakSelf(weakSelf)
    [LaiMethod alertSPAlerCustomSheetCustomView:self.purchaseNoticeView handler:^(SPAlertController *alertController) {
        weakSelf.alertController = alertController;
    }];
}

- (void)updateData {
    self.ticket.need_pay = self.countTextField.text.integerValue * self.ticket.ticket_sale_price.doubleValue;
    self.ticket.totalCount = self.count;
    if (self.countDidChanged) self.countDidChanged();
}

@end
