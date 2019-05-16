
//
//  HomeMuseumScoreCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShopBaseScoreCell.h"
#import "HomeShopBaseScorePhotosView.h"
#import "Home.h"
#import <FBShimmering.h>
#import <FBShimmeringView.h>

@interface HomeShopBaseScoreCell ()
@property (weak, nonatomic) IBOutlet HomeMuseumStartView *stratView;
@property (weak, nonatomic) IBOutlet HomeShopBaseScorePhotosView *photosView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *startContainView;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosViewH;
@end

@implementation HomeShopBaseScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.avatarView.layer.cornerRadius = self.avatarView.width * 0.5;
    self.avatarView.layer.borderColor = SetupColor(227, 227, 227).CGColor;
    self.avatarView.layer.borderWidth = 0.8;
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.stratView.bounds];
    shimmeringView.shimmering = YES;
    shimmeringView.shimmeringOpacity = 1;
    shimmeringView.shimmeringDirection = FBShimmerDirectionRight;
    shimmeringView.shimmeringBeginFadeDuration = 0.3;
    shimmeringView.shimmeringPauseDuration = 1.5;
    shimmeringView.shimmeringHighlightWidth = 0.9;
    shimmeringView.shimmeringSpeed = 150;
    shimmeringView.layer.cornerRadius = self.startContainView.height * 0.5;
    shimmeringView.clipsToBounds = YES;
    shimmeringView.backgroundColor = [UIColor whiteColor];
    shimmeringView.contentView = self.stratView;
    [self.startContainView addSubview:shimmeringView];
}

- (void)setScoreList:(HomeMuseumScoreList *)scoreList {
    _scoreList = scoreList;
    self.userNameLabel.text = (!scoreList.member_nickname || [scoreList.member_nickname isEqualToString:@""]) ? @"匿名用户" : scoreList.member_nickname;
    self.dateLabel.text = [NSString dateStr:scoreList.create_time formatter:@"YYYY-MM-dd HH:mm:ss" formatWithOtherFormatter:@"YYYY-MM-dd"];
//    self.dateLabel.text = scoreList.create_time;
    self.stratView.stars = scoreList.score;
    self.contentTextLabel.text = (!scoreList.evaluate_text || [scoreList.evaluate_text isEqualToString:@""]) ? @"暂无评价" : scoreList.evaluate_text;
    [self.avatarView sd_setImageWithURL:SetURL(scoreList.member_profile_image) placeholderImage:SetImage(@"头像")];
    
    CGFloat margin = 5;
    CGFloat itemWH = (MainScreenSize.width - margin * 2 - 85) / 3;
    if (scoreList.evaluate_images.count) {
        NSInteger count = scoreList.evaluate_images.count;
        NSInteger col = (count + 3 - 1) / 3;
        self.photosViewH.constant = col * itemWH + (col - 1) * 5;
    } else {
        self.photosViewH.constant = 0;
    }
    self.photosView.offsetY = NavHeight;
    self.photosView.photoWH = itemWH;
    self.photosView.photos = scoreList.evaluate_images;
}

@end

/// 星星View
@implementation HomeMuseumStartView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    // 未点亮星星的颜色（可根据自己喜好设定）
    self.emptyColor = SetupColor(194, 194, 194);
    // 点亮星星的颜色
    self.fullColor = SetupColor(228, 167, 102);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString* stars = @"★★★★★";
    UIFont *font = TextSystemFont(self.height + 1);
    CGSize starSize = [stars sizeWithTextFont:font rectSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
    rect.size=starSize;
    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: self.emptyColor}];
    
    CGRect clip = rect;
    // 裁剪的宽度 = 点亮星星宽度 = （显示的星星数/总共星星数）*总星星的宽度
    clip.size.width = starSize.width * (self.stars / (double)stars.length);
    CGContextClipToRect(context,clip);
    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: self.fullColor}];
}
@end
