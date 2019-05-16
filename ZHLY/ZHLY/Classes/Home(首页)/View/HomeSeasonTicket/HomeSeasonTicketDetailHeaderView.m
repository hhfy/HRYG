//
//  HomeSeasonTicketDetailHeaderView.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeSeasonTicketDetailHeaderView.h"
#import "Home.h"

@interface HomeSeasonTicketDetailHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@end

@implementation HomeSeasonTicketDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rightBtn.titleLabel.font = IconFont(16);
    [self.rightBtn setTitle:[NSString stringWithFormat:@"购买须知%@",RightArrowIconUnicode] forState:UIControlStateNormal];
}


-(void)setTicketDetail:(HomeMuseumSeasonTicketDetail *)ticketDetail {
//    self.imgView sd_setImageWithURL:<#(nullable NSURL *)#> placeholderImage:<#(nullable UIImage *)#> options:<#(SDWebImageOptions)#>
}
@end
