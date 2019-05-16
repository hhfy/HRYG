
//
//  LaiMethod.m
//  ZTXWY
//
//  Created by LTWL on 2017/6/8.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "LaiMethod.h"
#import <JLRoutes.h>
#import "payRequsestHandler.h"

#define currentWindow

@implementation LaiMethod
/// 封装系统弹出框（两个选项）
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitle:(NSString *)actionTitle style:(UIAlertActionStyle)style cancelTitle:(NSString *)cancelTitle preferredStyle:(UIAlertControllerStyle)preferredStyle handler:(void(^)(void))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:actionTitle style:style handler:^(UIAlertAction * _Nonnull action) {
        if (handler) handler();
    }];
    [alertController addAction:cancel];
    [alertController addAction:defaultAction];
    [CurrentViewController presentViewController:alertController animated:YES completion:nil];
}

/// 封装系统弹出框（一个选项）
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitle:(NSString *)actionTitle style:(UIAlertActionStyle)style handler:(void(^)(void))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:actionTitle style:style handler:^(UIAlertAction * _Nonnull action) {
        if (handler) handler();
    }];
    [alertController addAction:defaultAction];
    [CurrentViewController presentViewController:alertController animated:YES completion:nil];
}



+ (BOOL)isUserCameraPowerOpen {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) return NO;
    return YES;
}

+ (void)openRootPowerWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle {
    [LaiMethod alertControllerWithTitle:title message:message defaultActionTitle:actionTitle style:UIAlertActionStyleCancel handler:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString]; // @"App-Prefs:root=Photos"
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
}

+ (void)iosActivityShareWithActivityItems:(NSArray *)items completionWithItemsHandler:(void (^)(BOOL completed, NSString *activityType, NSError *error))handler {
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityViewController.modalInPopover = true;
    [CurrentViewController presentViewController:activityViewController animated:YES completion:nil];
    [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (handler) handler(completed, activityType, activityError);
    }];
}

+ (void)animationWithView:(UIView *)view {
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(7, 7)];
    sprintAnimation.springSpeed = 20;
    sprintAnimation.springBounciness = 15.f;
    sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
    [view pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
}

