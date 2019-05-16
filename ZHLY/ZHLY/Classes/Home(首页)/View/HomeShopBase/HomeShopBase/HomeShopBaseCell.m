
//
//  HomeMuseumCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseCell.h"
#import "Home.h"
#import "HomeShopBaseShoppingCarSheetView.h"
#import "HomeShopBaseOrderPurchaseNoticeView.h"

@interface HomeShopBaseCell ()
@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookBtnCenterY;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (nonatomic, strong) HomeShopBaseOrderPurchaseNoticeView *purchaseNoticeView;
@property (nonatomic, weak) SPAlertController *alertController;
@end

@implementation HomeShopBaseCell

- (HomeShopBaseOrderPurchaseNoticeView *)purchaseNoticeView
{
    if (_purchaseNoticeView == nil)
    {
        _purchaseNoticeView = [HomeShopBaseOrderPurchaseNoticeView viewFromXib];
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
    self.bookBtn.layer.cornerRadius = 5;
}

//购买
- (IBAction)bookBtnTap:(UIButton *)button {
    [LaiMethod animationWithView:button];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 0.9) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.payfor) self.payfor();
    });
}

- (IBAction)addShoppingCarBtnTap:(UIButton *)button {
    HomeShopBaseShoppingCarSheetView *shoppingCarSheetVIew = [HomeShopBaseShoppingCarSheetView viewFromXib];
    shoppingCarSheetVIew.museumTicket = self.ticket;
    [shoppingCarSheetVIew show];
    WeakSelf(weakSelf)
    shoppingCarSheetVIew.dismissCallBack = ^(NSInteger count) {
        button.selected = YES;
        [LaiMethod animationWithView:button];
        if (weakSelf.addShoppingCar) weakSelf.addShoppingCar(count);
    };
}

- (void)setTicket:(HomeTicket *)ticket {
    _ticket = ticket;
    self.nameLabel.text = ticket.ticket_name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", ticket.ticket_sale_price];
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(ticket.ticket_image) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    if (ticket.ticket_type == 1 && ticket.ticket_intro_type == 2) {
        [self.shoppingCarBtn setImage:SetImage(@"购物车") forState:UIControlStateNormal];
        self.bookBtnCenterY.constant = 20;
    } else {
        [self.shoppingCarBtn setImage:nil forState:UIControlStateNormal];
        self.bookBtnCenterY.constant = 0;
    }
}
- (IBAction)buyNoticeBtnTap:(UIButton *)button {
    WeakSelf(weakSelf)
    [LaiMethod alertSPAlerCustomSheetCustomView:self.purchaseNoticeView handler:^(SPAlertController *alertController) {
        weakSelf.alertController = alertController;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        if(self.ticket.biz_room_id){
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeHotelVCNavShowNotification" object:nil];
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            params[@"Id"] = self.ticket.biz_ticket_id;
//            params[@"titleText"] = @"房间详情";
//            params[@"ordinaryTicket"] = self.ticket;
//            [LaiMethod runtimePushVcName:@"HomeHotelRoomDetailVC" dic:params nav:CurrentViewController.navigationController];
        }
        else {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"titleText"] = @"门票详情";
            params[@"apiUrl"] = @"http://192.168.1.98:9002/ticket_detail.html";
            params[@"Id"] = self.ticket.biz_ticket_id;
            params[@"ordinaryTicket"] = self.ticket;
            [LaiMethod runtimePushVcName:@"HomeShopBaseDetialVC" dic:params nav:CurrentViewController.navigationController];
        }
    }
}

@end
