//
//  HomeShoppingCarSectionHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/18.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShoppingCarSectionHeaderView.h"

@interface HomeShoppingCarSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@end

@implementation HomeShoppingCarSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.iconView.layer.cornerRadius = self.iconView.height * 0.5;
}

- (void)setIcon:(NSString *)icon {
    _icon = [icon copy];
    self.iconView.image = SetImage(icon);
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleTextLabel.text = title;
}

@end
