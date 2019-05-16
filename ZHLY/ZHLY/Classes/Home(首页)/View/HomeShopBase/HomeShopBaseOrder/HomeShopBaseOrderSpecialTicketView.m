
//
//  HomeMuseumOrderSpecialTicketView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/8.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderSpecialTicketView.h"
@interface HomeShopBaseOrderSpecialTicketView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HomeShopBaseOrderSpecialTicketView

- (IBAction)detialBtnTap:(UIButton *)button {
    if (self.didTap) self.didTap();
}

-(void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
