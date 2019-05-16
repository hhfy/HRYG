//
//  TravelsSendTravelsTextContentCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellDidTapBlock)(void);

@interface TravelsSendTravelsTextContentCell : UITableViewCell
@property (nonatomic, copy) CellDidTapBlock didTap;
@property (nonatomic, copy) NSString *info;
@end
