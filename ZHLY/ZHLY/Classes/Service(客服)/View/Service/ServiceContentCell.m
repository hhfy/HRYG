//
//  ServiceContentCell.m
//  ZHLY
//
//  Created by LTWL on 2017/11/27.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ServiceContentCell.h"
#import "Service.h"

@interface ServiceContentCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;
@property (nonatomic, assign) CGFloat answerH;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@end

@implementation ServiceContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.contentViewH.constant = 0;
    self.arrowLabel.font = IconFont(22);
    self.arrowLabel.text = DownArrowIconUnicode3;
}

- (void)setQuestionDetial:(ServiceCommonQuestionDetial *)questionDetial {
    _questionDetial = questionDetial;
    self.questionLabel.text = questionDetial.question;
    self.answerLabel.text = questionDetial.answer;
    self.answerH = [questionDetial.answer boundingRectWithSize:CGSizeMake(MainScreenSize.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.answerLabel.font} context:nil].size.height + 30;
}

- (void)setOpenType:(CellOpenType)openType {
    _openType = openType;
    switch (openType) {
        case CellOpenTypeClose:
            self.contentViewH.constant = 0;
            self.arrowLabel.text = DownArrowIconUnicode3;
            break;
        case CellOpenTypeOpen:
            self.contentViewH.constant = self.answerH;
            self.arrowLabel.text = UpArrowIconUnicode3;
            break;
        default:
            break;
    }
}

@end
