//
//  ItemTextCell.m
//  ZTXWYGL
//
//  Created by LTWL on 2017/6/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ItemTextCell.h"

@interface ItemTextCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTextLeftSpace;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemIconW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTitleLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopRightSpace;
@end

@implementation ItemTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    if (iPhone5) {
        self.itemTextLeftSpace.constant = 0;
    } else if (iPhone6) {
        self.itemTextLeftSpace.constant = 0;
    } else if (iPhone6P) {
        self.itemTextLeftSpace.constant = 0;
    }
    self.itemTextLabel.textAlignment = NSTextAlignmentLeft;
    self.itemIconW.constant = 0;
    self.itemTitleLeftSpace.constant = 0;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.itemTextLabel.text = text;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.itemTitleLabel.text = title;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.itemTextLabel.textColor = textColor;
}

- (void)setIcon:(NSString *)icon {
    _icon = [icon copy];
    self.iconView.image = SetImage(icon);
    self.itemIconW.constant = (icon) ? 17 : 0;
    self.itemTitleLeftSpace.constant = (icon) ? 10 : 0;
}


- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.itemTitleLabel.textColor = titleColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.itemTextLabel.textAlignment = textAlignment;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.itemTitleLabel.font = titleFont;
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    self.lineTopSpace.constant = cellHeight;
}

- (void)setLineLeftW:(CGFloat)lineLeftW {
    _lineLeftW = lineLeftW;
    self.lineTopLeftSpace.constant = lineLeftW;
}

- (void)setLineRightW:(CGFloat)lineRightW {
    _lineRightW = lineRightW;
    self.lineTopRightSpace.constant = lineRightW;
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    if (self.highlighted) {
//        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//        scaleAnimation.duration = 0.1;
//        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
//        scaleAnimation.beginTime = CACurrentMediaTime() + 0.01;
//        [self.itemTextLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
//    } else {
//        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
//        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
//        sprintAnimation.springBounciness = 20.f;
//        sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
//        [self.itemTextLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
//    }
//}

@end
