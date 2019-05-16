//
//  UITableView+Extension.m
//  ZHDJ
//
//  Created by LTWL on 2017/9/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData) bySwizzledSelector:@selector(lai_reloadData)];
    });
}

- (void)lai_reloadData {
    if (!self.isHideNoDataView) [self checkEmpty];
    [self lai_reloadData];
}

- (void)checkEmpty {
    BOOL isEmpty = YES;//flag标示
    id <UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1;//获取当前TableView组数
    }
    
    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i];//获取当前TableView各组行数
        if (rows) isEmpty = NO;//若行数存在，不为空
    }
    if (isEmpty) {//若为空，加载占位图
        self.scrollEnabled = NO;
        self.tableHeaderView.hidden = YES;
        //默认占位图
        [self makeDefaultPlaceholderView];
        self.backgroundView = self.superView;
        
        
    } else {//不为空，移除占位图
        self.backgroundView = nil;
        self.scrollEnabled = YES;
        self.tableHeaderView.hidden = NO;
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
            noDataView.y = 0;
            if (self.placeholderText) noDataView.text = self.placeholderText;
            if (self.placeholderImage) noDataView.image = self.placeholderImage;
            [contentView addSubview:noDataView];
        } else {
            [contentView addSubview:self.placeholderView];
        }
    } else {
        if (!self.loaddingView) {
            [contentView.layer addSublayer:[LaiCAAnimatonLibTool generateActivityIndicatorLayerWithAnimationType:17 size:CGSizeMake(60, 30) tintColor:MainThemeColor superView:contentView]];
        } else {
            [contentView addSubview:self.loaddingView];
        }
        self.tableHeaderView.hidden = YES;
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

- (BOOL)isHideNoDataView {
    return [objc_getAssociatedObject(self, @selector(isHideNoDataView)) boolValue];
}

- (void)setIsHideNoDataView:(BOOL)isHideNoDataView {
    objc_setAssociatedObject(self, @selector(isHideNoDataView), @(isHideNoDataView), OBJC_ASSOCIATION_ASSIGN);
}

- (UIImage *)placeholderImage {
    return objc_getAssociatedObject(self, @selector(placeholderImage));
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    objc_setAssociatedObject(self, @selector(placeholderImage), placeholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)placeholderText {
    return objc_getAssociatedObject(self, @selector(placeholderText));
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    objc_setAssociatedObject(self, @selector(placeholderText), placeholderText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
