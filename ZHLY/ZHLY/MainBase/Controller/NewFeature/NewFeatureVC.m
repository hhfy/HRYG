//
//  NewFeatureVC.m
//
//  Created by LTWL on 2017/8/21.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "NewFeatureVC.h"
//#import "LoginVC.h"

#define NewFeatureCount 3

@interface NewFeatureVC ()
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *shareBtn;
@end

@implementation NewFeatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
}

- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    CGFloat scrollW = scrollView.width;
    CGSize scrollSize = scrollView.size;

//    for (int i = 0; i < NewFeatureCount; i++) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.userInteractionEnabled = YES;
//        imageView.size = scrollSize;
//        imageView.x = i * scrollW;
//        imageView.y = 0;
//        
//        NSString *photoName = (iPhone5) ? [NSString stringWithFormat:@"%@5-%d", NewFeatureImgPrefix, i + 1] : [NSString stringWithFormat:@"%@6-%d", NewFeatureImgPrefix, i + 1];
//        imageView.image = SetImage(photoName);
//        [scrollView addSubview:imageView];
//        if (i == NewFeatureCount - 1) [self setLastImageView:imageView];
//    }
    
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator= NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(NewFeatureCount * scrollW, 0);
    _scrollView = scrollView;
}

- (void)setLastImageView:(UIImageView *)imageView {
    UIButton *startBtn = [[UIButton alloc] init];
    startBtn.backgroundColor = [UIColor whiteColor];
    startBtn.layer.cornerRadius = 6;
    startBtn.width = 120;
    startBtn.height = 30;
    [startBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    startBtn.titleLabel.font = TextBoldFont(16.0f);
    [startBtn setTitleColor:SetupColor(51, 51, 51) forState:UIControlStateNormal];
    startBtn.centerX = MainScreenSize.width * 0.5;
    startBtn.centerY = imageView.height * 0.7;
    [imageView addSubview:startBtn];
    
    // 监听按钮的点击
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startBtnClick {
//    CurrentWindow.rootViewController = [[NavigationController alloc] initWithRootViewController:[[LoginVC alloc] init]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
