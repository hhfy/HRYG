
//
//  TravelsItemCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsItemCell.h"

@interface TravelsItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@end

@implementation TravelsItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.titleTextLabel.text = text;
}

- (void)setIcon:(NSString *)icon {
    _icon = [icon copy];
    self.iconView.image = SetImage(icon);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) [LaiMethod animationWithView:self.iconView];
}

@end
