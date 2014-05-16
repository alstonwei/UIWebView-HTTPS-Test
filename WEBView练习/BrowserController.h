//
//  BrowserController.h
//  WEBView练习
//
//  Created by Shouqiang Wei on 14-5-14.
//  Copyright (c) 2014年 Shouqiang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserController : UIViewController
{
    //浏览器
    UIWebView                   *webView;
    //功能栏
    UIView                      *toolBar;
    //功能按钮
    UIButton                    *stopButton;//停止加载
	UIButton                    *previousButton;//后退
	UIButton                    *nextButton;//前进
    UIButton                    *reloadButton;//刷新
    //当前的url
    NSURL *_currenURL;
    NSURLConnection* reUrlConnection;//重发请求
    NSURLRequest* originRequest;
}


@property(nonatomic,assign,getter =isAuthed)BOOL authed;
@property(nonatomic,strong)NSURL *currenURL;
//加载请求
- (void)loadUrl:(NSString *)url;
- (void)loadURLof:(NSURL *)url;
//初始化功能栏
- (void)loadToolBar;
//刷新功能栏按钮
- (void)reflashButtonState;
//创建等待视图
- (void)createLoadingView;
//刷新等待视图
- (void)freshLoadingView:(BOOL)b;


@end
