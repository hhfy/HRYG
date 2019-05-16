//
//  ServiceLeaveMsgTypeCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceLeaveMsgTypeCell.h"


@interface ServiceLeaveMsgTypeCell ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@end

@implementation ServiceLeaveMsgTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.arrowBtn.titleLabel.font = IconFont(15);
    [self.arrowBtn setTitle:DownArrowIconUnicode2 forState:UIControlStateNormal];
    [self.arrowBtn setTitle:UpArrowIconUnicode2 forState:UIControlStateSelected];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customPickerDismiss) name:CustomPickerDismissNotification object:nil];
}

- (IBAction)arrowBtnTap:(UIButton *)button {
    button.selected = !button.isSelected;
    [self.superview endEditing:YES];
    if (self.didTap) self.didTap();
}

- (void)setTypeText:(NSString *)typeText {
    _typeText = [typeText copy];
    self.statusLabel.text = typeText;
    self.arrowBtn.selected = NO;
}

- (void)customPickerDismiss {
    self.arrowBtn.selected = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
