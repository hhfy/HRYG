//
//  HomeHotSpotCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/2/7.
//  Copyright © 2018年 LTWL. All rights reserved.
//

#import "HomeHotSpotCell.h"
#import "Home.h"

@interface HomeHotSpotCell ()
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImgwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImgheight;

@end

@implementation HomeHotSpotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topImgheight.constant = MainScreenSize.width*0.7*27/451;
    self.leftImgwidth.constant = MainScreenSize.width/2-8;
    self.rightImgWidth.constant = MainScreenSize.width/2-8;

    self.leftImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftTapAvatarView)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
    PrivateLetterTap.delegate= self;
    [self.leftImgView addGestureRecognizer:PrivateLetterTap];
    
    self.rightImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * privateLetterTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTapAvatarView)];
    privateLetterTap1.numberOfTouchesRequired = 1;
    privateLetterTap1.numberOfTapsRequired = 1;
    privateLetterTap1.delegate= self;
    [self.rightImgView addGestureRecognizer:privateLetterTap1];
}

-(void)leftTapAvatarView {
    HomeAd *ad = (HomeAd*)self.ad2[0];
    NSString *url = ad.url;;
    if(url){
        [LaiMethod urlRoutePushWithUrl:url];
    }
}

-(void)rightTapAvatarView {
    HomeAd *ad = (HomeAd*)self.ad2[1];
    NSString *url = ad.url;;
    if(url){
        [LaiMethod urlRoutePushWithUrl:url];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAd2:(NSArray *)ad2 {
    _ad2 = ad2;
    for (int i=0; i<ad2.count; i++) {
        HomeAd *ad = ad2[i];
        if(i==0){
            [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:ad.path] placeholderImage:[UIImage imageNamed:@""]];
        }
        else if(i==1){
            [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:ad.path] placeholderImage:[UIImage imageNamed:@""]];
        }
    }
}

@end
