//
//  DropDownMenu.h
//  41-新浪微博
//
//  Created by LTWL on 2016/12/24.
//  Copyright © 2016年 赖同学. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownMenu;
@protocol DropDownMenuDelegate <NSObject>
- (void)dropdownMenuDidDismiss:(DropDownMenu *)menu;
- (void)dropdownMenuDidShow:(DropDownMenu *)menu;
@end

@interface DropDownMenu : UIView
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic, weak) id<DropDownMenuDelegate> delegate;

+ (instancetype)menu;
- (void)showFrom:(UIView *)from;
- (void)dismiss;

@end
