
//
//  SystemContentViewController.m
//  WKWebViewDemo
//
//  Created by Yonger on 2018/9/28.
//  Copyright © 2018年 hcjj. All rights reserved.
//

#import "SystemContentViewController.h"
#import "NewestMainPageFooterView.h"
#import "MainPageProgressView.h"
#import "SystemNetworkDisconnectView.h"
#import "UIDevice+DeviceModel.h"
#define kProgressHeight     6.0f
#define iPhoneType [UIDevice_DeviceModel  deviceModel]
@interface SystemContentViewController ()<WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate,NewestMainPageFooterViewDelegate>

{
    WKWebView *kWKWebView;
    NewestMainPageFooterView *contentBottomView;
    AFNetworkReachabilityStatus networkStatus;
}

@property (nonatomic,strong) MainPageProgressView *progressView;
@property (nonatomic,strong) SystemNetworkDisconnectView *networkDisconnectView;

@end

@implementation SystemContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    contentBottomView = [[NewestMainPageFooterView alloc] initWithFrame:CGRectMake(0, ConfigHeight - ConfigTabBarHeight, ConfigWidth, ConfigTabBarHeight)];
    contentBottomView.delegate = self;
    contentBottomView.backgroundColor =  [UIColor  blackColor];
    NSMutableString *javascript = [[NSMutableString alloc] initWithString:@"document.documentElement.style.webkitTouchCallout='none';document.documentElement.style.webkitUserSelect='none';"];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [userContentController addUserScript:script];
    
    WKProcessPool *processPool = [[WKProcessPool alloc] init];
    WKWebViewConfiguration *webViewController = [[WKWebViewConfiguration alloc] init];
    webViewController.processPool = processPool;
    webViewController.allowsInlineMediaPlayback = YES;
    webViewController.userContentController = userContentController;
    NSLog(@"》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉oooooooo%@",iPhoneType);
    if ([iPhoneType isEqualToString:@"iPhone X"] || [iPhoneType isEqualToString:@"iPhone XS"] ) {
        
         kWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, cStatusBarHeight, self.view.frame.size.width, ConfigHeight - cStatusBarHeight - 20) configuration:webViewController];
        
    }else if ([iPhoneType isEqualToString:@"iPhone XR"] || [iPhoneType isEqualToString:@"iPhone XSM"])
    {
           kWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, cStatusBarHeight, self.view.frame.size.width, ConfigHeight - cStatusBarHeight - 40) configuration:webViewController];
             NSLog(@"===============>>>>>>>>>>>>>>>>>>>>%@",[UIDevice_DeviceModel  deviceModel]);
    }else
    {
        kWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, cStatusBarHeight, self.view.frame.size.width, ConfigHeight - cStatusBarHeight) configuration:webViewController];
    }
    
   
    kWKWebView.UIDelegate = self;
    kWKWebView.navigationDelegate = self;
    kWKWebView.allowsBackForwardNavigationGestures = YES;
    kWKWebView.allowsLinkPreview = NO;
    
    
    [self.view addSubview:contentBottomView];
    [self.view addSubview:kWKWebView];
    if (@available(iOS 11,*)) {
        kWKWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [kWKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressGestureRecognizerAction:)];
    longPressGes.delegate = self;
    longPressGes.minimumPressDuration = 0.25;
    [kWKWebView addGestureRecognizer:longPressGes];
    
    networkStatus = [AppDelegate sharedDelegate].networkStatus;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == kWKWebView) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat newValue = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            if (newValue == 1) {
                self.progressView.hidden = YES;
                self.progressView.frame  = CGRectMake(-kProgressHeight, self.progressView.frame.origin.y, kProgressHeight, kProgressHeight);
            }else{
                self.progressView.hidden = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    self.progressView.frame = CGRectMake(-kProgressHeight, self.progressView.frame.origin.y, (ConfigWidth+kProgressHeight)*newValue, kProgressHeight);
                }];
            }
        }
    }
}

- (void)loadMainPageContent{
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [kWKWebView loadRequest:request];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)pressGestureRecognizerAction:(UIGestureRecognizer*)ges{
    CGPoint point = [ges locationInView:kWKWebView];
    NSString *jsStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src",point.x,point.y];
    
    [kWKWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSString *imageUrlStr = (NSString*)obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([imageUrlStr length] > 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertController addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrlStr]
                                                                          options:SDWebImageDownloaderHighPriority
                                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                                                        }];
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
        });
    }];
}

