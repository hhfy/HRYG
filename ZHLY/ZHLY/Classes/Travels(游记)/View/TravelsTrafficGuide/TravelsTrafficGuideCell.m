
//
//  TravelsTrafficGuideCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/4.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsTrafficGuideCell.h"
#import "Travels.h"

@interface TravelsTrafficGuideCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, assign) CGFloat contentH;
@end

@implementation TravelsTrafficGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.contentViewH.constant = 0;
    self.arrowLabel.font = IconFont(22);
    self.arrowLabel.text = DownArrowIconUnicode3;
}

- (void)setTrafficLines:(TravelTrafficLines *)trafficLines {
    _trafficLines = trafficLines;
    self.titleTextLabel.text = trafficLines.title;
    self.contentLabel.text = trafficLines.content;
    self.contentH = [trafficLines.content sizeWithTextFont:self.contentLabel.font rectSize:CGSizeMake(MainScreenSize.width - 30, MAXFLOAT)].size.height + 30;
    switch (trafficLines.icon) {
        case 1:
            self.iconView.image = SetImage(@"机场");
            break;
        case 2:
            self.iconView.image = SetImage(@"火车");
            break;
        case 3:
            self.iconView.image = SetImage(@"市内");
            break;
        case 4:
            self.iconView.image = SetImage(@"高速");
            break;
        case 5:
            self.iconView.image = SetImage(@"自驾");
            break;
        default:
            break;
    }
}

- (void)setOpenType:(CellOpenType)openType {
    _openType = openType;
    switch (openType) {
        case CellOpenTypeClose:
            self.contentViewH.constant = 0;
            self.arrowLabel.text = DownArrowIconUnicode3;
            break;
        case CellOpenTypeOpen:
            self.contentViewH.constant = self.contentH;
            self.arrowLabel.text = UpArrowIconUnicode3;
            break;
        default:
            break;
    }
}
@end
