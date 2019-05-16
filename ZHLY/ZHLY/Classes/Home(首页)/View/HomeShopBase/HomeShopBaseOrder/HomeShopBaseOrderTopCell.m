//
//  HomeShopBaseOrderTopCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderTopCell.h"
#import "Home.h"
#import "HomeShopBaseOrderPurchaseNoticeView.h"

@interface HomeShopBaseOrderTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *segmentingLineView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) HomeShopBaseOrderPurchaseNoticeView *purchaseNoticeView;
@property (nonatomic, strong) SPAlertController *alertController;
@end

@implementation HomeShopBaseOrderTopCell

- (HomeShopBaseOrderPurchaseNoticeView *)purchaseNoticeView {
    if (_purchaseNoticeView == nil) {
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
}

- (void)setTicket:(HomeTicket *)ticket {
    _ticket = ticket;
    self.count = ticket.totalCount;
    self.titleTextLabel.text = ticket.ticket_name;
    self.dateLabel.text = ticket.ticket_deadline_text;
    self.numLabel.text = [NSString stringWithFormat:@"x%zd",ticket.totalCount];
}

- (void)setIsShowSegmentingLine:(BOOL)isShowSegmentingLine {
    _isShowSegmentingLine = isShowSegmentingLine;
    self.segmentingLineView.backgroundColor = (isShowSegmentingLine) ? SetupColor(227, 227, 227) : [UIColor clearColor];
}

- (IBAction)purchaseNoticeBtnTap:(UIButton *)sender {
    WeakSelf(weakSelf)
    [LaiMethod alertSPAlerCustomSheetCustomView:self.purchaseNoticeView handler:^(SPAlertController *alertController) {
        weakSelf.alertController = alertController;
    }];
}

- (void)updateData {
//    self.ticket.need_pay = self.countTextField.text.integerValue * self.ticket.ticket_sale_price.doubleValue;
    self.ticket.totalCount = self.count;
//    if (self.countDidChanged) self.countDidChanged();
}

@end
