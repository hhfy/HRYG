//
//  TravelsShopBaseHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/12/5.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsShopBaseHeaderView.h"
#import "Home.h"
#import <FBShimmering.h>
#import <FBShimmeringView.h>
#import "HomeShopBaseHeaderView.h"

@interface TravelsShopBaseHeaderView () <SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *leftArrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightArrowLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *startBgView;
@property (weak, nonatomic) IBOutlet HomeShopBaseHeaderStartView *stratView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *locIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *locLabel;
@property (nonatomic, strong) SDCycleScrollView *sDCycleScrollView;
@property (weak, nonatomic) IBOutlet UILabel *pageCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftViewTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftViewDetialLabel;

@end

@implementation TravelsShopBaseHeaderView

- (SDCycleScrollView *)sDCycleScrollView
{
    if (_sDCycleScrollView == nil)
    {
        _sDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenSize.width, self.topView.height) delegate:self placeholderImage:SetImage(BannerPlaceHolder)];
        _sDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sDCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _sDCycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _sDCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _sDCycleScrollView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.rightArrowLabel.font = self.leftArrowLabel.font = IconFont(15);
    self.rightArrowLabel.text = self.leftArrowLabel.text = RightArrowIconUnicode;
    self.locIconLabel.font = IconFont(20);
    self.locIconLabel.text = LocationIconUnicode2;
    [self.topView insertSubview:self.sDCycleScrollView atIndex:0];
    self.stratView.stars = 3.5;
    
    [self.leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewTap:)]];
    [self.rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewTap:)]];
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.stratView.bounds];
    shimmeringView.shimmering = YES;
    shimmeringView.shimmeringOpacity = 1;
    shimmeringView.shimmeringDirection = FBShimmerDirectionRight;
    shimmeringView.shimmeringBeginFadeDuration = 0.3;
    shimmeringView.shimmeringPauseDuration = 2;
    shimmeringView.shimmeringHighlightWidth = 0.9;
    shimmeringView.shimmeringSpeed = 150;
    shimmeringView.layer.cornerRadius = self.stratView.height * 0.5;
    shimmeringView.clipsToBounds = YES;
    shimmeringView.backgroundColor = [UIColor whiteColor];
    shimmeringView.contentView = self.stratView;
    [self.startBgView addSubview:shimmeringView];
}

//导航
- (IBAction)naviBtnAction:(id)sender {
    [SVProgressHUD showError:@"未获取到经纬度信息"];
}

- (IBAction)backBtnTap {
    [CurrentViewController.navigationController popViewControllerAnimated:YES];
}
//景点介绍
- (void)leftViewTap:(UITapGestureRecognizer *)tap {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"apiUrl"] = self.info.detialApi;
//    params[@"Id"] = self.info.shopId;
    params[@"titleText"] = @"景点详情";
    [LaiMethod runtimePushVcName:@"HomeDetialWebVC" dic:params nav:CurrentViewController.navigationController];
}

//购物车
- (IBAction)shoppingCarBtnTap:(UIButton *)button {
    [LaiMethod runtimePushVcName:@"HomeShoppingCarVC" dic:nil nav:CurrentViewController.navigationController];
}

//用户评价
- (void)rightViewTap:(UITapGestureRecognizer *)tap {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"shopId"] = self.info.shopId;
    [LaiMethod runtimePushVcName:@"HomeShopBaseScoreVC" dic:params nav:CurrentViewController.navigationController];
}

- (void)setInfo:(HomeShopBaseInfo *)info {
    _info = info;
    if(info.banner){
        self.sDCycleScrollView.imageURLStringsGroup = @[info.banner];
    }
    self.nameLabel.text = info.shopName;
    self.pageCountLabel.text = [NSString stringWithFormat:@"%zd张", info.bannerCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%zd", info.commentCount];
    self.locLabel.text = info.address.length>0 ? info.address : @"未获取到位置信息";
    self.leftViewTitleLabel.text = info.leftViewTitle;
    self.leftViewDetialLabel.text = info.leftViewDetialText;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f分", info.startCount];
    self.stratView.stars = info.startCount;
    self.commentCountLabel.text = [NSString stringWithFormat:@"%zd条评价", info.commentCount];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"titleText"] = [NSString stringWithFormat:@"%zd张图片", self.info.bannerCount];
    params[@"shopId"] = self.info.shopId;
    [LaiMethod runtimePushVcName:@"TravelsAlbumVC" dic:params nav:CurrentViewController.navigationController];
}
@end

/// 导航按钮
//@implementation HomeShopBaseHeaderNavBtn
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.imageView.size = self.currentImage.size;
//    self.imageView.y = 10;
//    self.imageView.centerX = self.width * 0.5;
//    self.titleLabel.x = 0;
//    self.titleLabel.y = self.imageView.maxY + 2;
//    self.titleLabel.width = self.width;
//    self.titleLabel.height = 20;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//}
//
//@end

/// 星星View
//@implementation HomeShopBaseHeaderStartView
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [self setupUI];
//}
//
//- (void)setupUI {
//    // 未点亮星星的颜色（可根据自己喜好设定）
//    self.emptyColor = SetupColor(194, 194, 194);
//    // 点亮星星的颜色
//    self.fullColor = SetupColor(228, 167, 102);
//}
//
//- (void)setStars:(CGFloat)stars {
//    _stars = stars;
//    [self setNeedsDisplay];
//}
//
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    NSString *stars = @"★★★★★";
//    
//    UIFont *font = TextSystemFont(self.height + 1);
//    CGSize starSize = [stars sizeWithTextFont:font rectSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
//    rect.size=starSize;
//    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: self.emptyColor}];
//    
//    CGRect clip = rect;
//    // 裁剪的宽度 = 点亮星星宽度 = （显示的星星数/总共星星数）*总星星的宽度
//    clip.size.width = starSize.width * (self.stars / (double)stars.length);
//    CGContextClipToRect(context,clip);
//    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: self.fullColor}];
//}
//@end


