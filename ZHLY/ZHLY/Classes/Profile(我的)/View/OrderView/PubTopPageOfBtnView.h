//
//  PubTopPageOfBtnView.h
//  YWY2
//
//  Created by Moussirou Serge Alain on 17/2/13.
//  Copyright © 2017年 XMB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PubTopPageOfBtnViewDelegate
- (void)pubTopPageDelegateOfBtnAction:(NSInteger)tag;
@end

@interface PubTopPageOfBtnView : UIView

- (id)initWithFrame:(CGRect)frame withCount:(NSInteger)btnCount withShowType:(NSInteger)type;

@property(nonatomic,retain)UIScrollView *topScrollView;
@property(nonatomic,strong)UIButton *firstBtn;
@property(nonatomic,strong)UIButton *secondBtn;
@property(nonatomic,strong)UIButton *thirdBtn;
@property(nonatomic,strong)UIButton *fourthBtn;

@property(nonatomic,strong)UIView *bottomLine;
@property(nonatomic,retain)UIButton *selectedBtn;

@property(nonatomic,assign)CGFloat lineHeight;
@property(nonatomic,assign)NSInteger count;

/*选中的按钮位置及状态：
－ 0.未付款 1.未使用 2.已完成 3.退款单
 */

@property(nonatomic,strong)NSString *statusType;
@property (nonatomic, assign) NSInteger indexType;
@property (nonatomic, weak) id<PubTopPageOfBtnViewDelegate>delegate;
- (void)topScrollViewClick:(UIButton *)sender;

-(void)fillBtnTitle:(NSString *)name;

@end
