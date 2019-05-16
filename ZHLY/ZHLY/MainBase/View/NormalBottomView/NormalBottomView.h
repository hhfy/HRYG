//
//  NormalBottomView.h
//  ZTXWY
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ItemBtnStatusTypeEnbale,
    ItemBtnStatusTypeDisable
} ItemBtnStatusType;

typedef void(^ViewDidTapBlock)(void);

@interface NormalBottomView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *btnBgColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) ItemBtnStatusType statusType;
@property (nonatomic, copy) ViewDidTapBlock didTap;
- (void)addTarget:(id)target action:(SEL)action;
@end
