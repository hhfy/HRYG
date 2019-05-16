
//
//  TravelsHotVenueHeaderCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/30.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsHotVenueHeaderCell.h"
#import "Travels.h"

@interface TravelsHotVenueHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation TravelsHotVenueHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setStadium:(TravelStadium *)stadium {
    _stadium = stadium;
    self.contentLabel.text = ([stadium.stadium_introduction isEqualToString:@""] || !stadium.stadium_introduction) ? @"暂无简介" : stadium.stadium_introduction;
}

@end
