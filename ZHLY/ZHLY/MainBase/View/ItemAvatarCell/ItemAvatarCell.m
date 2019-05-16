//
//  ItemAvatarCell.m
//  ZHDJ
//
//  Created by LTWL on 2017/8/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "ItemAvatarCell.h"

@interface ItemAvatarCell () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarIconView;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineRightSpace;
@end

@implementation ItemAvatarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.arrowLabel.font = IconFont(15);
    self.arrowLabel.text = RightArrowIconUnicode;
    self.avatarIconView.layer.cornerRadius = self.avatarIconView.height * 0.5;
}

- (void)setIcon:(NSString *)icon {
    _icon = [icon copy];
    [self.avatarIconView sd_setImageWithURL:SetURL(icon) placeholderImage:SetImage(@"头像占位图")];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.itemTitleLabel.text = title;
}

- (void)setLineLeftW:(CGFloat)lineLeftW {
    _lineLeftW = lineLeftW;
    self.lineLeftSpace.constant = lineLeftW;
}

- (void)setLineRightW:(CGFloat)lineRightW {
    _lineRightW = lineRightW;
    self.lineRightSpace.constant = lineRightW;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [CurrentViewController.view endEditing:YES];
    if (!selected) return;
    [LaiMethod alertSPAlerSheetControllerWithTitle:nil message:nil defaultActionTitles:@[@"拍摄", @"从手机相册选择"] destructiveTitle:nil cancelTitle:@"取消" handler:^(NSInteger actionIndex) {
        switch (actionIndex) {
            case 0:
                [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 系统相册相机
- (void)openImagePickerController:(UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = sourceType;
    ipc.allowsEditing = YES; // 允许图片编辑
    ipc.delegate = self;
    [CurrentWindow.rootViewController presentViewController:ipc animated:YES completion:nil];
}

// 相册代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.avatarIconView.image = image;
    if (self.didSelected) self.didSelected(image);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [CurrentWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
