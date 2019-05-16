//
//  HomeMuseumOrderHeaderCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CountDidChangedBlock)();

@class HomeTicket;
@interface HomeShopBaseOrderHeaderCell : UITableViewCell
@property (nonatomic, strong) HomeTicket *ticket;
@property (nonatomic, copy) CountDidChangedBlock countDidChanged;
@property (nonatomic, assign) BOOL isShowSegmentingLine;
@end
