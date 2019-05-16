//
//  WKWebBaseVC.m
//
//  Created by LTWL on 2017/6/2.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "WKWebBaseVC.h"
#import <objc/runtime.h>

@interface WKWebBaseVC () <WKNavigationDelegate, UIScrollViewDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIView *loaddingView;
@property (nonatomic, assign) CGFloat lastcontentOffset;
@property (nonatomic, strong) NoDataVIew *noDataView;
@end

@implementation WKWebBaseVC

#pragma mark - 懒加载
- (UIProgressView *)progressView
{
    if (_progressView == nil)
    {
        CGRect navBounds = self.navigationController.navigationBar.bounds;
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, navBounds.size.height, MainScreenSize.width, 2)];
        _progressView.progressTintColor = MainThemeColor;
        _progressView.trackTintColor = [UIColor clearColor];
        [self.navigationController.navigationBar addSubview:_progressView];
    }
    return _progressView;
}

- (WKWebView *)wkWebView
{
    if (_wkWebView == nil)
    {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc]init];
        config.userContentController = [[WKUserContentController alloc] init];
        config.selectionGranularity = WKSelectionGranularityCharacter;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        [config.userContentController addScriptMessageHandler:self name:self.setupJsMsgObjName];
        config.preferences.javaScriptEnabled = YES;
        CGRect WebViewF = (!self.isCloseNavAnimation) ? CGRectMake(0, -(NavHFit), self.view.width, MainScreenSize.height) : CGRectMake(0, 0, self.view.width, self.view.height - (NavHFit));
        _wkWebView = [[WKWebView alloc] initWithFrame:WebViewF configuration:config];
        if (!self.isCloseNavAnimation) _wkWebView.scrollView.contentInset = UIEdgeInsetsMake((NavHFit), 0, 0, 0);
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.delegate = self;
        [self progressView];
        [self.view addSubview:_wkWebView];
        [LaiMethod setupDownRefreshWithScrollView:_wkWebView.scrollView target:self action:@selector(getRequstData)];
    }
    return _wkWebView;
}

- (UIView *)loaddingView
{
    if (_loaddingView == nil) {
    _loaddingView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_loaddingView.layer addSublayer:[LaiCAAnimatonLibTool generateActivityIndicatorLayerWithAnimationType:17 size:CGSizeMake(60, 30) tintColor:MainThemeColor superView:_loaddingView]];
        [self.wkWebView addSubview:_loaddingView];
    }
    return _loaddingView;
}


- (NoDataVIew *)noDataView
{
    if (_noDataView == nil)
    {
        _noDataView = [NoDataVIew viewFromXib];
        _noDataView.hidden = YES;
        [self.wkWebView addSubview:_noDataView];
    }
    return _noDataView;
}

#pragma mark - 控制器加载
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if(self.rightBarBtnIsOpen){
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightAction) title:ShoppingCarIconUnicode nomalColor:SetupColor(89, 93, 116) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(25) top:0 left:0 bottom:0 right:0];
    }
}

-(void)rightAction {
    [LaiMethod runtimePushVcName:@"HomeShoppingCarVC" dic:nil nav:CurrentViewController.navigationController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.wkWebView stopLoading];
    [self.progressView removeFromSuperview];
    self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addKVO];
    [self setupValue];
    [self progressWKContentViewCrash];
    [self getRequstData];
    [self noDataView];
}

- (void)setupValue {
    self.title = self.setupTitle;
    [self loaddingView];
}

