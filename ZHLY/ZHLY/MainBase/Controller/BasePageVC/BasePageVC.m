//
//  BasePageVC.m
//  ZHRQ_CBZ
//
//  Created by LTWL on 2017/7/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "BasePageVC.h"

@interface BasePageVC () <UIScrollViewDelegate>
@property (nonatomic, weak) UIView *titlesView;
@property (nonatomic, weak) UIView *titleBottomView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<TitleButton *> *titleButtons;
@property (nonatomic, weak) UIButton *selectedTitleButton;
@property (nonatomic, weak) TitleButton *previousClickedTitleButton;
@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, assign) NSInteger currentTitleBtnTag;
@property (nonatomic, strong) TitleButton *lastTitleButton;
@end

@implementation BasePageVC


#pragma mark - 懒加载
- (NSMutableArray<TitleButton *> *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addChildVC];
    [self setupTitlesView];
    [self setupScrollView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[UIViewController class]]) {
            [vc removeFromParentViewController];
        }
    }
    self.lastTitleButton = nil;
    [self.titleButtons removeAllObjects];
    [self.view removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 设置主题view
- (void)setupTitlesView {
    // 当前子控制器为0的时候不进行下一步执行
    if (self.childViewControllers.count == 0) return;
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.height = 44;
//    titlesView.backgroundColor = [UIColor redColor];
    
    switch (self.titleViewType) {
        case TitleViewTypeNormal:
        {
            titlesView.width = self.view.width;
            titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
            [self.view addSubview:titlesView];
        }
            break;
        case TitleViewTypeNavTitleView:
        {
            titlesView.width = self.view.width * 0.7;
            self.navigationItem.titleView = titlesView;
        }
            break;
        default:
            break;
    }
    _titlesView = titlesView;
    
    // 大于整页宽度的标题底部titleScrollView
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.x = 10;
    titleScrollView.width = titlesView.width - titleScrollView.x;
    titleScrollView.height = titlesView.height;
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.bouncesZoom = NO;
    _titleScrollView = titleScrollView;
    
    if (self.titleViewMode == TitleViewModeScrollView) [titlesView addSubview:titleScrollView];
    
    // 标签栏内部的标签按钮
    NSUInteger count = self.childViewControllers.count;
    CGFloat titleButtonH = titlesView.height;
    CGFloat titleButtonW = titlesView.width / count;
    for (int i = 0; i < count; i++) {
        // 创建
        TitleButton *titleButton = [TitleButton buttonWithType:UIButtonTypeCustom];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [((self.titleViewMode == TitleViewModeScrollView) ? titleScrollView : titlesView) addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        titleButton.backgroundColor = [UIColor whiteColor];
        // 文字
        [titleButton setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        titleButton.tag = i;
        if (self.titleViewType == TitleViewTypeNormal) {
            titleButton.selectFont = TextSystemFont(16);
            titleButton.nomarlFont = TextSystemFont(15);
        }
        // frame
        titleButton.frame = CGRectMake(i*titleButtonW, 0, titleButtonW, titleButtonH);
        
//        CGRect titleTextF = [titleButton.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: titleButton.titleLabel.font} context:nil];
//        titleButton.frame = CGRectMake(self.lastTitleButton.maxX, 0, titleTextF.size.width + 30, titlesView.height);
        if (self.titleViewType == TitleViewTypeNormal) {
             [titleButton setTitleColor:SetupColor(51, 51, 51) forState:UIControlStateNormal];
            [titleButton setTitleColor:(self.titleColor) ? self.titleColor : MainThemeColor forState:UIControlStateSelected];
        }
        self.lastTitleButton = titleButton;
        if (self.titleViewMode == TitleViewModeScrollView && i == count - 1) titleScrollView.contentSize = CGSizeMake(titleButton.maxX, titlesView.height);
    }
    
    // 标签栏底部的指示器控件
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [self.titleButtons.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.height = 2;
    titleBottomView.y = titlesView.height - titleBottomView.height - 2;
    if (self.titleViewType == TitleViewTypeNormal && self.titleViewMode == TitleViewModeView) [titlesView addSubview:titleBottomView];
    self.titleBottomView = titleBottomView;
    
    // 默认点击最前面的按钮
    TitleButton *firstTitleButton = self.titleButtons[self.selectedIndex];
    [firstTitleButton.titleLabel sizeToFit];
    titleBottomView.width = firstTitleButton.titleLabel.width;
    titleBottomView.centerX = firstTitleButton.centerX;
    [self titleClick:firstTitleButton];
}

#pragma mark - 设置ScrollView
- (void)setupScrollView {
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = (self.titleViewType == TitleViewTypeNormal) ? CGRectMake(0, self.titlesView.height, self.view.width, self.view.height - self.titlesView.height) : self.view.bounds;
    scrollView.backgroundColor = SetupColor(235, 235, 235);
//    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    // 默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - 监听
- (void)titleClick:(TitleButton *)titleButton {

    // 重复点击了标题按钮 (顺序不要反了)
    if (self.previousClickedTitleButton == titleButton) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:TitleButtonDidRepeatClickNotification object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    self.previousClickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    self.previousClickedTitleButton = titleButton;
    
    
    // 底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.width = titleButton.titleLabel.width * 1.1;
        self.titleBottomView.centerX = titleButton.centerX;
    }];
    
    // 让scrollView滚动到对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.view.width * [self.titleButtons indexOfObject:titleButton];
    [self.scrollView setContentOffset:offset animated:YES];
    
    // 让标题scrollView滚动到对应的位置
    CGPoint titleBtnOffset = self.titleScrollView.contentOffset;
    CGFloat leftW = self.titleScrollView.width * 0.5;
    CGFloat rightW = self.titleScrollView.contentSize.width - leftW * 2;
    CGFloat lastBtnMaxX = [self.titleButtons lastObject].x + [self.titleButtons lastObject].width;
    
    if (titleButton.x <= leftW || lastBtnMaxX <= self.titleScrollView.width) {
        titleBtnOffset.x = 0;
    } else {
        if (self.currentTitleBtnTag < titleButton.tag) {
            if (titleButton.x >= rightW) {
                titleBtnOffset.x = rightW;
            } else {
                titleBtnOffset.x += titleButton.width;
            }
        } else if (self.currentTitleBtnTag > titleButton.tag) {
            if (titleButton.x <= leftW * 1.9) {
                titleBtnOffset.x = 0;
            } else {
                titleBtnOffset.x -= titleButton.width;
            }
        }
    }
    
    [self.titleScrollView setContentOffset:titleBtnOffset animated:YES];
    self.currentTitleBtnTag = titleButton.tag;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.childViewControllers.count == 0) return;
    // 取出对应的子控制器
    int index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    // 如果控制器的view已经被创建过，就直接返回
    if (willShowChildVc.isViewLoaded) return;
    // 添加子控制器的view到scrollView身上
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}

/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    int index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titleButtons[index]];
}

- (void)addChildVC {}
@end

/* 自定义按钮 */
@implementation TitleButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = TextBoldFont(16);
        [self setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateNormal];
        [self setTitleColor:SetupColor(255, 255, 255) forState:UIControlStateSelected];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
//    if (selected) [LaiMethod animationWithView:self];
    self.titleLabel.font = (selected) ? ((self.selectFont) ? self.selectFont : TextBoldFont(17)) : ((self.nomarlFont) ? self.nomarlFont : TextBoldFont(16));
}

- (void)setNomarlFont:(UIFont *)nomarlFont {
    _nomarlFont = nomarlFont;
    self.titleLabel.font = nomarlFont;
}

- (void)setSelectFont:(UIFont *)selectFont {
    _selectFont = selectFont;
    self.titleLabel.font = selectFont;
}

- (void)setHighlighted:(BOOL)highlighted {}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.titleLabel.y += 10;
}
@end



