//
//  ServiceMyMsgHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceMyMsgHeaderView.h"

@interface ServiceMyMsgHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation ServiceMyMsgHeaderView

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.contentLabel.text = text;
}

@end
