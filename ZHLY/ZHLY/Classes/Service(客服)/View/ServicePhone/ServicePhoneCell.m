
//
//  ServicePhoneCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServicePhoneCell.h"
#import "Service.h"

@interface ServicePhoneCell ()
@property (weak, nonatomic) IBOutlet UIButton *moblieBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ServicePhoneCell

- (UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    [self webView];
}

- (void)setPhoneDetial:(ServicePhoneDetial *)phoneDetial {
    _phoneDetial = phoneDetial;
    self.nameLabel.text = [NSString stringWithFormat:@"%@：", phoneDetial.title];
    [self.moblieBtn setTitle:phoneDetial.number forState:UIControlStateNormal];
    [LaiMethod makeButtonUnderlineWithButton:self.moblieBtn];
}

- (IBAction)callPhoneBtnTap:(UIButton *)button {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", button.currentTitle]]]];
}


@end
