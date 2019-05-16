//
//  HomeExhibitionHallDetialCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeExhibitionHallDetialCell.h"

@interface HomeExhibitionHallDetialCell ()
@property (weak, nonatomic) IBOutlet UILabel *arrowIconLabel;

@end

@implementation HomeExhibitionHallDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.arrowIconLabel.text = RightArrowIconUnicode;
    self.arrowIconLabel.font = IconFont(18);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
