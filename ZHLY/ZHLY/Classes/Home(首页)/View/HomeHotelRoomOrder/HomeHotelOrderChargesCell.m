//
//  HomeHotelOrderChargesCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/25.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHotelOrderChargesCell.h"
#import "Home.h"

@interface HomeHotelOrderChargesCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceInfoLabel;

@end

@implementation HomeHotelOrderChargesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)fillPriceDetail:(HomeHotelRoomPriceDetail *)roomPriceDetail withCount:(NSInteger)count {
    self.timeLabel.text = roomPriceDetail.date;
    self.priceInfoLabel.text = [NSString stringWithFormat:@"%zd x%@",count,roomPriceDetail.price];
}

@end
