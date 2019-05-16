//
//  ServiceSectionHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceSectionHeaderView.h"
#import "Service.h"

@interface ServiceSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@end

@implementation ServiceSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.iconLabel.font = IconFont(18);
    self.iconLabel.textColor = MainThemeColor;
}

- (void)setCommonQuestion:(ServiceCommonQuestion *)commonQuestion {
    _commonQuestion = commonQuestion;
    self.iconLabel.text = [NSString getIconStringWithName:commonQuestion.icon];
    self.titleTextLabel.text = commonQuestion.name;
}

@end
