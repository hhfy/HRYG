//
//  CustomDatePicker.m
//  YWY2
//
//  Created by LTWL on 2017/4/26.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerDataSource <NSObject>
@required
/**设置行数数量*/
- (NSInteger)pickerView:(UIPickerView *_Nullable)pickerView firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex numberOfRowsInPicker:(NSInteger)component;
@optional
/**设置列数数量*/
- (NSInteger)numberOfComponentsInpickerView:(UIPickerView *_Nullable)pickerView;
/**设置每行的显示富文本字体*/
- (NSAttributedString *_Nonnull)pickerView:(UIPickerView *_Nullable)pickerView attributedTitleForRowTtile:(NSInteger)row forComponent:(NSInteger)component;
/**设置每行返回的view*/
- (UIView *_Nullable)pickerView:(UIPickerView *_Nonnull)pickerView viewForRow:(NSInteger)row firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex forComponent:(NSInteger)component reusingView:(nullable UIView *)view;
@end

@protocol CustomDatePickerDelegate <NSObject>
/**设置每行高度*/
@optional
- (CGFloat)pickerView:(UIPickerView *_Nonnull)pickerView rowHeightForPicker:(NSInteger)component;
- (void)pickerView:(UIPickerView *_Nonnull)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component firstComponentSelectedIndex:(NSInteger)firstComponentSelectedIndex;
- (void)pickerView:(UIPickerView *_Nonnull)pickerView didSelectRow:(NSInteger)row;
@end

@interface CustomDatePicker : UIView
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, weak) id<CustomDatePickerDataSource>  dataSource;
@property (nonatomic, weak) id<CustomDatePickerDelegate>  delegate;

-(void)selectRow:(NSInteger)rows compant:(NSInteger)Compant withAnimate:(BOOL)Animate;

- (id _Nonnull )initWithSureBtnTitle:(NSString *_Nullable)title mainTitle:(NSString *_Nonnull)mainTitle otherButtonTitle:(NSString *_Nonnull)otherButtonTitle;
/**展现视图*/
- (void)show;
/**移除视图*/
-(void)dismisView;

@end
