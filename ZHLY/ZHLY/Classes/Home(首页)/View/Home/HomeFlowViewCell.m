//
//  HomeFlowViewCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/2/8.
//  Copyright © 2018年 LTWL. All rights reserved.
//

#import "HomeFlowViewCell.h"
#import "NewPagedFlowView.h"
#import "PGCustomBannerView.h"
#import "Home.h"

@interface HomeFlowViewCell()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
//卡片轮数组
@property (nonatomic, strong) NSMutableArray *imageArray;
//卡片轮播图
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
//点击展示数组
@property (nonatomic, strong) NSMutableArray *showImgArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImgHeight;
@end

@implementation HomeFlowViewCell

-(NSMutableArray *)imageArray {
    if(!_imageArray){
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewHeight.constant = MainScreenSize.width*9/16;
    self.topImgHeight.constant = MainScreenSize.width*0.7*27/451;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setSceneArr:(NSArray *)sceneArr {
    _sceneArr = sceneArr;
    NSMutableArray *arr = [NSMutableArray array];
    for (HomeScene *scene in sceneArr) {
        if(scene.scene_photo_album.count>0){
            [self.imageArray addObject:scene.scene_photo_album[0]];
            [arr addObject:scene];
        }
    }
    _sceneArr = arr;
    if(!self.pageFlowView){
        [self setupPagedFlowUI];
    }
}

- (void)setupPagedFlowUI {
//    self.automaticallyAdjustsScrollViewInsets = NO;
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width, MainScreenSize.width*9/16)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.4;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.orginPageCount = self.imageArray.count;
    pageFlowView.isOpenAutoScroll = YES;
    [pageFlowView reloadData];
    self.pageFlowView = pageFlowView;
    [pageFlowView scrollToPage:1];
    [self.backView addSubview:self.pageFlowView];
}

#pragma mark --NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    HomeScene *scene = self.sceneArr[subIndex];
    self.showImgArray = [NSMutableArray arrayWithArray:scene.scene_photo_album];
    if (self.imgTapBack) self.imgTapBack(self.showImgArray);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    NSLog(@"CustomViewController 滚动到了第%ld页",pageNumber);
}

//左右中间页显示大小为 Width - 50, (Width - 50) * 9 / 16
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(MainScreenSize.width - 80, (MainScreenSize.width - 80) * 9 / 16);
}

#pragma mark --NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.imageArray.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGCustomBannerView *bannerView = (PGCustomBannerView *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGCustomBannerView alloc] init];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[index]]
                      placeholderImage:[UIImage imageNamed:@"homeTopImgView"]];
    for (int i=0;i<self.sceneArr.count;i++) {
        if(i==index){
            HomeScene *scene = self.sceneArr[i];
            bannerView.indexLabel.text = scene.scene_name;
//            [NSString stringWithFormat:@"第%ld张图",(long)index + 1];
        }
    }
    return bannerView;
}

@end