+ (void)sprintAnimationWithButton:(UIControl *)button {
    for (UIImageView *imageView in button.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
            animation.duration = 0.65;
            animation.calculationMode = kCAAnimationCubic;
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

+ (void)wrongInputAnimationWith:(UIView *)view {
    if (view.centerX != MainScreenSize.width * 0.5) return;
    POPSpringAnimation *shake = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    shake.springBounciness = 20;
    shake.velocity = @(1500);
    shake.springSpeed = 60;
    shake.beginTime = CACurrentMediaTime() + 0.01;
    [view.layer pop_addAnimation:shake forKey:@"shakeView"];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)setupDownRefreshWithTableView:(UITableView *)tableView target:(id)target action:(SEL)action {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"   下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"   释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"   加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = TextSystemFont(14);
    header.stateLabel.textColor = SetupColor(135, 135, 135);
    header.labelLeftInset = 5;
    header.automaticallyChangeAlpha = YES;
    tableView.mj_header = header;
}

+ (void)setupDownRefreshWithScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action {
    scrollView.mj_header = [LaiDIYTaoBaoRefreshHeader headerWithRefreshingTarget:target refreshingAction:action];
}

+ (void)setupUpRefreshWithTableView:(UITableView *)tableView target:(id)target action:(SEL)action {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    footer.labelLeftInset = 5;
    [footer setTitle:@"点击加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"   加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = TextSystemFont(13);
    footer.stateLabel.textColor = SetupColor(157, 157, 157);
    [footer setAutomaticallyHidden:YES];
    tableView.mj_footer = footer;
}

+ (void)setupDownRefreshWithCollectionView:(UICollectionView *)collectionView target:(id)target action:(SEL)action {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"   下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"   释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"   加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = TextSystemFont(14);
    header.stateLabel.textColor = SetupColor(135, 135, 135);
    header.labelLeftInset = 5;
    header.automaticallyChangeAlpha = YES;
    collectionView.mj_header = header;
}

+ (void)setupUpRefreshWithCollectionView:(UICollectionView *)collectionView target:(id)target action:(SEL)action {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    footer.labelLeftInset = 5;
    [footer setTitle:@"点击加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"   加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = TextSystemFont(13);
    footer.stateLabel.textColor = SetupColor(157, 157, 157);
    [footer setAutomaticallyHidden:YES];
    collectionView.mj_footer = footer;
}

+ (void)setupElasticPullRefreshWithTableView:(UITableView *)tableView loadingViewCircleColor:(UIColor *)loadingViewCircleColor  ElasticPullFillColor:(UIColor *)elasticPullfillColor actionHandler:(void(^)(void))actionHandler {
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = loadingViewCircleColor;
    [tableView addJElasticPullToRefreshViewWithActionHandler:^{
        if (actionHandler) actionHandler();
    } LoadingView:loadingViewCircle];
    [tableView setJElasticPullToRefreshFillColor:elasticPullfillColor];
    [tableView setJElasticPullToRefreshBackgroundColor:tableView.backgroundColor];
}

+ (CustomDatePicker *)setupCustomPickerWithTitle:(NSString *)title delegate:(id<CustomDatePickerDelegate>)delegate dataSource:(id<CustomDatePickerDataSource>)dataSource tintColor:(UIColor *)tintColor {
    CustomDatePicker * pickerView = [[CustomDatePicker alloc] initWithSureBtnTitle:@"取消" mainTitle:title otherButtonTitle:@"确定"];
    pickerView.tintColor = tintColor;
    pickerView.delegate = delegate;
    pickerView.dataSource = dataSource;
    [pickerView show];
    return pickerView;
}


+ (void)setupKSDatePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate dateMode:(UIDatePickerMode)dateMode headerColor:(UIColor *)headerColor result:(void (^)(NSDate *selected))result {
    KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width - 40, 300)];
    picker.appearance.radius = 5;
    picker.appearance.minimumDate = minDate;
    picker.appearance.maximumDate = maxDate;
    picker.appearance.datePickerMode = dateMode;
    picker.appearance.headerBackgroundColor = headerColor;
    //设置回调
    picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
        if (buttonType == KSDatePickerButtonCommit) {
            if (result) result(currentDate);
        }
    };
    [picker show];
}

+ (void)stringFormatAttributeStringWithStrA:(NSString *)strA strB:(NSString *)strB handler:(void (^)(NSString *fullStr, NSMutableAttributedString *attrStr))handler {
    NSString *fullString = [NSString stringWithFormat:@"%@%@", strA, strB];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullString];
    if (handler) handler(fullString, attrString);
}

+ (BOOL)isFileExist:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

+ (BOOL)isKindOfDocumentFileWithFileName:(NSString *)fileName {
    return [fileName hasSuffix:@".doc"] || [fileName hasSuffix:@".docx"] || [fileName hasSuffix:@".xls"] || [fileName hasSuffix:@".xlsx"] || [fileName hasSuffix:@".ppt"] || [fileName hasSuffix:@".pptx"] || [fileName hasSuffix:@".pdf"];
}

+ (void)runtimePushVcName:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav {
    const char *className = [vcName cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
//        Class superClass = [NSObject class];
//        newClass = objc_allocateClassPair(superClass, className, 0);
//        objc_registerClassPair(newClass);
        Log(@"找不到%@", vcName);
        [SVProgressHUD showError:[NSString stringWithFormat:@"找不到名为%@的类", vcName]];
    } else {
        id instance = [[newClass alloc] init];
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
                Log(@"%@,%@",obj,key);
                [instance setValue:obj forKey:key];
            }else {
                Log(@"不包含key=%@的属性",key);
            }
        }];
        [nav pushViewController:instance animated:YES];
    }
}

