//
//  HomeSearchSectionHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/18.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeSearchSectionHeaderView.h"

@interface HomeSearchSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@end

@implementation HomeSearchSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
//    self.iconView.layer.cornerRadius = self.iconView.height * 0.5;
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
