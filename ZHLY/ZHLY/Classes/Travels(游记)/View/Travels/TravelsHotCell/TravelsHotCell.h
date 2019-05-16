//
//  TravelsHotCell.h
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TravelStadium;
@interface TravelsHotCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<TravelStadium *> *stadiums;
@end
