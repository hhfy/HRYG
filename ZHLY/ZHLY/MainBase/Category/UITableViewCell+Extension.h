//
//  UITableViewCell+Extension.h
//
//  Created by LTWL on 2017/5/17.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Extension)
+ (instancetype)cellFromXibWithTableView:(UITableView *)tableView;
+ (void)creatAnimationWithCell:(UITableViewCell *)cell;
@end
