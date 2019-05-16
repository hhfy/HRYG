//
//  ServiceContentCell.h
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceCommonQuestionDetial;
typedef void(^SelectedBlock)(NSIndexPath *selectedIndexPath);

typedef enum : NSUInteger {
    CellOpenTypeClose,
    CellOpenTypeOpen,
} CellOpenType;

@interface ServiceContentCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexpath;
@property (nonatomic, copy) SelectedBlock cellSelected;
@property (nonatomic, assign) CellOpenType openType;
@property (nonatomic, strong) ServiceCommonQuestionDetial *questionDetial;
@end
