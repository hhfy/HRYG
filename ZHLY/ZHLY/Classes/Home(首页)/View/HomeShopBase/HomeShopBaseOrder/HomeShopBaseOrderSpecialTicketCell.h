//
//  HomeMuseumOrderSpecialTicketCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/7.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellDidSelectedBlock)(NSIndexPath *selectIndexPath, BOOL isSelected,NSInteger count);
typedef void(^CountChangedBlock)(NSInteger count,BOOL isSelected,NSIndexPath *selectIndexPath);

typedef enum : NSUInteger {
    CellOpenTypeClose,
    CellOpenTypeOpen,
} CellOpenType;

@class HomeTicket;
@interface HomeShopBaseOrderSpecialTicketCell : UITableViewCell
@property (nonatomic, strong) HomeTicket *ticket;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, copy) CellDidSelectedBlock didSelected;
@property (nonatomic, assign) CellOpenType openType;
@property (nonatomic, copy) CountChangedBlock countDidChange;
//@property (nonatomic, assign) BOOL isSelected;
@end
