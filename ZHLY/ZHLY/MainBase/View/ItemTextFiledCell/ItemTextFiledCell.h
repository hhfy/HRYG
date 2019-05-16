//
//  ItemTextFiledCell.h
//
//  Created by LTWL on 2017/6/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 传递textFiled里面的内容
typedef void(^ItemTextFiledTextDidChangeBlock)(NSString *text);
/// 监听textFiled开始编辑点击事件
typedef void(^ItemTextFiledTextBeginEditBlock)(void);

@interface ItemTextFiledCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, strong) UIColor *placeholderColor;  
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTextAlignment textAlign;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, strong) UIColor *textFieldBgColor;
@property (nonatomic, assign) CGFloat lineLeftW;
@property (nonatomic, assign) CGFloat lineRightW;
@property (nonatomic, assign) CGFloat titleW;
@property (nonatomic, assign) CGFloat textLeftSpace;
@property (nonatomic, assign) NSInteger textMaxLenght;
@property (nonatomic, copy) NSString *exceedMsg;
@property (nonatomic, assign) BOOL isSecureTextEntry;

@property (nonatomic, copy) ItemTextFiledTextDidChangeBlock textDidChange;
@property (nonatomic, copy) ItemTextFiledTextBeginEditBlock textBeginEidt;
@end
