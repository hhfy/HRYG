
//
//  HomeShoppingCarOrderCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/21.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShoppingCarOrderCell.h"
#import "Home.h"
#import "HomeShopBaseOrderPurchaseNoticeView.h"

@interface HomeShoppingCarOrderCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *specificationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImgView;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (nonatomic, strong) HomeShopBaseOrderPurchaseNoticeView *purchaseNoticeView;
@property (nonatomic, strong) SPAlertController *alertController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@end

@implementation HomeShoppingCarOrderCell

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
    // Initialization code
}

//旧版
- (void)setHotel:(HomeShoppingCarHotel *)hotel {
    _hotel = hotel;
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(SmallImage(hotel.home_image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    self.titleTextLabel.text = hotel.room_name;
    self.dateLabel.text = [NSString stringWithFormat:@"入离店日期：%@-%@", [NSString stringFromTimestampFromat:hotel.s_date formatter:FmtMD2], [NSString stringFromTimestampFromat:hotel.room_end_time formatter:FmtMD2]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", hotel.price];
    self.specificationsLabel.text = [NSString stringWithFormat:@"x%zd", hotel.number];
    hotel.totalCount = hotel.number;
    hotel.totalPrice = hotel.price.floatValue * hotel.number;
}

- (void)setTicket:(HomeShoppingCarTicket *)ticket {
    _ticket = ticket;
    [self.loaddingView startAnimating];
    self.titleTextLabel.text = ticket.ticket_name;
    CGFloat width = [self getWidthWithHeight:20 text:ticket.ticket_name font:[UIFont systemFontOfSize:15]];
    if(width>MainScreenSize.width - 151){
        self.titleWidth.constant = MainScreenSize.width - 155;
        self.titleTextLabel.numberOfLines = 2;
    }
    else {
        self.titleWidth.constant = width+5;
    }
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(SmallImage(ticket.ticket_image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    
    if(ticket.start_date && ticket.end_date){
        self.dateLabel.text = [NSString stringWithFormat:@"入住时间:%@~%@", ticket.start_date,ticket.end_date];
    }
    else {
        NSString *date = ticket.date ? ticket.date : [NSString dateStr:ticket.ticket_check_stime formatter:@"yyyy-MM-dd HH:mm:ss" formatWithOtherFormatter:@"yyyy-MM-dd"];
       self.dateLabel.text = [NSString stringWithFormat:@"使用日期:%@",date];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", ticket.ticket_sale_price];
    if(ticket.site_name && ticket.site_name.length>0){
        self.specificationsLabel.text = ticket.site_name;
    }
    else {
        self.specificationsLabel.text = [NSString stringWithFormat:@"x%zd", ticket.ticket_lock_num];
    }
    ticket.totalCount = ticket.ticket_num;
    ticket.totalPrice = ticket.ticket_num * ticket.ticket_sale_price.floatValue;
}

//套票订单
-(void)setSeasonTicket:(HomeSeasonTicketOrderTicketList *)seasonTicket {
    _seasonTicket = seasonTicket;
    [self.loaddingView startAnimating];
    self.titleTextLabel.text = seasonTicket.ticket_name;
    CGFloat width = [self getWidthWithHeight:20 text:seasonTicket.ticket_name font:[UIFont systemFontOfSize:15]];
    if(width>MainScreenSize.width - 155){
        self.titleWidth.constant = MainScreenSize.width - 155;
        self.titleTextLabel.numberOfLines = 2;
    }
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(SmallImage(seasonTicket.ticket_image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    self.dateLabel.hidden = YES;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", seasonTicket.pt_ticket_price];
    self.specificationsLabel.text = [NSString stringWithFormat:@"x%@",seasonTicket.pt_ticket_num];
}

-(CGFloat)getWidthWithHeight:(CGFloat)height text:(NSString *)text font:(UIFont *)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size.width;
}

-(void)setShowImg:(BOOL)showImg {
    _showImg = showImg;
    if (showImg) {
        _showImgView.hidden = NO;
        _showBtn.hidden = NO;
    }
}
//购买须知
- (IBAction)showBtnAction:(id)sender {
    WeakSelf(weakSelf)
    [LaiMethod alertSPAlerCustomSheetCustomView:self.purchaseNoticeView handler:^(SPAlertController *alertController) {
        weakSelf.alertController = alertController;
    }];
}

@end