- (MainPageProgressView*)progressView{
    if (_progressView == nil) {
        _progressView = [[MainPageProgressView alloc] initWithFrame:CGRectMake(-kProgressHeight, hConfigNaviBarHeight, kProgressHeight, kProgressHeight)];
        _progressView.layer.cornerRadius  = kProgressHeight*0.5;
        _progressView.layer.masksToBounds = YES;
        [self.view addSubview:_progressView];
    }
    [self.view bringSubviewToFront:_progressView];
    return _progressView;
}

- (SystemNetworkDisconnectView*)networkDisconnectView{
    if (_networkDisconnectView == nil) {
        _networkDisconnectView = [[SystemNetworkDisconnectView alloc] initWithFrame:CGRectMake(0, 0, ConfigWidth, ConfigHeight)];
        [self.view addSubview:_networkDisconnectView];
    }
    [_networkDisconnectView resetDisconnectViewContent];
    [self.view bringSubviewToFront:_networkDisconnectView];
    
    return _networkDisconnectView;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"图片保存失败，无法访问相册" message:@"请在“设置>隐私>照片”打开相册访问权限" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)mainPageFooterIteDidClicked:(NewestMainPageFooterStyle)style{
    switch (style) {
        case NewestMainPageFooterBack:
        {
            if ([self currentLoadContentIsNill]) {
                [self loadMainPageContent];
            }else{
                if ([kWKWebView canGoBack]) {
                    [kWKWebView goBack];
                }
            }
        }
            break;
        case NewestMainPageFooterGoForward:
        {
            if ([self currentLoadContentIsNill]) {
                [self loadMainPageContent];
            }else{
                if ([kWKWebView canGoForward]) {
                    [kWKWebView goForward];
                }
            }
        }
            break;
        case NewestMainPageFooterRefresh:
        {
            if ([self currentLoadContentIsNill]) {
                [self loadMainPageContent];
            }else{
                [kWKWebView reload];
            }
        }
            break;
        case NewestMainPageFooterHome:
        {
            if (kWKWebView.backForwardList != nil && kWKWebView.backForwardList.backList.count > 0) {
                [kWKWebView goToBackForwardListItem:[kWKWebView.backForwardList.backList firstObject]];
            }else{
                [self loadMainPageContent];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGFloat height  = DeviceIsPortrait?ConfigTabBarHeight:hConfigNaviBarHeight;
    CGFloat originY = DeviceIsPortrait?(ConfigHeight - height):ConfigHeight;
    contentBottomView.frame = CGRectMake(0, originY, ConfigWidth, height);
    [self resetContentWebFrame];
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        self.networkDisconnectView.hidden = NO;
    }else{
        if (_networkDisconnectView)_networkDisconnectView.hidden = YES;
    }
    
    if (_networkDisconnectView) {
        _networkDisconnectView.frame = CGRectMake(0, 0, ConfigWidth, ConfigHeight);
    }
}

- (void)resetContentWebFrame{
    CGFloat originY = DeviceIsPortrait?(iPhoneX?(cStatusBarHeight-10):cStatusBarHeight):0;
    CGFloat height  = contentBottomView.frame.origin.y - originY;
    
    if (_progressView) {
        _progressView.frame = CGRectMake(-kProgressHeight, originY, _progressView.frame.size.width, kProgressHeight);
    }
    
    //kWKWebView.frame = CGRectMake(0, originY, ConfigWidth, height);
    kWKWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    kWKWebView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL)currentLoadContentIsNill{
    NSString *urlStr = [kWKWebView.URL absoluteString];
    if (urlStr == nil || [urlStr blankString])return YES;
    return NO;
}

- (void)networkStatusDidChanged:(NSNotification*)info{
    NSDictionary *inforDict = [info userInfo];
    if (inforDict) {
        NSString *statusStr = [SharedSystemModel getStringFrom:inforDict key:AFNetworkingReachabilityNotificationStatusItem];
        if (statusStr == nil || [statusStr blankString]) {
            statusStr = [SharedSystemModel getStringFrom:inforDict key:@"LCNetworkingReachabilityNotificationStatusItem"];
        }
        NSInteger status   = [statusStr integerValue];
        if (status != networkStatus) {
            networkStatus = status;
            if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
                self.networkDisconnectView.hidden = NO;
            }else{
                if (_networkDisconnectView) {
                    _networkDisconnectView.hidden = YES;
                }
                
                NSURL *url = kWKWebView.URL;
                if (url == nil || [url.absoluteString blankString]) {
                    [self loadMainPageContent];
                }
            }
        }
    }
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark ----------------------------------------------------------- 是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *urlStr = [NSString stringWithFormat:@"%@",navigationAction.request.URL.absoluteString];
    if ([self jumpsToThirdAPP:urlStr]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([urlStr hasPrefix:@"itms"] || [urlStr hasPrefix:@"itunes.apple.com"] ) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"在App Store中打开?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:url];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }else{
            [SVProgressHUD showInfoWithStatus:@"跳转失败"];
        }
    }
    
    NSString *openUseBrowser = @"UseBrowser";
    if ([urlStr hasPrefix:@"my"] || [urlStr rangeOfString:openUseBrowser].location != NSNotFound) {
        NSMutableString *mutableStr=[[NSMutableString alloc]initWithString:urlStr];
        if ([urlStr hasPrefix:@"my"]) {
            [mutableStr deleteCharactersInRange:NSMakeRange(0, 2)];
        }
        if ([mutableStr rangeOfString:openUseBrowser].location != NSNotFound) {
            mutableStr = [mutableStr stringByReplacingOccurrencesOfString:openUseBrowser withString:@""].mutableCopy;
        }
        if ([self jumpsToThirdAPP:mutableStr]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }else{
            NSURL *url = [NSURL URLWithString:mutableStr];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                BOOL canOpen = [[UIApplication sharedApplication] openURL:url];
                if (canOpen == YES) {
                    decisionHandler(WKNavigationActionPolicyCancel);
                    return;
                }
            }
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (BOOL)jumpsToThirdAPP:(NSString *)urlStr{
    if ([urlStr hasPrefix:@"mqq"] ||
        [urlStr hasPrefix:@"weixin"] ||
        [urlStr hasPrefix:@"alipay"]) {
        BOOL success = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]];
        if (success) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }else{
            NSString *appurl = [urlStr hasPrefix:@"alipay"]?@"https://itunes.apple.com/cn/app/%E6%94%AF%E4%BB%98%E5%AE%9D-%E8%AE%A9%E7%94%9F%E6%B4%BB%E6%9B%B4%E7%AE%80%E5%8D%95/id333206289?mt=8":([urlStr hasPrefix:@"weixin"]?@"https://itunes.apple.com/cn/app/%E5%BE%AE%E4%BF%A1/id414478124?mt=8":@"https://itunes.apple.com/cn/app/qq/id444934666?mt=8");
            NSString *title = [urlStr hasPrefix:@"mqq"]?@"QQ":([urlStr hasPrefix:@"weixin"]?@"微信":@"支付宝");
            NSString *titleString = [NSString stringWithFormat:@"该设备未安装%@客户端",title];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:titleString preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
            [controller addAction:[UIAlertAction actionWithTitle:@"立即安装" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:appurl];
                [[UIApplication sharedApplication] openURL:url];
            }]];
            [self presentViewController:controller animated:YES completion:nil];
        }
        return YES;
    }
    
    return NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([self isAppDomain:webView.URL.absoluteString]) {
        NSString *str=str = @"function getRefs() { var oA = document.getElementsByTagName('a');var length = oA.length;var suffix = 'my';for(var i= 0;i<length;i++){var hreff   = oA[i].getAttribute(\"href\");var current = oA[i].getAttribute(\"class\");var mb = hreff.substring(0,suffix.length);if(current == 'appweb' && mb != suffix){oA[i].setAttribute(\"href\", suffix + hreff);}}}getRefs();";
        [kWKWebView evaluateJavaScript:str completionHandler:^(id _Nullable obj, NSError * _Nullable error) {[webView setCustomUserAgent:(NSString*)obj];}];
    }
}

- (BOOL)isAppDomain:(NSString*)string{
    NSString *current = string;
    if ((current == nil || [current blankString]) ||
        (self.urlString == nil || [self.urlString blankString])) {
        return YES;
    }
    
    NSURL *url = [NSURL URLWithString:string];
    NSString *host = [url host];
    if (host == nil || [self.urlString rangeOfString:host].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {completionHandler(YES);}]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){completionHandler(NO);}]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { completionHandler();}]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self currentLoadContentIsNill]) {
        [self loadMainPageContent];
    }
}

- (BOOL)prefersStatusBarHidden{
    return !DeviceIsPortrait;
}
@end
