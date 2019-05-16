//
//  HomeMuseumOrderSpecialTicketCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/7.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderSpecialTicketCell.h"
#import "Home.h"
#import "HomeShopBaseOrderPurchaseNoticeView.h"

@interface HomeShopBaseOrderSpecialTicketCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIView *countTextFiledBgView;
@property (nonatomic, assign) NSInteger count;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectCountViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minusBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plusBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldBgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countTextFieldH;
@property (nonatomic, strong) HomeShopBaseOrderPurchaseNoticeView *purchaseNoticeView;
@property (weak, nonatomic) IBOutlet UILabel *buyCountInfoLabel;
@end

@implementation HomeShopBaseOrderSpecialTicketCell

- (HomeShopBaseOrderPurchaseNoticeView *)purchaseNoticeView
{
    if (_purchaseNoticeView == nil)
    {
        _purchaseNoticeView = [HomeShopBaseOrderPurchaseNoticeView viewFromXib];
//        _purchaseNoticeView.content = self.ticket.ticket_intro_content;
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:self.ticket.ticket_buy_intro,self.ticket.ticket_refund_intro,self.ticket.ticket_use_intro, nil];
        _purchaseNoticeView.content = arr;
    }
    return _purchaseNoticeView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.selectCountViewH.constant = 0;
    self.minusBtnH.constant = self.plusBtnH.constant = self.textFieldBgH.constant = self.countTextFieldH.constant = 0;
    
    self.selectBtn.titleLabel.font = IconFont(22);
    self.selectBtn.isIgnore = YES;
    [self.selectBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.selectBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
    
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
    
    self.countTextField.hidden = self.buyCountInfoLabel.hidden = YES;
}

- (void)setTicket:(HomeTicket *)ticket {
    _ticket = ticket;
    self.count = self.ticket.totalCount ? self.ticket.totalCount : 1;
    self.titleTextLabel.text = ticket.ticket_name;
//    self.count = (ticket.ticket_num) ? ticket.ticket_num : 1;
    self.countTextField.text = @(self.count).description;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", ticket.ticket_sale_price];
    self.ticket.need_pay = (self.selectBtn.isSelected) ? (self.countTextField.text.integerValue * self.ticket.ticket_sale_price.floatValue) : 0;
//    self.count = ticket.totalCount;
//    self.ticket.totalCount = self.count;
}

- (IBAction)minusBtnTap:(UIButton *)button {
    self.count--;
    NSInteger minCount = (self.ticket.ticket_num) ? self.ticket.ticket_num : 1;
    if (self.count <= minCount) {
        self.count = minCount;
        button.enabled = NO;
    }
    [LaiMethod animationWithView:self.countTextField];
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
    [LaiMethod animationWithView:self.countTextField];
    self.countTextField.text = @(self.count).description;
    [self updateData];
    self.minusBtn.enabled = YES;
}

- (IBAction)selectBtnTap:(UIButton *)button {
    button.selected = !button.isSelected;
//    self.isSelected = button.selected;
    if (button.isSelected) {
        [LaiMethod animationWithView:button];
        self.selectCountViewH.constant = 60;
        self.minusBtnH.constant = self.plusBtnH.constant = self.textFieldBgH.constant = self.countTextFieldH.constant = 30;
    } else {
       self.selectCountViewH.constant = 0;
        self.minusBtnH.constant = self.plusBtnH.constant = self.textFieldBgH.constant = self.countTextFieldH.constant = 0;
        
    }
    if (self.didSelected) self.didSelected(self.selectIndexPath, button.isSelected ,self.count);
    [self updateData];
}

- (void)updateData {
    self.ticket.need_pay = (self.selectBtn.isSelected) ? (self.countTextField.text.integerValue * self.ticket.ticket_sale_price.floatValue) : 0;
    self.ticket.totalCount = self.count;
    if (self.countDidChange) self.countDidChange(self.count,self.selectBtn.isSelected,self.selectIndexPath);
}

- (void)setOpenType:(CellOpenType)openType {
    _openType = openType;
    switch (openType) {
        case CellOpenTypeClose:
            self.selectCountViewH.constant = 0;
            self.minusBtnH.constant = self.plusBtnH.constant = self.textFieldBgH.constant = self.countTextFieldH.constant = 0;
            self.selectBtn.selected = NO;
            self.countTextField.hidden = self.buyCountInfoLabel.hidden = YES;
            break;
        case CellOpenTypeOpen:
            self.selectCountViewH.constant = 60;
            self.minusBtnH.constant = self.plusBtnH.constant = self.textFieldBgH.constant = self.countTextFieldH.constant = 30;
            self.selectBtn.selected = YES;
            self.countTextField.hidden = self.buyCountInfoLabel.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)countTextField:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) return;
    if (self.ticket.ticket_num) {
        if (textField.text.integerValue < self.ticket.ticket_num) {
            textField.text = @(self.ticket.ticket_num).description;
            [SVProgressHUD showError:[NSString stringWithFormat:@"至少%zd张起售", self.ticket.ticket_num]];
        }
    }
    if (self.ticket.ticket_store_isopen == 1) {
        if (textField.text.integerValue > self.ticket.ticket_remain_num) {
            textField.text = @(self.ticket.ticket_remain_num).description;
            [SVProgressHUD showError:[NSString stringWithFormat:@"最多出售%zd张", self.ticket.ticket_remain_num]];
        }
    }
    [self updateData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(CGRectMake(0, 0, self.priceLabel.x, 65), point)) {
        [LaiMethod alertSPAlerCustomSheetCustomView:self.purchaseNoticeView handler:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
    return YES;
}

@end
