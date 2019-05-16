//
//  LaiMethod.h
//  ZTXWY
//
//  Created by LTWL on 2017/6/8.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaiMethod : NSObject
/// 系统弹窗两个选项
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitle:(NSString *)actionTitle style:(UIAlertActionStyle)style cancelTitle:(NSString *)cancelTitle preferredStyle:(UIAlertControllerStyle)preferredStyle handler:(void(^)(void))handler;

/// 系统弹窗一个个选项
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitle:(NSString *)actionTitle style:(UIAlertActionStyle)style handler:(void(^)(void))handler;

/// 微信风格sheet弹窗
+ (void)alertSPAlerSheetControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitles:(NSArray<NSString *> *)actionTitles destructiveTitle:(NSString *)destructiveTitle cancelTitle:(NSString *)cancelTitle  handler:(void(^)(NSInteger actionIndex))handler;

/// 微信风格Aler弹窗
+ (void)alertSPAlerControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitles:(NSArray<NSString *> *)actionTitles destructiveTitle:(NSString *)destructiveTitle cancelTitle:(NSString *)cancelTitle  handler:(void(^)(NSInteger actionIndex))handler;

/// 微信风格自定义弹窗
+ (void)alertSPAlerCustomControllerWithdefaultActionTitle:(NSString *)actionTitle destructiveTitle:(NSString *)destructiveTitle cancelTitle:(NSString *)cancelTitle customView:(UIView *)customView handler:(void(^)(void))handler;

/// 微信风格自定义sheet弹窗
+ (void)alertSPAlerCustomSheetCustomView:(UIView *)customView handler:(void(^)(SPAlertController *alertController))handler;

/// 按钮点击动画
+ (void)animationWithView:(UIView *)view;
+ (void)sprintAnimationWithButton:(UIControl *)button;

/// 摇摆动画
+ (void)wrongInputAnimationWith:(UIView *)view;

//判断相机权限是否打开
+ (BOOL)isUserCameraPowerOpen;

/// 前往设置开启权限
+ (void)openRootPowerWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle;

/// 设置下拉刷新
+ (void)setupDownRefreshWithTableView:(UITableView *)tableView target:(id)target action:(SEL)action;
+ (void)setupDownRefreshWithCollectionView:(UICollectionView *)collectionView target:(id)target action:(SEL)action;
+ (void)setupDownRefreshWithScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action;

/// 设置上拉刷新
+ (void)setupUpRefreshWithTableView:(UITableView *)tableView target:(id)target action:(SEL)action;
+ (void)setupUpRefreshWithCollectionView:(UICollectionView *)collectionView target:(id)target action:(SEL)action;

/// 设置弹性下拉刷新
+ (void)setupElasticPullRefreshWithTableView:(UITableView *)tableView loadingViewCircleColor:(UIColor *)loadingViewCircleColor  ElasticPullFillColor:(UIColor *)elasticPullfillColor actionHandler:(void(^)(void))actionHandler;

/// 设置自定义picker
+ (CustomDatePicker *)setupCustomPickerWithTitle:(NSString *)title delegate:(id<CustomDatePickerDelegate>)delegate dataSource:(id<CustomDatePickerDataSource>)dataSource tintColor:(UIColor *)tintColor;

/// 设置Datepicker
+ (void)setupKSDatePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate dateMode:(UIDatePickerMode)dateMode headerColor:(UIColor *)headerColor result:(void (^)(NSDate *selected))result;

/// AttributeString转换
+ (void)stringFormatAttributeStringWithStrA:(NSString *)strA strB:(NSString *)strB handler:(void (^)(NSString *fullStr, NSMutableAttributedString *attrStr))handler;

/// 判断这个文件是否存在
+ (BOOL)isFileExist:(NSString *)fileName;

/// 判断是不是word,Excel，ppt,pdf文件
+ (BOOL)isKindOfDocumentFileWithFileName:(NSString *)fileName;

/// runtime机制push控制器
+ (void)runtimePushVcName:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav;

/// urlRoute跳转
+ (void)urlRoutePushWithUrl:(NSString *)url;

/// 登录和退出登录动画
+ (void)loginAndLogoutAnmitonWithTargetVc:(UIViewController *)targetVc subtype:(NSString *)subtype ;

/// ios原生分享
+ (void)iosActivityShareWithActivityItems:(NSArray *)items completionWithItemsHandler:(void (^)(BOOL completed, NSString *activityType, NSError *error))handler;

/// 给按钮的文字加上下划线
+ (void)makeButtonUnderlineWithButton:(UIButton *)button;

/// 设置图片浏览器
+ (void)setupPhotoBrowserWithImageCount:(NSInteger)count offsetY:(CGFloat)offsetY currentImageIndex:(NSInteger)index sourceImagesContainerView:(UIView *)view indexShowType:(PhotoIndexType)type delegate:(id<HZPhotoBrowserDelegate>)delegate;

/// 返回到指定控制器
+ (void)popToTargetViewController:(id)viewController;

/// 根据图片大小等比缩放
+ (CGFloat)uniformScaletWithWidth:(CGFloat)width Image:(UIImage *)image;
//签名
+(NSString *)getSign;
//支付类型
+(NSString *)getPayType:(NSInteger)type;
+(void)applyAttributeToLabel:(UILabel *)label atRange:(NSRange )range withAttributes:(NSDictionary *)attributes;
//日期字符串（2018.1.5）转nsdate
+(NSDate *)getDateString:(NSString *)timeStr withFormat:(NSString *)format;
@end
