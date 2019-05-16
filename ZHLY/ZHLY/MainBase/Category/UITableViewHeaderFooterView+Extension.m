//
//  UITableViewHeaderFooterView+Extension.m
//
//  Created by LTWL on 2017/7/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "UITableViewHeaderFooterView+Extension.h"

@implementation UITableViewHeaderFooterView (Extension)
+ (instancetype)headerFooterViewFromXibWithTableView:(UITableView *)tableView {
    NSString *ID = NSStringFromClass(self);
    id header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        UINib *xib = [UINib nibWithNibName:ID bundle:nil];
        [tableView registerNib:xib forHeaderFooterViewReuseIdentifier:ID];
    }
    return header;
}

@end
