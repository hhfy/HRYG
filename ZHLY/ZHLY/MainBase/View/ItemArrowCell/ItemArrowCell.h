//
//  ItemArrowCell.h
//  ZTXWYGL
//
//  Created by LTWL on 2017/6/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellDidSetecedBlock)(void);
typedef void(^CellDidTapBlock)(void);

typedef enum : NSUInteger {
    CellSeletedEnableTypeAble,
    CellSeletedEnableTypeDisable
} CellSeletedEnableType;

typedef enum : NSUInteger {
    CellArrowStytleNormal,
    CellArrowStytleHollow,
} CellArrowStytle;

@interface ItemArrowCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) CGFloat lineLeftW;
@property (nonatomic, assign) CGFloat lineRightW;
@property (nonatomic, assign) CellArrowStytle arrowStytle;
@property (nonatomic, assign) NSTextAlignment textAlign;

@property (nonatomic, copy) CellDidSetecedBlock setecedWithEnable;
@property (nonatomic, copy) CellDidTapBlock didTap;
@property (nonatomic, assign) CellSeletedEnableType seletedEnableType;

@end
