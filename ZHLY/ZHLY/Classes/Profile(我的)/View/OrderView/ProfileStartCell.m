//
//  ProfileStartCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/6.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileStartCell.h"
#import "StartRateView.h"

@interface ProfileStartCell()
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (nonatomic, strong) StarRateView *startRateView;
@end

@implementation ProfileStartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.startRateView = [[StarRateView alloc]initWithFrame:CGRectMake(5, 10, 180, 25) numberOfStars:5 rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
        if(self.starBlock) self.starBlock(currentScore);
    }];
    [self.starView addSubview:self.startRateView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCurrentScore:(NSString *)currentScore {
    _currentScore = currentScore;
    self.startRateView.beginScore = [currentScore floatValue];
}

@end
