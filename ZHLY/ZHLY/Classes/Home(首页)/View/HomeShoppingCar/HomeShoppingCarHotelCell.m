
//
//  HomeShoppingCarCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "HomeShoppingCarHotelCell.h"
#import "Home.h"

@interface HomeShoppingCarHotelCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIView *countTextFiledBgView;
@property (nonatomic, assign) NSInteger count;
@end

@implementation HomeShoppingCarHotelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.selectedBtn.titleLabel.font = IconFont(22);
    self.selectedBtn.isIgnore = YES;
    [self.selectedBtn setTitle:CircleIconUnicode forState:UIControlStateNormal];
    [self.selectedBtn setTitle:TrueIconUnicode forState:UIControlStateSelected];
    
    self.count = 1;
    self.countTextField.text = @(self.count).description;
    self.minusBtn.isIgnore = self.plusBtn.isIgnore = YES;
    self.minusBtn.enabled = NO;
    self.countTextFiledBgView.layer.borderWidth = 0.5;
    self.countTextFiledBgView.layer.borderColor = SetupColor(224, 157, 91).CGColor;
    self.minusBtn.titleLabel.font = self.plusBtn.titleLabel.font = IconFont(15);
    self.minusBtn.adjustsImageWhenHighlighted = self.plusBtn.adjustsImageWhenHighlighted = NO;
    [self.minusBtn setTitle:MinusIconUnicode forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
    [self.plusBtn setTitle:PlusIconUnicode forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:SetupColor(224, 157, 91) forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:SetupColor(205, 205, 205) forState:UIControlStateDisabled];
    [self.countTextField addTarget:self action:@selector(countTextField:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setIsSelectedStatus:(BOOL)isSelectedStatus {
    _isSelectedStatus = isSelectedStatus;
    self.selectedBtn.selected = isSelectedStatus;
}

- (void)setHotel:(HomeShoppingCarHotel *)hotel {
    _hotel = hotel;
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    [self.iconView sd_setImageWithURL:SetURL(SmallImage(hotel.home_image)) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.loaddingView stopAnimating];
    }];
    self.titleTextLabel.text = hotel.room_name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", hotel.price];
    self.dateLabel.text = [NSString stringWithFormat:@"有效日期：%@-%@", [NSString stringFromTimestampFromat:hotel.room_start_time formatter:FmtMD2], [NSString stringFromTimestampFromat:hotel.room_end_time formatter:FmtMD2]];
    self.count = hotel.room_nums;
    self.countTextField.text = @(self.count).description;
    self.minusBtn.enabled = (self.count > 1);
    self.hotel.totalPrice = self.count * self.hotel.price.floatValue;
    self.hotel.totalCount = self.count;
    
//    NSInteger minCount = (self.shoppingCar.ticket_num) ? self.shoppingCar.ticket_num : 1;
//    self.minusBtn.enabled = !(self.shoppingCar.nums == minCount);
//    if (self.shoppingCar.ticket_store_isopen == 1 && self.shoppingCar.ticket_store_num) {
//        NSInteger maxCount = self.shoppingCar.ticket_store_num;
//        self.plusBtn.enabled = !(self.shoppingCar.nums == maxCount);
//    }
}

- (IBAction)selectedBtn:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.isSelected) {
        [LaiMethod animationWithView:button];
        self.hotel.totalPrice = self.count * self.hotel.price.floatValue;
        self.hotel.totalCount = self.count;
    }
    if (self.changeStatus) self.changeStatus(self.indexPath, button.isSelected);
}

- (IBAction)minusBtnTap:(UIButton *)button {
    self.count--;
    NSInteger minCount = 1;//(self.shoppingCar.ticket_num) ? self.shoppingCar.ticket_num : 1;
    if (self.count <= minCount) {
        self.count = minCount;
        button.enabled = NO;
    }
    [LaiMethod animationWithView:self.countTextField];
    self.countTextField.text = @(self.count).description;
    self.plusBtn.enabled = YES;
    [self updateDataAndStatus];
}

- (IBAction)plusBtnTap:(UIButton *)button {
    self.count++;
//    if (self.shoppingCar.ticket_store_isopen == 1) {
//        if (self.count >= self.shoppingCar.ticket_store_num) {
//            self.count = self.shoppingCar.ticket_store_num;
//            button.enabled = NO;
//        }
//    }
    [LaiMethod animationWithView:self.countTextField];
    self.countTextField.text = @(self.count).description;
    self.minusBtn.enabled = YES;
    [self updateDataAndStatus];
}

- (void)countTextField:(UITextField *)textField {
    self.plusBtn.enabled = self.minusBtn.enabled = YES;
    
    if (textField.text.integerValue == 0 || [textField.text isEqualToString:@""]) {
        [SVProgressHUD showError:@"数量不能为空或者为0"];
        textField.text = @"1";
        self.plusBtn.enabled = NO;
    }

    self.count = textField.text.integerValue;
    
//    if (self.shoppingCar.ticket_store_isopen == 1) {
//        self.plusBtn.enabled = (self.count <= self.shoppingCar.ticket_store_num);
//        if (self.count >= self.shoppingCar.ticket_store_num) {
//            if (self.count > self.shoppingCar.ticket_store_num) [SVProgressHUD showError:@"超过库存量"];
//            self.count = self.shoppingCar.ticket_store_num;
//            textField.text = @(self.count).description;
//            self.plusBtn.enabled = NO;
//        }
//    }
    
    NSInteger minCount = 1;//(self.shoppingCar.ticket_num) ? self.shoppingCar.ticket_num : 1;
    if (self.count < minCount) {
        self.count = self.hotel.room_nums;
        textField.text = @(self.count).description;
        [SVProgressHUD showError:@"不能小于最低起售"];
        self.minusBtn.enabled = NO;
    }
    [self updateDataAndStatus];
}

- (void)updateDataAndStatus {
    self.hotel.totalPrice = self.count * self.hotel.price.floatValue;
    self.hotel.totalCount = self.count;
    if (self.changeStatus) self.changeStatus(self.indexPath, YES);
    if (self.selectedBtn.selected == NO) self.selectedBtn.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
    return YES;
}

@end
