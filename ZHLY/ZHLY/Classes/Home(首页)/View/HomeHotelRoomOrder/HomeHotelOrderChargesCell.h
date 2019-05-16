//
//  HomeHotelOrderChargesCell.h
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/25.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeHotelRoomPriceDetail;
@interface HomeHotelOrderChargesCell : UITableViewCell

-(void)fillPriceDetail:(HomeHotelRoomPriceDetail *)roomPriceDetail withCount:(NSInteger)count;

@end
