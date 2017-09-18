/*
 *  ExpandFoundation
 *  BaseWebVController.m
 *
 *  Created by apple on 2017/9/7
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 *  描述: <WKWebView>
 *
 */

/** 设备宽带 **/
#define screenWidth [UIScreen mainScreen].bounds.size.width

#import "BaseWebVController.h"
#import <Reachability/Reachability.h>
#import "NSString+URLExtension.h"

static NSString * const estimatedProgress = @"estimatedProgress";
static NSString * const title = @"title";
static NSString * const javaScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); document.getElementsByTagName('head')[0].appendChild(meta);";

@interface BaseWebVController () <WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

@property(nonatomic,assign)ResponseStatusCode responseStatus;
@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)UIBarButtonItem *backItem;
@property(nonatomic,strong)UIBarButtonItem *closeItem;
@property(nonatomic,copy)WebViewConfigBlock webViewConfig;

@end

@implementation BaseWebVController

#pragma mark - Initialization

+ (instancetype)webViewWithTitle:(NSString *)title
                             url:(NSString *)url
                   pushImageName:(NSString *)pushImageName
                  closeImageName:(NSString *)closeImageName
            navigationController:(UINavigationController *)controller
                   webViewConfig:(WebViewConfigBlock)configureation
{
    BaseWebVController *webController = [[self alloc] init];
    webController.title = title;
    webController.urlString = url;
    webController.pushImageName = pushImageName;
    webController.closeImageName = closeImageName;
    [controller pushViewController:webController animated:YES];
    
    __weak typeof(webController) weakWebController = webController;
    if (configureation) {
        weakWebController.webViewConfig = configureation;
    }
    
    return webController;
}

#pragma mark - Getter

- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        NSAssert(self.pushImageName != nil, @"pushImageName不能为nil");
        _backItem = [self createItemWithImage:[UIImage imageNamed:self.pushImageName]
                                       action:@selector(customNavbackItemDidPressed)];
        _backItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (_closeItem == nil) {
        NSAssert(self.closeImageName != nil, @"closeImageName不能为nil");
        _closeItem = [self createItemWithImage:[UIImage imageNamed:self.closeImageName]
                                        action:@selector(customNavCloseItemDidPressed)];
        _closeItem.imageInsets = UIEdgeInsetsMake(0, -28, 0, 0);
    }
    return _closeItem;
}

#pragma mark - Setter
/** 服务器返回状态 **/
- (void)setResponseStatus:(ResponseStatusCode)responseStatus
{
    _responseStatus = responseStatus;
    
    NSString *path = nil;
    switch (responseStatus) {
        case ResponseStatusCode_200:
            break;
        case ResponseStatusCode_404:
        {
            path = [[NSBundle mainBundle] pathForResource:@"404" ofType:@"html"];
            [self loadLocalHtmlWithUrl:path];
        }
            break;
        case ResponseStatusCode_500:
        {
            path = [[NSBundle mainBundle] pathForResource:@"500" ofType:@"html"];
            [self loadLocalHtmlWithUrl:path];
        }
            break;
        default:
        {
            path = [[NSBundle mainBundle] pathForResource:@"req_err" ofType:@"html"];
            [self loadLocalHtmlWithUrl:path];
        }
            break;
    }
}

/** 设置请求urlString **/
- (void)setUrlString:(NSString *)urlString
{
    if (_urlString == urlString) {
        return;
    }
    _urlString = urlString;
}

#pragma mark - OverWrite

- (void)dealloc
{
    NSLog(@"dealloced => %@",NSStringFromClass([self class]));
    [self.webView removeObserver:self forKeyPath:estimatedProgress];
    [self.webView removeObserver:self forKeyPath:title];
}

#pragma mark - Public Method

- (BOOL)connectNetworking
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            return NO;
        default:
            return YES;
    }
}

#pragma mark - Private Method
//webView初始化
- (void)_configurationWebView
{
    if (self.webView == nil) {
        //WKWebView配置
        WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc]init];
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:javaScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc]init];
        //添加屏幕适配，让它不拉动
        [wkUController addUserScript:wkUScript];
        //添加JS调用OC的方法 --- 刷新界面
        [wkUController addScriptMessageHandler:self name:refreshWebView];
        webViewConfiguration.userContentController = wkUController;
        
        self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:webViewConfiguration];
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        self.webView.allowsBackForwardNavigationGestures = YES;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        self.webView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:self.webView];
        
        //configuration webView
        if (self.webViewConfig) {
            self.webViewConfig(self.webView);
        }
        
        //创建进度条UI
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
        self.progressView.progressTintColor = [UIColor orangeColor];
        self.progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:self.progressView];
        //将进度条显示在self.view的最上层
        [self.view insertSubview:self.webView belowSubview:self.progressView];
        
        //监听html的title属性
        [self.webView addObserver:self forKeyPath:title options:NSKeyValueObservingOptionNew context:nil];
        //添加进度条监听
        [self.webView addObserver:self forKeyPath:estimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    }
}

