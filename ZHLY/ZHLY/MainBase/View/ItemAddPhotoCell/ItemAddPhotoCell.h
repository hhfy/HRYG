//
//  ItemAddPhotoCell.h
//  ZTXWYGL
//
//  Created by LTWL on 2017/6/19.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CellClickEnableTypeAble,
    CellClickEnableTypeDisable
} CellClickEnableType;

//@class ItemAddPhotoCell;
//@protocol ItemAddPhotoCellDelegate <NSObject>
//@optional;
//- (void)itemAddPhotoCell:(ItemAddPhotoCell *)itemAddPhotoCell selectedPhotos:(NSArray <UIImage *>*)photos;
//- (void)photosViewDidClick:(ItemAddPhotoCell *)itemAddPhotoCell;
//- (void)didReloadTableView:(ItemAddPhotoCell *)itemAddPhotoCell;
//- (void)itemAddPhotoCell:(ItemAddPhotoCell *)itemAddPhotoCell helpBtnDidClick:(UIButton *)button;
//@end

typedef void(^SelectedPhotosBlock)(NSArray<UIImage *> *photos);
typedef void(^PhotosViewDidTapBlock)();
typedef void(^NeedReloadBlock)();

@interface ItemAddPhotoCell : UITableViewCell
/// 标题
@property (nonatomic, copy) NSString *title;
/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 标题属性文字
@property (nonatomic, strong) NSAttributedString *titleAtt;
/// 设置最大图片数
@property (nonatomic, assign) NSInteger photoCount;
/// 传入图片数组
@property (nonatomic, strong) NSArray *images;
/// 添加按钮图片
@property (nonatomic, strong) UIImage *addImage;
/// 设置添加功能模式
@property (nonatomic, assign) CellClickEnableType enableType;
/// 选择完成后图片回调
@property (nonatomic, copy) SelectedPhotosBlock selectedPhoto;
/// 监听点击图片的回调
@property (nonatomic, copy) PhotosViewDidTapBlock didTap;
/// 需要用到tableView刷新的回调
@property (nonatomic, copy) NeedReloadBlock needReload;
//
@property (nonatomic, copy) NSMutableArray *selectedPhotos;

@end
