
//
//  TravelsSendMomentContentCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/2.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsSendMomentContentCell.h"

@interface TravelsSendMomentContentCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet TextView *textView;
@end

@implementation TravelsSendMomentContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
//    self.textView.placeholder = @"写点什么吧，分享游玩中的精彩片段";
    self.textView.placeholder = @"说点什么呢";
    self.textView.placeholderColor = SetupColor(170, 170, 170);
}

-(void)setContent:(NSString *)content {
    _content = content;
//    if(content.length>0){
        self.textView.text = content;
//    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (self.inputText) self.inputText(textView.text);
}

@end
