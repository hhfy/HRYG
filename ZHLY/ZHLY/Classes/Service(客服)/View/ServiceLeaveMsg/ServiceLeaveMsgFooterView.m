
//
//  ServiceLeaveMsgFooterView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceLeaveMsgFooterView.h"

@interface ServiceLeaveMsgFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ServiceLeaveMsgFooterView

- (UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [UIWebView new];
    }
    return _webView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    [self webView];
    self.width = MainScreenSize.width;
    [LaiMethod makeButtonUnderlineWithButton:self.phoneBtn];
}

- (void)setInfo:(NSString *)info {
    _info = [info copy];
    self.infoLabel.text = info;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = [phoneNumber copy];
    [self.phoneBtn setTitle:phoneNumber forState:UIControlStateNormal];
}

- (IBAction)phoneBtnTap:(UIButton *)button {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", button.currentTitle]]]];
}


@end