//加载本地网页
- (void)loadLocalHtmlWithUrl:(NSString *)urlPath
{
    NSAssert(urlPath != nil, @"urlPath不能为nil");
    NSURLRequest *url = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:urlPath]];
    [self.webView loadRequest:url];
}

//加载URL
- (void)loadRequestUrl:(NSString *)urlString
{
    NSAssert(urlString != nil, @"urlString不能为nil");
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

//自定义UIBarButtonItem
- (UIBarButtonItem *)createItemWithImage:(UIImage *)image action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithImage:image
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:action];
}

//自定义导航栏 返回按钮
- (void)resetupNavbackItemsForWebView:(WKWebView *)webView animated:(BOOL)animated
{
    BOOL showCloseItem = webView.canGoBack;
    if (showCloseItem && self.navigationItem.leftBarButtonItems.count == 2) {
        return;
    }
    
    if (!showCloseItem && self.navigationItem.leftBarButtonItems.count == 1) {
        return;
    }
    
    if (!showCloseItem) {
        [self.navigationItem setLeftBarButtonItems:@[self.backItem] animated:animated];
        return;
    }
    
    //closeItem
    [self.navigationItem setLeftBarButtonItems:@[self.backItem, self.closeItem] animated:animated];
}

//back item action
- (void)customNavbackItemDidPressed
{
    BOOL cangoBack = self.webView.canGoBack;
    if (cangoBack) {
        [self.webView goBack];
    } else {
        [self customNavCloseItemDidPressed];
    }
}

//jump to viewController type [self.navigationController push] or [self presentViewController]
- (void)customNavCloseItemDidPressed
{
    if (self.navigationController != nil && self.navigationController.viewControllers.firstObject != self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIViewController *controller = (self.navigationController ?: self);
        [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    NSLog(@"%s",__func__);
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _configurationWebView];
    
    if (self.urlString) {
        [self loadRequestUrl:self.urlString];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //移除JS调用OC的方法 --- 刷新界面 (防止循环引用导致内存不能释放)
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:refreshWebView];
}

#pragma mark - All Delegate

#pragma mark - WKScriptMessageHandler
//从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //刷新webView
    if ([message.name isEqualToString:refreshWebView]) {
        [self loadRequestUrl:self.urlString];
    }
}

#pragma mark - WKNavigationDelegate

/* 1.在发送请求之前，决定是否跳转
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
 {
 decisionHandler(WKNavigationActionPolicyAllow);
 }
 */

// 2.页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s",__func__);
}

// 3.在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"%s",__func__);
    //网络请求返回的状态码
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    
    switch (response.statusCode) {
        case 200:
            self.responseStatus = ResponseStatusCode_200;
            decisionHandler(WKNavigationResponsePolicyAllow);
            break;
        case 404:
            self.responseStatus = ResponseStatusCode_404;
            decisionHandler(WKNavigationResponsePolicyCancel);
            break;
        case 500:
            self.responseStatus = ResponseStatusCode_500;
            decisionHandler(WKNavigationResponsePolicyCancel);
            break;
        default:
            self.responseStatus = ResponseStatusCode_unknow;
            decisionHandler(WKNavigationResponsePolicyCancel);
            break;
    }
}

// 4.开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s",__func__);
}

// 5.页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s",__func__);
    [self resetupNavbackItemsForWebView:webView animated:NO];
}

// 加载失败之后调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s",__func__);
    self.responseStatus = ResponseStatusCode_unknow;
}

/* 需要响应身份验证时调用 同样在block中需要传入用户身份凭证
 - (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
 {
 NSURLCredential *newCred = [NSURLCredential credentialWithUser:@""
 password:@""
 persistence:NSURLCredentialPersistenceNone];
 // 为 challenge 的发送方提供 credential
 [[challenge sender] useCredential:newCred forAuthenticationChallenge:challenge];
 completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
 }
 */

#pragma mark - Observer
// 进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:estimatedProgress]) {
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
        
    } else if (object == self.webView && [keyPath isEqualToString:title]) {
        self.title = self.webView.title;
    }
}

#pragma mark - UIDelegate
// 警告框，页面中有调用JS的 alert 方法就会调用该方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    completionHandler();
}


@end
