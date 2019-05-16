//
//  ContentTextViewCell.h
//  ZHLY
//
//  Created by LTWL on 2017/11/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextViewContentBlock)(NSString *text);

@interface ContentTextViewCell : UITableViewCell
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) TextViewContentBlock didInput;
@end
