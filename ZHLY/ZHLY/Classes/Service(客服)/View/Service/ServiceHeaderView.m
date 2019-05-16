
//
//  ServiceHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/2.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceHeaderView.h"

@interface ServiceHeaderView ()
@property (weak, nonatomic) IBOutlet ServiceHeaderItemBtn *phoneBtn;
@property (weak, nonatomic) IBOutlet ServiceHeaderItemBtn *leavingMessageBtn;
@end

@implementation ServiceHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
}

- (IBAction)phoneBtnTap:(ServiceHeaderItemBtn *)button {
    [LaiMethod runtimePushVcName:@"ServicePhoneVC" dic:nil nav:CurrentViewController.navigationController];
}

- (IBAction)leaveMsgTap:(ServiceHeaderItemBtn *)button {
    [LaiMethod runtimePushVcName:@"ServiceLeaveMsgVC" dic:nil nav:CurrentViewController.navigationController];
}

@end

@implementation ServiceHeaderItemBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = self.currentImage.size;
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = 15;
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width;
    self.titleLabel.height = 30;
    self.titleLabel.y = self.imageView.maxY + 10;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
