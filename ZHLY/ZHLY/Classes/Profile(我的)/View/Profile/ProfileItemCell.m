//
//  ProfileItemCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ProfileItemCell.h"

@interface ProfileItemCell ()

@end

@implementation ProfileItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)unpaidBtnAction:(ProfileItemBtn *)sender {
    if (self.btnActionBlock) self.btnActionBlock(sender.tag);
}

- (IBAction)unconsumedBtnAction:(ProfileItemBtn *)sender {
    if (self.btnActionBlock) self.btnActionBlock(sender.tag);
}

- (IBAction)completedBtnAction:(ProfileItemBtn *)sender {
    if (self.btnActionBlock) self.btnActionBlock(sender.tag);
}

- (IBAction)refundedBtnAction:(ProfileItemBtn *)sender {
    if (self.btnActionBlock) self.btnActionBlock(sender.tag);
}


@end

@implementation ProfileItemBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = 15;
    self.imageView.size = self.currentImage.size;
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width;
    self.titleLabel.y = self.imageView.maxY + 10;
    self.titleLabel.height = 20;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

