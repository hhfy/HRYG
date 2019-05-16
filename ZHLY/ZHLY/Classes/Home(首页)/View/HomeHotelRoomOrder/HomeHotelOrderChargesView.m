//
//  HomeHotelOrderChargesView.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/25.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeHotelOrderChargesView.h"

@interface HomeHotelOrderChargesView()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@end

@implementation HomeHotelOrderChargesView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI {
    
}

-(void)fillInfo:(NSArray *)info withPrice:(NSString *)roomPrice withCount:(NSInteger)count {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",roomPrice]];
    [attributeString addAttributes:@{NSForegroundColorAttributeName:MainThemeColor,NSFontAttributeName:TextSystemFont(13)} range:NSMakeRange(0, 1)];
    self.priceLabel.attributedText = attributeString;    
    self.infoLbl.text = [NSString stringWithFormat:@"%zd间 | %zd晚",count,info.count];
}


@end
