
//
//  HomeMuseumSelectTouristAddView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseSelectTouristAddView.h"

@interface HomeShopBaseSelectTouristAddView ()

@end

@implementation HomeShopBaseSelectTouristAddView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
}

- (IBAction)addBtnTap:(UIButton *)button {
    [LaiMethod runtimePushVcName:@"HomeShopBaseEditTouristVC" dic:nil nav:CurrentViewController.navigationController];
}


@end
