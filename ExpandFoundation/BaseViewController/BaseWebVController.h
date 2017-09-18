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

typedef void (^WebViewConfigBlock)(WKWebView *webView);

@interface BaseWebVController : UIViewController

@property(nonatomic,strong)WKWebView *webView;
/** html response status code **/
@property(nonatomic,assign,readonly)ResponseStatusCode responseStatus;
/** URL string. need setup urlString's value **/
@property(nonatomic,assign)NSString *urlString;
/** push back item imageName. need setup pushImageNam's value **/
@property(nonatomic,copy)NSString *pushImageName;
/** present close item imageName need setup closeImageName's value **/
@property(nonatomic,copy)NSString *closeImageName;
/** network can connect internet **/
- (BOOL)connectNetworking;

+ (instancetype)webViewWithTitle:(NSString *)title
                             url:(NSString *)url
                   pushImageName:(NSString *)pushImageName
                  closeImageName:(NSString *)closeImageName
            navigationController:(UINavigationController *)controller
                   webViewConfig:(WebViewConfigBlock)configureation;

@end
