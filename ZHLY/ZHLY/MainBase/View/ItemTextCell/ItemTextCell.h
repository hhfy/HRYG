//
//  ItemTextCell.h
//  ZTXWYGL
//
//  Created by LTWL on 2017/6/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTextCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat lineLeftW;
@property (nonatomic, assign) CGFloat lineRightW;
@end
