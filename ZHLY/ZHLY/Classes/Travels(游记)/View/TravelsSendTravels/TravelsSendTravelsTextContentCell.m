//
//  TravelsSendTravelsTextContentCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsSendTravelsTextContentCell.h"

@interface TravelsSendTravelsTextContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end

@implementation TravelsSendTravelsTextContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(NSString *)info {
    _info = [info copy];
    self.infoLabel.text = info;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        if (self.didTap) self.didTap();
    }
}

@end
