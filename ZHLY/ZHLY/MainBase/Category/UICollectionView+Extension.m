
//
//  UICollectionView+Extension.m
//  ZHDJ
//
//  Created by LTWL on 2017/9/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "UICollectionView+Extension.h"

@implementation UICollectionView (Extension)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData)
                               bySwizzledSelector:@selector(lai_reloadData)];
    });
}

- (void)lai_reloadData {
    if (self.isHidden == YES) return;
    [self checkEmpty];
    [self lai_reloadData];
}

- (void)checkEmpty {
    BOOL isEmpty = YES;//flag标示
    
    id <UICollectionViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sections = [dataSource numberOfSectionsInCollectionView:self] - 1;//获取当前TableView组数
    }
    
    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource collectionView:self numberOfItemsInSection:i];//获取当前TableView各组行数
        if (rows) {
            isEmpty = NO;//若行数存在，不为空
        }
    }
    if (isEmpty) {//若为空，加载占位图
        self.scrollEnabled = NO;
        //默认占位图
        [self makeDefaultPlaceholderView];
        self.backgroundView = self.superView;
    } else {//不为空，移除占位图
        self.backgroundView = nil;
        self.scrollEnabled = YES;
    }
}

- (void)makeDefaultPlaceholderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:view.bounds];
    contentView.backgroundColor = [UIColor clearColor];
    [view addSubview:contentView];
    
    if (self.firstReload) {
        if (!self.placeholderView) {
            NoDataVIew *noDataView = [NoDataVIew viewFromXib];
            noDataView.size = self.size;
            noDataView.y = -NavHeight;
            [contentView addSubview:noDataView];
        } else {
            [contentView addSubview:self.placeholderView];
        }
    } else {
        if (!self.loaddingView) {
            [contentView.layer addSublayer:[LaiCAAnimatonLibTool generateActivityIndicatorLayerWithAnimationType:7 size:CGSizeMake(60, 30) tintColor:MainThemeColor superView:contentView]];
        } else {
            [contentView addSubview:self.loaddingView];
        }
    }
    self.firstReload = YES;
    self.superView = view;
}

- (UIView *)placeholderView {
    return objc_getAssociatedObject(self, @selector(placeholderView));
}

- (void)setPlaceholderView:(UIView *)placeholderView {
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)loaddingView {
    return objc_getAssociatedObject(self, @selector(loaddingView));
}

- (void)setLoaddingView:(UIView *)loaddingView {
    objc_setAssociatedObject(self, @selector(loaddingView), loaddingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)superView {
    return objc_getAssociatedObject(self, @selector(superView));
}

- (void)setSuperView:(UIView *)superView {
    objc_setAssociatedObject(self, @selector(superView), superView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)firstReload {
    return [objc_getAssociatedObject(self, @selector(firstReload)) boolValue];
}

- (void)setFirstReload:(BOOL)firstReload {
    objc_setAssociatedObject(self, @selector(firstReload), @(firstReload), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isHidden {
    return [objc_getAssociatedObject(self, @selector(isHidden)) boolValue];
}

- (void)setIsHidden:(BOOL)isHidden {
    objc_setAssociatedObject(self, @selector(isHidden), @(isHidden), OBJC_ASSOCIATION_ASSIGN);
}
@end