/// runtime检测对象是否存在该属性
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName {
    unsigned int outCount, i;
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    // 再遍历父类中的属性
    Class superClass = class_getSuperclass([instance class]);
    
    //通过下面的方法获取属性列表
    unsigned int outCount2;
    objc_property_t *properties2 = class_copyPropertyList(superClass, &outCount2);
    
    for (int i = 0 ; i < outCount2; i++) {
        objc_property_t property2 = properties2[i];
        //  属性名转成字符串
        NSString *propertyName2 = [[NSString alloc] initWithCString:property_getName(property2) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName2 isEqualToString:verifyPropertyName]) {
            free(properties2);
            return YES;
        }
    }
    free(properties2); //释放数组
    return NO;
}

+ (void)urlRoutePushWithUrl:(NSString *)url {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:SetURL([url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]) options:@{} completionHandler:nil];
    }
    else {
        [[UIApplication sharedApplication] openURL:SetURL([url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]])];
    }
}

+ (void)loginAndLogoutAnmitonWithTargetVc:(UIViewController *)targetVc subtype:(NSString *)subtype {
    CATransition *animation = [CATransition animation];
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;
    animation.duration = 0.5f;
    animation.subtype = subtype; //kCATransitionFromRight
    [CurrentWindow.layer addAnimation:animation forKey:nil];
    CurrentWindow.rootViewController = targetVc;
}

+ (void)makeButtonUnderlineWithButton:(UIButton *)button {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:button.titleLabel.text];
    NSRange strRange = {0,[string length]};
    [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [button setAttributedTitle:string forState:UIControlStateNormal];
}


+ (void)setupPhotoBrowserWithImageCount:(NSInteger)count offsetY:(CGFloat)offsetY currentImageIndex:(NSInteger)index sourceImagesContainerView:(UIView *)view indexShowType:(PhotoIndexType)type delegate:(id<HZPhotoBrowserDelegate>)delegate {
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.offsetY = offsetY;
    browserVc.indexType = type;
    browserVc.sourceImagesContainerView = view;
    browserVc.imageCount = count;
    browserVc.currentImageIndex = index;
    browserVc.delegate = delegate;
    [browserVc show];
}

+ (void)popToTargetViewController:(id)viewController {
    for (UIViewController *controller in CurrentViewController.navigationController.viewControllers) {
        if ([controller isKindOfClass:[viewController class]]) {
            [CurrentViewController.navigationController popToViewController:controller animated:YES];
        }
    }
}

