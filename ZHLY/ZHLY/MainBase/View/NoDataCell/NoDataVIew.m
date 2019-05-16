//
//  NoDataVIew.m
//  ZHDJ
//
//  Created by LTWL on 2017/9/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "NoDataVIew.h"

@interface NoDataVIew ()
@property (weak, nonatomic) IBOutlet UIImageView *noDataIocnView;
@property (weak, nonatomic) IBOutlet UILabel *noDataTitleLabel;
@end

@implementation NoDataVIew

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.noDataIocnView.image = SetImage(@"NoData.bundle/NoData");
    self.width = MainScreenSize.width;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.noDataIocnView.image = image;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.noDataTitleLabel.text = text;
}

@end
