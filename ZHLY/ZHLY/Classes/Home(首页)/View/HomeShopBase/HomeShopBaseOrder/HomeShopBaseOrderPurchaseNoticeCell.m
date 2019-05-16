
//
//  HomeShopBaseOrderPurchaseNoticeCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/20.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseOrderPurchaseNoticeCell.h"

@interface HomeShopBaseOrderPurchaseNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@end

@implementation HomeShopBaseOrderPurchaseNoticeCell

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleTextLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = [content copy];
    self.contentTextLabel.text = content;
}

@end
