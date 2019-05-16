//
//  ItemArrowCell.m
//  ZTXWYGL
//
//  Created by LTWL on 2017/6/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ItemArrowCell.h"

@interface ItemArrowCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowIconLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopSpace;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineRightSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iocnW;
@end

@implementation ItemArrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.arrowIconLabel.font = IconFont(18);
    self.arrowIconLabel.text = RightArrowIconUnicode;
    self.iocnW.constant = 0;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.itemTitleLabel.text = title;
    self.iocnW.constant = (self.icon) ? self.contentView.height : 15;
}

- (void)setIcon:(NSString *)icon {
    _icon = [icon copy];
    [self.iconBtn setImage:SetImage(icon) forState:UIControlStateNormal];
    self.iocnW.constant = (self.icon) ? self.contentView.height : 15;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.itemTextLabel.text = text;
    self.iocnW.constant = (self.icon) ? self.contentView.height : 15;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.itemTextLabel.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.itemTextLabel.font = textFont;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.itemTitleLabel.font = titleFont;
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    self.lineTopSpace.constant = cellHeight;
}

- (void)setTextAlign:(NSTextAlignment)textAlign {
    _textAlign = textAlign;
    self.itemTextLabel.textAlignment = textAlign;
}

- (void)setLineLeftW:(CGFloat)lineLeftW {
    _lineLeftW = lineLeftW;
    self.lineLeftSpace.constant = lineLeftW;
}

- (void)setLineRightW:(CGFloat)lineRightW {
    _lineRightW = lineRightW;
    self.lineRightSpace.constant = lineRightW;
}

- (void)setArrowStytle:(CellArrowStytle)arrowStytle {
    _arrowStytle = arrowStytle;
    switch (arrowStytle) {
        case CellArrowStytleNormal:
            self.arrowIconLabel.text = RightArrowIconUnicode;
            break;
        case CellArrowStytleHollow:
            self.arrowIconLabel.text = RightArrowIconUnicode2;
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        if (self.didTap) self.didTap();
        if (self.seletedEnableType == CellClickEnableTypeDisable) {
            if (self.setecedWithEnable) self.setecedWithEnable();
        }
    }
}

@end
