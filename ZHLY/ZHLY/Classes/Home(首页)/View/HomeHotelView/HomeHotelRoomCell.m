//
//  HomeHotelRoomCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHotelRoomCell.h"
#import "Home.h"
#import "HomeShopBaseShoppingCarSheetView.h"
#import "HomeShopBaseOrderPurchaseNoticeView.h"

@interface HomeHotelRoomCell ()
@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookBtnCenterY;
@property (nonatomic, strong) HomeShopBaseOrderPurchaseNoticeView *purchaseNoticeView;
@property (nonatomic, strong) SPAlertController *alertController;
@end

@implementation HomeHotelRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.bookBtn.layer.cornerRadius = 5;
}

- (HomeShopBaseOrderPurchaseNoticeView *)purchaseNoticeView {
    if (_purchaseNoticeView == nil) {
        _purchaseNoticeView = [HomeShopBaseOrderPurchaseNoticeView viewFromXib];
//        _purchaseNoticeView.content = self.roomInfo.hotel_intro_content;
        WeakSelf(weakSelf)
        _purchaseNoticeView.dismiss = ^{
            [weakSelf.alertController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _purchaseNoticeView;
}

//购买须知
- (IBAction)buyNoticeAction:(id)sender {
    WeakSelf(weakSelf)
    [LaiMethod alertSPAlerCustomSheetCustomView:self.purchaseNoticeView handler:^(SPAlertController *alertController) {
        weakSelf.alertController = alertController;
    }];
}
//购买
- (IBAction)bookBtnTap:(UIButton *)button {
//    HomeShopBaseShoppingCarSheetView *shoppingCarSheetView = [HomeShopBaseShoppingCarSheetView viewFromXib];
//    [shoppingCarSheetView show];
//    WeakSelf(weakSelf)
//    shoppingCarSheetView.dismissCallBack = ^(NSInteger count) {
//        button.selected = YES;
        [LaiMethod animationWithView:button];
        if (self.addRoomOrder) self.addRoomOrder(self.roomInfo, 1);
//    };
}

//加入购物车
- (IBAction)addShoppingCarBtnTap:(UIButton *)button {
    HomeShopBaseShoppingCarSheetView *shoppingCarSheetView = [HomeShopBaseShoppingCarSheetView viewFromXib];
    [shoppingCarSheetView show];
    WeakSelf(weakSelf)
    shoppingCarSheetView.dismissCallBack = ^(NSInteger count) {
        button.selected = YES;
        [LaiMethod animationWithView:button];
        if (weakSelf.addShoppingCar) weakSelf.addShoppingCar(self.roomInfo, count);
    };
}

- (void)setRoomInfo:(HomeHotelRoomInfo *)roomInfo {
    _roomInfo = roomInfo;
    self.nameLabel.text = roomInfo.room_name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", roomInfo.price];
//    if (roomInfo.ticket_type == 1 && roomInfo.ticket_intro_type == 2) {
        [self.shoppingCarBtn setImage:SetImage(@"购物车") forState:UIControlStateNormal];
        self.bookBtnCenterY.constant = 20;
//    } else {
//        [self.shoppingCarBtn setImage:nil forState:UIControlStateNormal];
//        self.bookBtnCenterY.constant = 0;
//    }
}

-(void)setHotelInfo:(HomeHotelInfo *)hotelInfo {
    _hotelInfo = hotelInfo;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeHotelVCNavShowNotification" object:nil];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"apiUrl"] = @"http://192.168.1.98:9002/hotel_detail.html";
        params[@"roomId"] = self.roomInfo.room_id;
        params[@"titleText"] = @"房间详情";
        params[@"hotelInfo"] = self.hotelInfo;
        [LaiMethod runtimePushVcName:@"HomeHotelRoomDetailVC" dic:params nav:CurrentViewController.navigationController];
    }
}

@end
