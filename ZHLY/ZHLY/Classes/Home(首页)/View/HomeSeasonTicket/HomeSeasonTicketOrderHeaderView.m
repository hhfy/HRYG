//
//  HomeSeasonTicketOrderHeaderView.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/1/3.
//  Copyright © 2018年 LTWL. All rights reserved.
//

#import "HomeSeasonTicketOrderHeaderView.h"
#import "Home.h"
#import "HomeSeasonTicketOrderInfoView.h"

@interface HomeSeasonTicketOrderHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) HomeSeasonTicketOrderInfoView *infoView;
@property (nonatomic, strong) SPAlertController *alertController;
@end

@implementation HomeSeasonTicketOrderHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setTitle:(NSString *)title {
    _title = title;
    self.nameLabel.text = title;
}
-(void)setOrderPackage:(HomeSeasonTicketOrderPackage *)orderPackage {
    _orderPackage = orderPackage;
//    self.nameLabel.text = orderPackage.ticket_info.ticket_name;
}

- (IBAction)leftShowBtnAction:(id)sender {
    WeakSelf(weakSelf)
    [LaiMethod alertSPAlerCustomSheetCustomView:self.infoView handler:^(SPAlertController *alertController) {
        weakSelf.alertController = alertController;
    }];
}


- (HomeSeasonTicketOrderInfoView *)infoView {
    if (!_infoView){
        _infoView = [HomeSeasonTicketOrderInfoView viewFromXib];
        _infoView.orderPackage = self.orderPackage;
        WeakSelf(weakSelf)
        _infoView.dismiss = ^{
            [weakSelf.alertController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _infoView;
}

@end
