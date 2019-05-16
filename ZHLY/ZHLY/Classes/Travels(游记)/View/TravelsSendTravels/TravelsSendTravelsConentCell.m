//
//  TravelsSendTravelsConentCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsSendTravelsConentCell.h"
#import "TravelsSendTravelsConentVC.h"

@interface TravelsSendTravelsConentCell ()
@property (weak, nonatomic) IBOutlet UIView *contianerView;
@end

@implementation TravelsSendTravelsConentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    TravelsSendTravelsConentVC *contentVc = [TravelsSendTravelsConentVC new];
    contentVc.view.frame = CGRectMake(0, 0, 200, 200);
    [self.contianerView addSubview:contentVc.view];
}

@end
