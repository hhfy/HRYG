//
//  UITableView+Extension.h
//  ZHDJ
//
//  Created by LTWL on 2017/9/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extension)
@property (nonatomic, assign, readonly) BOOL firstReload;
@property (nonatomic, strong) UIView *loaddingView;
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic, strong, readonly) UIView *superView;
@property (nonatomic, assign) BOOL isHideNoDataView;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, strong) UIImage *placeholderImage;
@end
