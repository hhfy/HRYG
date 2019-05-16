//
//  MyImageViewer.m
//  ZTX
//
//  Created by X on 15/10/29.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "MyImageViewer.h"

@interface MyImageViewer () <UIScrollViewDelegate,MyImageViewDelegate>

@end

@implementation MyImageViewer

-(id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark -
-(void)showImagesWithImageURLs:(NSArray *)imageURLs {
    _totalCount = [imageURLs count];
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        _scrollView.pagingEnabled = YES;
        _scrollView.alpha = 0;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView setContentSize:CGSizeMake(MainScreenSize.width*[imageURLs count], MainScreenSize.height)];
        [superView addSubview:_scrollView];
    }
    else {
        for (UIImageView *imageView in _scrollView.subviews) {
            [imageView removeFromSuperview];
        }
    }

    if ([imageURLs count]) {
        for (NSInteger i = 0; i<[imageURLs count]; i++) {
            MyImageView *imageView = [[MyImageView alloc]initWithFrame:CGRectMake(MainScreenSize.width*i,0,MainScreenSize.width,MainScreenSize.height) withImageURL:imageURLs[i] atIndex:i];
            imageView.tapDelegate = self;
            [_scrollView addSubview:imageView];
        }
    }
    if (!_tabBar) {
        _tabBar = [[MyImageViewTabBar alloc] initWithFrame:CGRectMake(0, _scrollView.bounds.size.height-40, MainScreenSize.width, 40) withTotalCount:_totalCount];
        [_tabBar.saveButton addTarget:self action:@selector(onSaveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:_tabBar];
        _tabBar.alpha = 0;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         _tabBar.alpha = 1;
                     }];
}

-(void)onSaveButtonTapped {
    NSInteger page =(NSInteger)_scrollView.contentOffset.x/MainScreenSize.width;
//    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
//    [SVProgressHUD showWithStatus:@"正在保存..."];
    for (MyImageView *imageView in _scrollView.subviews) {
        if (imageView.index == page) {
            if (imageView.image) {
                UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil,nil);
                [SVProgressHUD showSuccess:@"图片保存成功!"];
            }
        }
    }
}

#pragma mark -
-(void)showImagesWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger )index {
    [self showImagesWithImageURLs:imageURLs];
    if (index <= _totalCount-1) {
        [_scrollView scrollRectToVisible:CGRectMake(MainScreenSize.width*index, 0, MainScreenSize.width, MainScreenSize.height) animated:NO];
        _tabBar.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)index+1,(long)_totalCount];
    }
}
#pragma mark -
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page =(NSInteger)scrollView.contentOffset.x/MainScreenSize.width;
    _tabBar.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)page+1,(long)_totalCount];
}
#pragma mark -
-(void)myImageViewHandleSingleTap {
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.alpha = 0;
                         _tabBar.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_scrollView removeFromSuperview];
                         [_tabBar removeFromSuperview];
                     }];
}

@end

/**
 MyImageView
 
 :param: idinitWithFrame 
 */

@implementation MyImageView

-(id)initWithFrame:(CGRect)frame withImageURL:(NSString *)imageURL atIndex:(NSInteger)index {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 4.0;
        _index = index;
        //gesture
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.delaysTouchesBegan = YES;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        //
        _act = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((MainScreenSize.width-40)/2, (MainScreenSize.height-40)/2, 40, 40)];
        _act.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [_act startAnimating];
        [self addSubview:_act];
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 _image = image;
                                 [_act removeFromSuperview];
                             }];
        [self addSubview:_imageView];

    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGFloat Ws = scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right;
    CGFloat Hs = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom;
    CGFloat W = _imageView.frame.size.width;
    CGFloat H = _imageView.frame.size.height;
    
    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.frame = rct;
}

-(void)handleTap {
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(myImageViewHandleSingleTap)]) {
        [_tapDelegate myImageViewHandleSingleTap];
    }
}
-(void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}


@end



/**
 MyImageViewTabBar
 
 :param: idinitWithFrame
 */

@implementation MyImageViewTabBar

-(id)initWithFrame:(CGRect)frame withTotalCount:(NSInteger)totalCount {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _saveButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, self.height, self.height)];
        _saveButton.backgroundColor = [UIColor clearColor];
        [_saveButton setImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
        [self addSubview:_saveButton];
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenSize.height+10, 0, (MainScreenSize.width-(MainScreenSize.height+10)*2), self.height)];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = TextBoldFont(14);
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.text = [NSString stringWithFormat:@"1/%ld",(long)totalCount];
        [self addSubview:_countLabel];
    }
    return self;
}

@end
