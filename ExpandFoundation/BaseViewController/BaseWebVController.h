/*
 *  ExpandFoundation
 *  BaseWebVController.h
 *
 *  Created by apple on 2017/9/7
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 *  描述: <WKWebView>
 *
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

/** webView刷新监听字段 **/
static NSString * const refreshWebView = @"refreshWebView";

typedef NS_ENUM(NSInteger, ResponseStatusCode) {
    ResponseStatusCode_200 = 200,         //链接正常
    ResponseStatusCode_404 = 404,         //链接地址出错
    ResponseStatusCode_500 = 500,         //服务器出错
    ResponseStatusCode_unknow = -1        //未知
};

@interface BaseWebVController : UIViewController

@property(nonatomic,strong)WKWebView *webView;
/** 网页状态响应code **/
@property(nonatomic,assign,readonly)ResponseStatusCode responseStatus;
/** URL string **/
@property(nonatomic,assign)NSString *urlString;
/** 网络是否可用 **/
- (BOOL)connectNetworking;

+ (instancetype)webViewWithTitle:(NSString *)title url:(NSString *)url navigationController:(UINavigationController *)controller;

@end
