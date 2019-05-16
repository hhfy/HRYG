//
//  HomeExhibitionHallDateCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeExhibitionHallDateCell.h"

@interface HomeExhibitionHallDateCell ()
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@end

@implementation HomeExhibitionHallDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.layer.cornerRadius = 5;
    self.layer.borderColor = SetupColor(193, 193, 193).CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = MainThemeColor.CGColor;
        self.weekLabel.textColor = [UIColor whiteColor];
        self.monthLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = MainThemeColor;
        [LaiMethod animationWithView:self];
    } else {
        self.layer.borderColor = SetupColor(193, 193, 193).CGColor;
        self.weekLabel.textColor = SetupColor(51, 51, 51);
        self.monthLabel.textColor = SetupColor(51, 51, 51);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
