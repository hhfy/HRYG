//
//  HomeSeasonTicketOrderInfoWithCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/1/3.
//  Copyright © 2018年 LTWL. All rights reserved.
//

#import "HomeSeasonTicketOrderInfoWithCell.h"
#import "Home.h"

@interface HomeSeasonTicketOrderInfoWithCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightInfolabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;

@end

@implementation HomeSeasonTicketOrderInfoWithCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTicket:(HomeSeasonTicketOrderTicketList *)ticket {
    _ticket = ticket;
    self.titleLabel.text = ticket.ticket_name;
    
//    self.rightInfolabel.text = @"";
//    self.timeLabel.text = @"";
    self.countLabel.text = [NSString stringWithFormat:@"x %@",ticket.pt_ticket_num];
    NSString *price = ticket.pt_ticket_price ? ticket.pt_ticket_price : @"";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：¥%@",price]];
    [attributeString addAttributes:@{NSForegroundColorAttributeName:SetupColor(51,51,51),NSFontAttributeName:TextSystemFont(13)} range:NSMakeRange(0, 3)];
    self.priceLabel.attributedText = attributeString;
}

@end
