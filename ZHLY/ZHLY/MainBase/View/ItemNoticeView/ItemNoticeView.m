//
//  ItemNoticeView.m
//  ZHDJ
//
//  Created by LTWL on 2017/9/13.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ItemNoticeView.h"

@interface ItemNoticeView ()
@property (weak, nonatomic) IBOutlet UILabel *noitceLabel;
@property (weak, nonatomic) IBOutlet UIButton *canceBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noitceImgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation ItemNoticeView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.size = CGSizeMake(MainScreenSize.width, 400); //MainScreenSize;
    self.noticeView.layer.cornerRadius = 10;
    self.titleLabel.font = IconFont(15);
    self.titleLabel.text = [NSString stringWithFormat:@"%@  要闻推送", NoticeIconUnicode];
    self.canceBtn.layer.borderWidth = self.confirmBtn.layer.borderWidth = 0.5;
    self.canceBtn.layer.borderColor = self.confirmBtn.layer.borderColor = SetupColor(227, 227, 227).CGColor;
}

- (void)setNoticeTitle:(NSString *)noticeTitle {
    _noticeTitle = [noticeTitle copy];
    self.noitceLabel.text = noticeTitle;
}

- (void)setNoticeImage:(NSString *)noticeImage {
    _noticeImage = [noticeImage copy];
    WeakSelf(weakSelf)
    [self.activityIndicatorView startAnimating];
    [self.noitceImgView sd_setImageWithURL:SetURL(noticeImage) placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.activityIndicatorView stopAnimating];
    }];
}

- (void)show {    
    [AlertPopViewTool alertPopView:self animated:YES];
}

- (void)dismissWithCompletion:(void(^)())completion {
    [AlertPopViewTool alertPopViewDismiss:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) completion();
    });
}

- (IBAction)cancelBtnClick:(id)sender {
    [self dismissWithCompletion:nil];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.confirmBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


@end