- (void)getRequstData {
    switch (self.webDataType) {
        case WebDataTypeUrl:
        {
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self setupUrl]]]];
        }
            break;
        case WebDataTypeHtml:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [self setupParams:params];
            WeakSelf(weakSelf)
            [HttpTool getWithURL:self.setupUrl params:params isHiddeHUD:YES progress:nil success:^(id json) {
                [weakSelf.wkWebView loadHTMLString:json[Data][@"content"] baseURL:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:WKWebBaseVCGetDataNotification object:nil userInfo:@{@"json": json}];
            } otherCase:^(NSInteger code) {
                
            } failure:^(NSError *error) {
                weakSelf.noDataView.hidden = NO;
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - KVO
- (void)addKVO {
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    self.progressView.progress = self.wkWebView.estimatedProgress;
    self.progressView.hidden = (self.wkWebView.estimatedProgress >= 1.0);
}

#pragma mark - WKNavigationDelegate
// 解决<a>herf = "url" </a>不能跳转的问题
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) [webView loadRequest:navigationAction.request];
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self webLinkWithNavigationAction:navigationAction];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 当网页加载完成的时候调用JS
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.wkWebView evaluateJavaScript:[self setupJs] completionHandler:nil];
    [self.loaddingView removeFromSuperview];
    [self.wkWebView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.noDataView.hidden = NO;
    [self.loaddingView removeFromSuperview];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull类型
    if ([message.name isEqualToString:self.setupJsMsgObjName]) [self receiveScriptMessage:message];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isCloseNavAnimation) return;
    WeakSelf(weakSelf)
    if (scrollView.contentOffset.y <= -NavHeight) {
        [UIView animateWithDuration:KeyboradDuration animations:^{
            weakSelf.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.isCloseNavAnimation) return;
    CGFloat hight = scrollView.frame.size.height;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
    CGFloat offset = contentOffset - self.lastcontentOffset;
    self.lastcontentOffset = contentOffset;
    
    WeakSelf(weakSelf)
    if (offset > 0 && contentOffset > 0) { // 上拉
        [UIView animateWithDuration:KeyboradDuration animations:^{
            weakSelf.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -((iPhoneX) ? NavHeightIphoneX : NavHeight));
        }];
    } else if (offset < 0 && distanceFromBottom > hight) {  // 下拉
        [UIView animateWithDuration:KeyboradDuration animations:^{
            weakSelf.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - 当赋予implementJs字符串的js代码的时候就会在当前调用JS桥接
- (void)setImplementJs:(NSString *)implementJs {
    _implementJs = [implementJs copy];
    [self.wkWebView evaluateJavaScript:implementJs completionHandler:nil];
}

#pragma mark - 执行空的声明方法，用来在子类里面重写
- (void)setupParams:(NSMutableDictionary *)params {}
- (void)webLinkWithNavigationAction:(WKNavigationAction *)navigationAction {}
- (void)receiveScriptMessage:(WKScriptMessage *)message{}

#pragma mark - dealloc
- (void)dealloc {
    self.wkWebView.navigationDelegate = nil;
    [self.wkWebView stopLoading];
    self.wkWebView.UIDelegate = nil;
    self.wkWebView.navigationDelegate = nil;
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - runtime解决WKContentView没有isSecureTextEntry方法造成的crash
/**
 处理WKContentView的crash
 [WKContentView isSecureTextEntry]: unrecognized selector sent to instance 0x101bd5000
 */
- (void)progressWKContentViewCrash {
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)) {
        const char *className = @"WKContentView".UTF8String;
        Class WKContentViewClass = objc_getClass(className);
        SEL isSecureTextEntry = NSSelectorFromString(@"isSecureTextEntry");
        SEL secureTextEntry = NSSelectorFromString(@"secureTextEntry");
        BOOL addIsSecureTextEntry = class_addMethod(WKContentViewClass, isSecureTextEntry, (IMP)isSecureTextEntryIMP, "B@:");
        BOOL addSecureTextEntry = class_addMethod(WKContentViewClass, secureTextEntry, (IMP)secureTextEntryIMP, "B@:");
        if (!addIsSecureTextEntry || !addSecureTextEntry) {
            Log(@"WKContentView-Crash->修复失败");
        }
    }
}

/**
 实现WKContentView对象isSecureTextEntry方法
 @return NO
 */
BOOL isSecureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

/**
 实现WKContentView对象secureTextEntry方法
 @return NO
 */
BOOL secureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}
@end
