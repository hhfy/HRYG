
//
//  HomeSeasonTicketOrderCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeSeasonTicketOrderCell.h"
#import "Home.h"

@interface HomeSeasonTicketOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
//@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIView *countTextFiledBgView;
@property (weak, nonatomic) IBOutlet UIView *segmentingLineView;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) SPAlertController *alertController;
@end

@implementation HomeSeasonTicketOrderCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
//    self.count = 1;
//    self.countTextField.text = @(self.count).description;
//    self.minusBtn.isIgnore = self.plusBtn.isIgnore = YES;
//    self.minusBtn.enabled = NO;
//
//    self.countTextFiledBgView.layer.borderWidth = 0.5;
//    self.countTextFiledBgView.layer.borderColor = SetupColor(224, 157, 91).CGColor;
//    self.minusBtn.titleLabel.font = self.plusBtn.titleLabel.font = IconFont(20);
//    self.minusBtn.adjustsImageWhenHighlighted = self.plusBtn.adjustsImageWhenHighlighted = NO;
//    [self.minusBtn setTitle:MinusIconUnicode forState:UIControlStateNormal];
//    [self.minusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
//    [self.minusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
//    [self.plusBtn setTitle:PlusIconUnicode forState:UIControlStateNormal];
//    [self.plusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
//    [self.plusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
//    [self.countTextField addTarget:self action:@selector(countTextField:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setTicket:(HomeSeasonTicketOrderTicketInfo *)ticket {
//    _ticket = ticket;
//    self.titleTextLabel.text = ticket.ticket_name;
//    self.count = (ticket.ticket_num) ? [ticket.ticket_num integerValue] : 1;
//    self.countTextField.text = [NSString stringWithFormat:@"%zd",self.count];
//    self.dateLabel.text = ticket.ticket_deadline_text;
//    self.ticket.totalPrice = self.countTextField.text.integerValue * self.ticket.ticket_price.floatValue;
//    self.ticket.totalCount = self.count;
//
//    NSInteger minCount = (ticket.ticket_num) ? [ticket.ticket_num integerValue]: 1;
//    self.minusBtn.enabled = !([ticket.ticket_num integerValue] == minCount);
//    if (self.ticket.ticket_store_isopen == 1 && self.ticket.ticket_store_num) {
//        NSInteger maxCount = self.ticket.ticket_store_num;
//        self.plusBtn.enabled = !([ticket.ticket_num integerValue] == maxCount);
//    }
}

-(void)setSeasonTicket:(HomeMuseumSeasonTickets *)seasonTicket {
    _seasonTicket = seasonTicket;
    self.dateLabel.text = seasonTicket.useDate;
    self.countTextField.text = [NSString stringWithFormat:@"x%@",seasonTicket.buyNum];
}

- (void)setIsShowSegmentingLine:(BOOL)isShowSegmentingLine {
    _isShowSegmentingLine = isShowSegmentingLine;
    self.segmentingLineView.backgroundColor = (isShowSegmentingLine) ? SetupColor(227, 227, 227) : [UIColor clearColor];
}

- (IBAction)minusBtnTap:(UIButton *)button {
    self.count--;
//    NSInteger minCount = (self.ticket.ticket_num) ? [self.ticket.ticket_num integerValue]: 1;
//    if (self.count <= minCount) {
//        self.count = minCount;
//        button.enabled = NO;
//    }
//    if (button.isEnabled) [LaiMethod animationWithView:self.countTextField];
//    self.countTextField.text = [NSString stringWithFormat:@"%zd",self.count];
//    [self updateData];
//    self.plusBtn.enabled = YES;
}

- (IBAction)plusBtnTap:(UIButton *)button {
//    self.count++;
//    if (self.ticket.ticket_store_isopen == 1) {
//        if (self.count >= self.ticket.ticket_store_num) {
//            self.count = self.ticket.ticket_store_num;
//            button.enabled = NO;
//        }
//    }
//    if (button.isEnabled) [LaiMethod animationWithView:self.countTextField];
//    self.countTextField.text = [NSString stringWithFormat:@"%zd",self.count];
//    [self updateData];
//    self.minusBtn.enabled = YES;
}

- (void)countTextField:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) return;
//    WeakSelf(weakSelf)
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (weakSelf.ticket.ticket_num) {
//            if (textField.text.integerValue < [weakSelf.ticket.ticket_num integerValue]) {
//                textField.text = weakSelf.ticket.ticket_num;
//                [SVProgressHUD showError:[NSString stringWithFormat:@"至少%zd张起售", weakSelf.ticket.ticket_num]];
//            }
//        }
//        if (weakSelf.ticket.ticket_store_isopen == 1) {
//            if (textField.text.integerValue > weakSelf.ticket.ticket_store_num) {
//                textField.text = @(weakSelf.ticket.ticket_store_num).description;
//                [SVProgressHUD showError:[NSString stringWithFormat:@"最多出售%zd张", weakSelf.ticket.ticket_store_num]];
//            }
//        }
//        [self updateData];
//    });
}


- (void)updateData {
//    self.ticket.totalPrice = self.countTextField.text.integerValue * self.ticket.ticket_price.doubleValue;
//    self.ticket.totalCount = self.count;
//    if (self.countDidChanged) self.countDidChanged();
}

@end
