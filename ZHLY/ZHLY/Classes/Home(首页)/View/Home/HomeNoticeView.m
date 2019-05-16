//
//  HomeNoticeView.m
//  ZHDJ
//
//  Created by LTWL on 2017/8/12.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeNoticeView.h"
#import "Home.h"

@interface HomeNoticeView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HomeNoticeView

- (NSTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
}

- (void)setupContentScorllView {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.texts.count * self.scrollView.height);
    for (int i = 0; i < self.texts.count; i++) {
        UIButton *textBtn = [[UIButton alloc] init];
        textBtn.tag = i;
        textBtn.y = self.scrollView.height * i;
        HomeNotify *notify = self.texts[i];
        [textBtn setTitle:notify.notify_title forState:UIControlStateNormal];
        [textBtn setTitleColor:SetupColor(73, 79, 89) forState:UIControlStateNormal];
        textBtn.titleLabel.font = TextSystemFont(15);
        textBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        textBtn.width = self.scrollView.width;
        textBtn.height = self.scrollView.height;
        [textBtn addTarget:self action:@selector(textBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:textBtn];
    }
}

- (void)textBtnDidClick:(UIButton *)button {
    HomeNotify *notify = self.texts[button.tag];
    if ([self.delegate respondsToSelector:@selector(homeNoticeView:didClickWithId:)]) {
        [self.delegate homeNoticeView:self didClickWithId:notify.app_notify_id];
    }
}

- (void)setTexts:(NSArray *)texts {
    _texts = texts;
    for (UIView *childView in self.scrollView.subviews) {
        if ([childView isKindOfClass:[UIButton class]]) {
            [childView removeFromSuperview];
        }
    }
    [self setupContentScorllView];
    [self startTimer];
}


- (void)startTimer {
    [self timer];
}

- (void)shutDownTimer {
//    [self.timer timeInterval];
    for (UIView *childView in self.scrollView.subviews) {
        if ([childView isKindOfClass:[UIButton class]]) {
            [childView removeFromSuperview];
        }
    }
}

- (void)updateTimer {
    NSInteger currentIndex = ((int)(self.scrollView.contentOffset.y / self.scrollView.height + 0.5)  + 1) % self.texts.count;
    CGFloat y = currentIndex * self.scrollView.height;
    [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
    [LaiMethod animationWithView:self.iconView];
}

- (IBAction)leftBtnAction:(UIButton *)sender {
    [LaiMethod runtimePushVcName:@"HomeNoticeListVC" dic:nil nav:CurrentViewController.navigationController];
}


@end
