//
//  HomeItemContentCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeItemContentCell.h"

@interface HomeItemContentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@end

@implementation HomeItemContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if(iPhone5 || iPhoneSE){
        self.imgHeight.constant = 35;
    }
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleTextLabel.text = title;
}

- (void)setIcon:(NSString *)icon {
    _icon = [icon copy];
    if([icon containsString:@"http"]){
//        self.iconView.image = SetImage(@"博物馆-1");
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",icon]] placeholderImage:[UIImage imageNamed:@"博物馆-1"] options:SDWebImageRetryFailed];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else {
        self.iconView.image = SetImage(icon);
    }
//    self.iconView.layer.cornerRadius = self.iconView.height/2;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) [LaiMethod animationWithView:self.iconView];
}

@end
