//
//  BrowserController.m
//  WEBView练习
//
//  Created by Shouqiang Wei on 14-5-14.
//  Copyright (c) 2014年 Shouqiang Wei. All rights reserved.
//

#import "BrowserController.h"
#import "MBProgressHUD.h"
//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//导航栏高度
#define NAVIGATION_BAR_HEIGHT 44.0f
//状态栏高度
#define STATUS_BAR_HEIGHT 20.0f
//工具栏高度
#define TOOL_BAR_HEIGHT 30
#define HTTPS @"https"


@interface BrowserController ()<UIWebViewDelegate,MBProgressHUDDelegate,NSURLConnectionDelegate>
{
    MBProgressHUD*  hub;
}

@end

@implementation BrowserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];

    if (webView == nil)
    {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - 30)];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
    }

    if(!toolBar)
    {
        [self loadToolBar];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor purpleColor]];
    if ([self respondsToSelector:@selector(setEdgeAntialiasingMask:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(homeAction:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;

    [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
    if(_currenURL)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:_currenURL];
        [webView loadRequest:request];
    }

}


-(void)homeAction:(UIButton*)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Description: 加载功能栏
 * Input:
 * Output:
 * Return:
 * Others:
 */
- (void)loadToolBar
{
    float toolY = SCREEN_HEIGHT - 30;
    toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0,toolY , 320.0, 30.0)];
    toolBar.backgroundColor = [UIColor orangeColor];

    //webView images
    UIImage *stopImg = [UIImage imageNamed:@"stopButton.png"];
    UIImage *nextImg = [UIImage imageNamed:@"nextButtonWeb.png"];
    UIImage *previousdImg =[UIImage imageNamed:@"previousButton.png"];
    UIImage *reloadImg =[UIImage imageNamed:@"reloadButton.png"];

    //功能按钮
    stopButton = [[UIButton alloc]initWithFrame:CGRectMake(44.0, 3.0, 24.0, 24.0)];
    [stopButton setImage:stopImg forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopWebView:) forControlEvents:UIControlEventTouchUpInside];

    previousButton = [[UIButton alloc]initWithFrame:CGRectMake(112.0, 3.0, 24.0, 24.0)];
    [previousButton setImage:previousdImg forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    nextButton = [[UIButton alloc]initWithFrame:CGRectMake(180.0, 3.0, 24.0, 24.0)];
    [nextButton setImage:nextImg forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];

    reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(248.0, 3.0, 24.0, 24.0)];
    [reloadButton setImage:reloadImg forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];

    [toolBar addSubview:stopButton];
    [toolBar addSubview:previousButton];
    [toolBar addSubview:nextButton];
    [toolBar addSubview:reloadButton];

    [self.view addSubview:toolBar];

}

-(void)createLoadingView
{

    UIView* v = [UIApplication sharedApplication].keyWindow;
    hub = [[MBProgressHUD alloc] initWithView:v];
    hub.delegate = self;
    hub.removeFromSuperViewOnHide = YES;
	hub.labelText = @"加载中...";
    [v addSubview:hub];
    //这个地方得注意一下，设置hub 的frame的view 必须和 要添加hub 的view 一致，不然他妈的崩溃的一塌糊涂。
}

-(void)freshLoadingView:(BOOL)b
{
    if (b) {
        [hub show:YES];
        [hub hide:YES afterDelay:3];
    }
    else{
        [hub hide:YES];
    }

}


- (void)exitBrowser:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - webView actions

- (void)back:(id)sender
{
    if (webView.canGoBack)
    {
        [webView goBack];
    }
}

- (void)reload:(id)sender
{
    [webView reload];
    [self freshLoadingView:YES];
}

- (void)forward:(id)sender
{
    if (webView.canGoForward)
    {
        [webView goForward];
    }
}

- (void)stopWebView:(id)sender
{
	[webView stopLoading];
}

- (void)loadUrl:(NSString *)url
{
    if (webView)
    {
        url = [url stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

        [webView loadRequest:request];
    }
}

- (void)loadURLof:(NSURL *)url
{
    self.currenURL = url;
}

- (void)reflashButtonState
{
    if (webView.canGoBack)
    {
        previousButton.enabled = YES;
    }
    else
    {
        previousButton.enabled = NO;
    }

    if (webView.canGoForward)
    {
        nextButton.enabled = YES;
    }
    else
    {
        nextButton.enabled = NO;
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [[request URL] scheme];
    NSLog(@"scheme = %@",scheme);
    //判断是不是https
    if ([scheme isEqualToString:HTTPS]) {
         //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [awebView stopLoading];
            return NO;
        }
    }

    [self reflashButtonState];
    [self freshLoadingView:YES];

    NSURL *theUrl = [request URL];
    self.currenURL = theUrl;
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self reflashButtonState];
    [self freshLoadingView:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self reflashButtonState];
    [self freshLoadingView:NO];
}

#pragma mark ================= NSURLConnectionDelegate <NSObject>

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{

    return YES;
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{

    if ([challenge previousFailureCount]== 0) {
        _authed = YES;

        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
    else
    {
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }

}

// Deprecated authentication delegates.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];

    return YES;
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{

    NSLog(@"challenge == %@",challenge);

//    if (([challenge.protectionSpace.authenticationMethod
//          isEqualToString:NSURLAuthenticationMethodServerTrust])) {
//        if ([challenge.protectionSpace.host isEqualToString:@"111.200.87.69:8443/ccard"]) {
//            NSLog(@"Allowing bypass...");
//            NSURLCredential *credential = [NSURLCredential credentialForTrust:
//                                           challenge.protectionSpace.serverTrust];
//            [challenge.sender useCredential:credential
//                 forAuthenticationChallenge:challenge];
//        }
//    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];

}
- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{

    
}


#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{

    NSLog(@"%@",request);
    return request;
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    self.authed = YES;
    //webview 重新加载请求。
    [webView loadRequest:originRequest];
    [connection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

}

#pragma mark =================MBProgressHUDDelegate==================

/**
 * Called after the HUD was fully hidden from the screen.
 */
- (void)hudWasHidden:(MBProgressHUD *)progress
{

    //[progress removeFromSuperview];
}


@end
