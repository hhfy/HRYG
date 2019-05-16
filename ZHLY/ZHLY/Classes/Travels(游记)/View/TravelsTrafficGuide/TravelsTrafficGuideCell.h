//
//  TravelsTrafficGuideCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CellOpenTypeClose,
    CellOpenTypeOpen,
} CellOpenType;

@class TravelTrafficLines;
@interface TravelsTrafficGuideCell : UITableViewCell
@property (nonatomic, strong) TravelTrafficLines *trafficLines;
@property (nonatomic, assign) CellOpenType openType;
@end