+ (void)alertSPAlerSheetControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitles:(NSArray<NSString *> *)actionTitles destructiveTitle:(NSString *)destructiveTitle cancelTitle:(NSString *)cancelTitle  handler:(void(^)(NSInteger actionIndex))handler {
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:title message:message preferredStyle:SPAlertControllerStyleActionSheet animationType:SPAlertAnimationTypeDefault];
    for (int i = 0; i < actionTitles.count; i++) {
        SPAlertAction *action = [SPAlertAction actionWithTitle:actionTitles[i] style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NoneSpace * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (handler) handler(i);
            });
        }];
        [alertController addAction:action];
    }
    if (destructiveTitle) {
        SPAlertAction *destructiveAction = [SPAlertAction actionWithTitle:destructiveTitle style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NoneSpace * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (handler) handler(0);
            });
        }];
        [alertController addAction:destructiveAction];
    }
    SPAlertAction *actionCancel = [SPAlertAction actionWithTitle:cancelTitle style:SPAlertActionStyleCancel handler:nil];
    [alertController addAction:actionCancel];
    alertController.needDialogBlur = NO;
    [CurrentViewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)alertSPAlerControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitles:(NSArray<NSString *> *)actionTitles destructiveTitle:(NSString *)destructiveTitle cancelTitle:(NSString *)cancelTitle  handler:(void(^)(NSInteger actionIndex))handler {
    UIColor *tintColor = SetupColor(21, 126, 251);
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:title message:message preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeExpand];
    if (actionTitles.count < 2) {
        SPAlertAction *actionCancel = [SPAlertAction actionWithTitle:cancelTitle style:SPAlertActionStyleCancel handler:nil];
        actionCancel.titleColor = tintColor;
        [alertController addAction:actionCancel];
    }
    if (destructiveTitle) {
        SPAlertAction *destructiveAction = [SPAlertAction actionWithTitle:destructiveTitle style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
            if (handler) handler(0);
        }];
        [alertController addAction:destructiveAction];
    }
    for (int i = 0; i < actionTitles.count; i++) {
        SPAlertAction *action = [SPAlertAction actionWithTitle:actionTitles[i] style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
            if (handler) handler(i);
        }];
        action.titleColor = tintColor;
        [alertController addAction:action];
    }
    if (actionTitles.count >= 2) {
        SPAlertAction *actionCancel = [SPAlertAction actionWithTitle:cancelTitle style:SPAlertActionStyleCancel handler:nil];
        actionCancel.titleColor = tintColor;
        [alertController addAction:actionCancel];
    }
    [CurrentViewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)alertSPAlerCustomControllerWithdefaultActionTitle:(NSString *)actionTitle destructiveTitle:(NSString *)destructiveTitle cancelTitle:(NSString *)cancelTitle customView:(UIView *)customView handler:(void(^)(void))handler {
    UIColor *tintColor = SetupColor(21, 126, 251);
    SPAlertController *alertController = [SPAlertController alertControllerWithPreferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeExpand customHeaderView:customView];
    if (cancelTitle) {
        SPAlertAction *actionCancel = [SPAlertAction actionWithTitle:cancelTitle style:SPAlertActionStyleCancel handler:nil];
        actionCancel.titleColor = tintColor;
        [alertController addAction:actionCancel];
    }
    SPAlertAction *action = [SPAlertAction actionWithTitle:actionTitle style:SPAlertActionStyleDefault handler:nil];
    action.titleColor = tintColor;
    [alertController addAction:action];
    if (destructiveTitle) {
        SPAlertAction *actionDestructive = [SPAlertAction actionWithTitle:destructiveTitle style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
            if (handler) handler();
        }];
        [alertController addAction:actionDestructive];
    }
    [CurrentViewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)alertSPAlerCustomSheetCustomView:(UIView *)customView handler:(void(^)(SPAlertController *alertController))handler {
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:nil message:nil preferredStyle:SPAlertControllerStyleActionSheet animationType:SPAlertAnimationTypeRaiseUp customView:customView];
    if (handler) handler(alertController);
    alertController.needDialogBlur = NO;
    [CurrentViewController presentViewController:alertController animated:YES completion:nil];
}

+ (CGFloat)uniformScaletWithWidth:(CGFloat)width Image:(UIImage *)image {
    CGSize size = image.size;
    CGFloat scale = width / (size.width);
    CGFloat imageHeight = size.height * scale;
    return imageHeight;
}

+(NSString *)getSign {
    payRequsestHandler *hander = [[payRequsestHandler alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SignKey forKey:@"key"];
    return [hander createMd5Sign:dict];
}

+(NSString *)getPayType:(NSInteger)type {
    NSString *typeName;
    if (type == 1) {
        typeName = @"alipay";
    }
    else if(type == 2){
        typeName = @"WXPAY";
    }
    return typeName;
}

+(void)applyAttributeToLabel:(UILabel *)label atRange:(NSRange )range withAttributes:(NSDictionary *)attributes {
    NSMutableAttributedString *attributeString = [label.attributedText mutableCopy];
    [attributeString addAttributes:attributes range:range];
    label.attributedText = attributeString;
}

+(NSDate *)getDateString:(NSString *)timeStr withFormat:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:timeStr];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];//时差处理
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

@end
