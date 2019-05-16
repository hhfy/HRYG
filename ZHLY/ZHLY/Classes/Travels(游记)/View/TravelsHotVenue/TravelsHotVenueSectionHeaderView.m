
//
//  TravelsHotVenueSectionHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/30.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsHotVenueSectionHeaderView.h"

@interface TravelsHotVenueSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@end

@implementation TravelsHotVenueSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleTextLabel.text = title;
}

@end
