//
//  TravelsSendTravelsTitleLabelCell.m
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsSendTravelsTitleLabelCell.h"
#import "Travels.h"

@interface TravelsSendTravelsTitleLabelCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopSpace;
@property (nonatomic, strong) UIButton *previousTagLabelBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaddingView;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedTagBtns;
@end

@implementation TravelsSendTravelsTitleLabelCell

- (NSMutableArray<NSNumber *> *)selectedTagBtns
{
    if (_selectedTagBtns == nil)
    {
        _selectedTagBtns = [NSMutableArray array];
    }
    return _selectedTagBtns;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    [self.titleTextField addTarget:self action:@selector(titleTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.titleTextField setValue:SetupColor(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    [self.loaddingView startAnimating];
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((JumpVcDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.titleTextField becomeFirstResponder];
    });
}

- (void)setStadiums:(NSArray<TravelStadium *> *)stadiums {
    _stadiums = stadiums;
    
    [self.loaddingView startAnimating];
    CGFloat topSpace = self.chooseLabel.maxY + 10;
    CGFloat leftSpace = self.chooseLabel.x;
    CGFloat margin = 10;
    CGFloat btnH = 25;
    CGFloat btnLeftRightMargin = 15;
    
    for (int i = 0; i < stadiums.count; i++) {
        TravelStadium *stadium = stadiums[i];
        
        UIButton *tagLabelBtn = [UIButton new];
        tagLabelBtn.tag = i;
        tagLabelBtn.isIgnore = YES;
        tagLabelBtn.backgroundColor = SetupColor(242, 242, 242);
        [tagLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [tagLabelBtn setTitleColor:SetupColor(170, 170, 170) forState:UIControlStateNormal];
        [tagLabelBtn setTitle:stadium.stadium_name forState:UIControlStateNormal];
        tagLabelBtn.titleLabel.font = TextSystemFont(13);
        [tagLabelBtn addTarget:self action:@selector(labelBtnDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tagLabelBtn];
        
        tagLabelBtn.width = [tagLabelBtn.currentTitle sizeWithAttributes:@{NSFontAttributeName : tagLabelBtn.titleLabel.font}].width + margin * 2;
        if (tagLabelBtn.width >= MainScreenSize.width - btnLeftRightMargin * 2) tagLabelBtn.width = MainScreenSize.width - btnLeftRightMargin * 2;
        tagLabelBtn.height = btnH;
        tagLabelBtn.layer.cornerRadius = tagLabelBtn.height * 0.5;
        
        if (i == 0) {
            tagLabelBtn.x = leftSpace;
            tagLabelBtn.y = topSpace;
            [self.loaddingView stopAnimating];
        } else {
            UIButton *previousTagLabelBtn = self.previousTagLabelBtn;
            CGFloat leftWidth = previousTagLabelBtn.maxX + margin;
            CGFloat rightWidth = MainScreenSize.width - leftWidth - btnLeftRightMargin * 2;
            if (rightWidth >= tagLabelBtn.width) {
                tagLabelBtn.x = leftWidth;
                tagLabelBtn.y = previousTagLabelBtn.y;
            } else {
                tagLabelBtn.x = leftSpace;
                tagLabelBtn.y = previousTagLabelBtn.maxY + margin;
            }
        }
        if (i == stadiums.count - 1) self.lineTopSpace.constant = tagLabelBtn.maxY + margin;
        self.previousTagLabelBtn = tagLabelBtn;
    }
    
}

- (void)labelBtnDidTap:(UIButton *)button {
    button.selected = !button.isSelected;
    button.backgroundColor = (button.isSelected) ? MainThemeColor : SetupColor(242, 242, 242);
    
    if (button.isSelected) {
        [self.selectedTagBtns addObject:@(button.tag)];
        [LaiMethod animationWithView:button];
    } else {
        [self.selectedTagBtns removeObject:@(button.tag)];
    }
    if (self.selectedTag) {
        NSMutableArray *tagArrM = [NSMutableArray array];
        for (NSNumber *btnTag in self.selectedTagBtns) {
            TravelStadium *stadium = self.stadiums[btnTag.integerValue];
            [tagArrM addObject:stadium.supplier_stadium_id];
        }
        self.selectedTag(tagArrM);
    }
}

#pragma mark - UITextFieldDelegate
- (void)titleTextFieldTextChange:(UITextField *)textField {
    self.titleCountLabel.text = [NSString stringWithFormat:@"%zd/30", textField.text.length];
    if (self.inputTitle) self.inputTitle(textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger MaxTextLength = 30;
    // 切割字符串
    NSString *comcatStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger canInputLength = MaxTextLength - comcatStr.length;
    
    if (canInputLength >= 0) {
        return YES;
    } else {
        NSInteger len = string.length + canInputLength;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[string stringByReplacingCharactersInRange:range withString:s]];
        }
        [SVProgressHUD showError:@"标题不超过30个字!"];
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
    return YES;
}

@end
