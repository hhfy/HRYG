
//
//  DropDownMenu.m
//  41-新浪微博
//
//  Created by LTWL on 2016/12/24.
//  Copyright © 2016年 赖同学. All rights reserved.
//

#import "DropDownMenu.h"

@interface DropDownMenu()
@property (nonatomic, strong) UIView *contianerView;
@property (nonatomic, strong) UIView *coverView;
@end

@implementation DropDownMenu

- (UIView *)contianerView
{
    if (_contianerView == nil)
    {
        // 添加一个灰色图片
        // 创建下拉菜单
        _contianerView = [UIView new];
        _contianerView.userInteractionEnabled = YES;
        [self addSubview:_contianerView];
    }
    return _contianerView;
}

- (UIView *)coverView
{
    if (_coverView == nil)
    {
        _coverView = [UIView new];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        [self insertSubview:_coverView atIndex:0];
    }
    return _coverView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (void)showFrom:(UIView *)from
{
    // 1.获得最上面的窗口
    UIWindow *window = CurrentWindow;
    
    // 2.添加自己到窗口
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    // 4.添加蒙版
    self.coverView.y = ((iPhoneX) ? NavHeightIphoneX : NavHeight) + from.height + 10;
    self.coverView.x = 0;
    self.coverView.width = self.contianerView.width;
    self.coverView.height = self.height - self.coverView.y;
    
    // 转换坐标系
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    self.contianerView.centerX = CGRectGetMidX(newFrame);
    self.contianerView.y = CGRectGetMaxY(newFrame);
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    // 设置菜单的位置
    content.x = 10;
    content.y = 0.2;
    
    // 限制内容的宽度
    //content.width = self.contianerView.width - 2 * content.x;
    
    // 设置菜单的尺寸
    self.contianerView.height = CGRectGetMaxY(content.frame) + 10;
    self.contianerView.width = CGRectGetMaxX(content.frame) + 10;
    
    // 添加内容到灰色内容
    [self.contianerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    self.content = contentController.view;
}

- (void)dismiss
{
    self.contentController = nil;
    self.content = nil;
    self.contianerView = nil;
    self.coverView = nil;
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)])
    {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

+ (instancetype)menu
{
    return [[self alloc] init];
}

@end
