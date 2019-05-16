//
//  PubTopPageOfBtnView.m
//  YWY2
//
//  Created by Moussirou Serge Alain on 17/2/13.
//  Copyright © 2017年 XMB. All rights reserved.
//

#import "PubTopPageOfBtnView.h"

@implementation PubTopPageOfBtnView

- (instancetype)initWithFrame:(CGRect)frame withCount:(NSInteger)btnCount withShowType:(NSInteger)type {
    self = [super initWithFrame:frame];
    if(self) {
        _indexType = type;
        _statusType = @"待支付";
        _count = btnCount;
        [self initStance:btnCount WithFrame:(CGRect)frame];
    }
    return self;
}


-(void)setBtn:(UIButton *)btn withTitleFont:(UIFont *)font withTag:(NSInteger)tag withTitle:(NSString *)title {
    UIButton *button = btn;
    button.titleLabel.font = font;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:SetupColor(51, 51, 51) forState:UIControlStateNormal];
    [button setTitleColor:MainThemeColor forState:UIControlStateSelected];
}

- (void)initStance:(NSInteger)btnCount WithFrame:(CGRect)frame {
    if(!_topScrollView) {
         _topScrollView = [[UIScrollView alloc] initWithFrame:frame];
         _topScrollView.backgroundColor = [UIColor whiteColor];
         [self addSubview:_topScrollView];
         if(!_firstBtn && btnCount>0) {
             _firstBtn = [UIButton createButtonwithFrame:CGRectMake(0, 0, MainScreenSize.width/btnCount, frame.size.height)
                                         backgroundColor:[UIColor whiteColor]
                                                   image:nil];
             [self setBtn:_firstBtn withTitleFont:TextSystemFont(15) withTag:0 withTitle:@"待支付"];
             [_firstBtn addTarget:self action:@selector(topScrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
//             _firstBtn.selected = YES;
             _firstBtn.tag = 0;
             [_topScrollView addSubview:_firstBtn];
         }
         if(!_secondBtn && btnCount>1) {
             _secondBtn = [UIButton createButtonwithFrame:CGRectMake(MainScreenSize.width/btnCount, 0, MainScreenSize.width/btnCount, frame.size.height)
                                          backgroundColor:[UIColor whiteColor] image:nil];
             [self setBtn:_secondBtn withTitleFont:TextSystemFont(15) withTag:1 withTitle:@"待使用"];
             [_secondBtn addTarget:self action:@selector(topScrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
             _secondBtn.tag = 1;
             [_topScrollView addSubview:_secondBtn];
         }
         if(!_thirdBtn && btnCount>2) {
             _thirdBtn = [UIButton createButtonwithFrame:CGRectMake(MainScreenSize.width/btnCount*2, 0, MainScreenSize.width/btnCount, frame.size.height)
                                         backgroundColor:[UIColor whiteColor] image:nil];
             [self setBtn:_thirdBtn withTitleFont:TextSystemFont(15) withTag:2 withTitle:@"已完成"];
             [_thirdBtn addTarget:self action:@selector(topScrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
             _thirdBtn.tag = 2;
             [_topScrollView addSubview:_thirdBtn];
         }
         if(!_fourthBtn && btnCount>3) {
             _fourthBtn = [UIButton createButtonwithFrame:CGRectMake(MainScreenSize.width/btnCount*3, 0, MainScreenSize.width/btnCount, frame.size.height)
                                          backgroundColor:[UIColor whiteColor] image:nil];
             [self setBtn:_fourthBtn withTitleFont:TextSystemFont(15) withTag:3 withTitle:@"退款单"];
             [_fourthBtn addTarget:self action:@selector(topScrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
             _fourthBtn.tag = 3;
             [_topScrollView addSubview:_fourthBtn];
         }
        _selectedBtn = [self returnSekectedBtn:_indexType];
        
         CGFloat beginX;
         CGFloat lineWidth;
         if (btnCount == 3) {
            beginX = _firstBtn.size.width/3;
            lineWidth = _firstBtn.size.width/3;
         }
         else {
            beginX = _firstBtn.size.width/4;
            lineWidth = _firstBtn.size.width/2;
         }
         if(!_bottomLine){
            _bottomLine = [UIView createViewWithFrame: CGRectMake(beginX, _firstBtn.size.height - 2, lineWidth, 2)
                                      backgroundColor:MainThemeColor
                                        conrnerRadius:0
                                          borderWidth:0
                                          borderColor:MainThemeColor];
            
            [_topScrollView addSubview:_bottomLine];
         }
        
         switch (self.indexType) {
             case 0:
                 [self topScrollViewClick:_firstBtn];
                 break;
             case 1:
                 [self topScrollViewClick:_secondBtn];
                 break;
             case 2:
                 [self topScrollViewClick:_thirdBtn];
                 break;
             case 3:
                 [self topScrollViewClick:_fourthBtn];
                 break;
             default:
                 break;
         }
    }
}
-(UIButton *)returnSekectedBtn:(NSInteger)tag {
    UIButton *btn;
    switch (tag) {
        case 0:
            btn = self.firstBtn;
            break;
        case 1:
            btn = self.secondBtn;
            break;
        case 2:
            btn = self.thirdBtn;
            break;
        case 3:
            btn = self.fourthBtn;
            break;
        default:
            break;
    }
    btn.selected = YES;
    return btn;
}
- (void)topScrollViewClick:(UIButton *)sender {
    _selectedBtn.selected = NO;
    sender.selected = YES;
    _selectedBtn = sender;
    _statusType = _selectedBtn.titleLabel.text;
    CGFloat beginX;
    CGFloat lineWidth;
    if (_count == 3) {
        beginX = _firstBtn.size.width/3;
        lineWidth = _firstBtn.size.width/3;
    }
    else {
        beginX = _firstBtn.size.width/4;
        lineWidth = _firstBtn.size.width/2;
    }

    if (_delegate) {
        [_delegate pubTopPageDelegateOfBtnAction:sender.tag];
    }
    _bottomLine.frame = CGRectMake(beginX+MainScreenSize.width/_count*sender.tag, _firstBtn.size.height - 2, lineWidth, 2);
}

-(void)fillBtnTitle:(NSString *)name {
}


@end
