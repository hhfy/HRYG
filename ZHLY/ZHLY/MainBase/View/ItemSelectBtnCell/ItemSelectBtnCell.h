//
//  ItemSelectBtnCell.h
//  ZTXWYGL
//
//  Created by LTWL on 2017/6/17.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SelectedBtnTypeFirst,
    SelectedBtnTypeSecond
} SelectedBtnType;

typedef enum : NSUInteger {
    SelectedBtnModeMultiple,
    SelectedBtnModeSingle
} SelectedBtnMode;

typedef void(^SelectBtnDidSelectedBlock)(NSInteger selectedIndex, BOOL isSelected);

@interface ItemSelectBtnCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *firstText;
@property (nonatomic, copy) NSString *secondText;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat selectBtnLeft;
@property (nonatomic, assign) BOOL selectBtnIsSeleted;
@property (nonatomic, assign) SelectedBtnType selectedBtnType;
@property (nonatomic, assign) SelectedBtnMode selectedBtnMode;
@property (nonatomic, copy) SelectBtnDidSelectedBlock didSelected;
@end
