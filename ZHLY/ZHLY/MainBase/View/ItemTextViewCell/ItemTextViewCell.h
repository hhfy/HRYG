//
//  ItemTextViewCell.h
//
//  Created by LTWL on 2017/6/19.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TextViewFirstResponderTypeBecome = 0,
    TextViewFirstResponderTypeRegist
} TextViewFirstResponderType;

@class ItemTextViewCell;
@protocol ItemTextViewCellDelegate <NSObject>
@optional;
- (void)itemTextViewCell:(ItemTextViewCell *)itemTextViewCell textViewInputText:(NSString *)text;
- (void)textViewDidClick:(ItemTextViewCell *)itemTextViewCell;
@end

@interface ItemTextViewCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textViewBgColor;
@property (nonatomic, assign) TextViewFirstResponderType textViewResponderType;
@property (nonatomic, weak) id<ItemTextViewCellDelegate> delegate;
@end
