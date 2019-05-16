
//
//  ServicePhoneView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServicePhoneView.h"
#import "Service.h"

@interface ServicePhoneView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@end

@implementation ServicePhoneView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.iconLabel.font = IconFont(20);
}

- (void)setServicePhone:(ServicePhone *)servicePhone {
    _servicePhone = servicePhone;
    self.nameLabel.text = servicePhone.name;
    self.iconLabel.text = [NSString getIconStringWithName:servicePhone.icon];
}

@end
