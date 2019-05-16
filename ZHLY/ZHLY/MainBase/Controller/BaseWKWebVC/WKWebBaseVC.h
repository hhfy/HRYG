//
//  WKWebBaseVC.h
//
//  Created by LTWL on 2017/6/2.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

typedef enum : NSUInteger {
    WebDataTypeUrl = 0,
    WebDataTypeHtml
} WebDataType;

@class WKWebView;
@interface WKWebBaseVC : BaseViewController
/// 类型
@property (nonatomic, assign, readonly) WebDataType webDataType;
/// 执行JS
@property (nonatomic, copy, readonly) NSString *implementJs;
/// 初始标题
@property (nonatomic, copy, readonly) NSString *setupTitle;
/// 初始JS（当网页加载完成后执行）
@property (nonatomic, copy, readonly) NSString *setupJs;
/// 网页的url地址
@property (nonatomic, copy, readonly) NSString *setupUrl;
/// 设置JS传递接受消息名称（需要和前端工作人员约定好）
@property (nonatomic, copy, readonly) NSString *setupJsMsgObjName;
/// 是否开启导航栏滑动效果（默认开启）
@property (nonatomic, assign, readonly) BOOL isCloseNavAnimation;
/// 是否打开rightBarBtn（默认关闭）
@property (nonatomic, assign, readonly) BOOL rightBarBtnIsOpen;
/// 设置请求的参数
- (void)setupParams:(NSMutableDictionary *)params;
/// 链接跳转回调执行方法（子类执行）
- (void)webLinkWithNavigationAction:(WKNavigationAction *)navigationAction;
/// 通过协议介绍js传递的数据方法（子类执行）
- (void)receiveScriptMessage:(WKScriptMessage *)message;
@end
