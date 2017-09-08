//
//  ViewController.m
//  ExpandFoundation
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 zoufuqiang. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "TestObject.h"
#import "MyTestObject.h"
#import "TempVController.h"
#import "BaseWebVController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TestObject *testObj = [[TestObject alloc]init];
    
    SEL tester = @selector(clogText:);
    SEL notlmpSelector = @selector(testAction);
    
    if ([testObj respondsToSelector:tester]) {
        [testObj clogText:@"有此方法"];
    }
    
    if ([testObj respondsToSelector:notlmpSelector]) {
        [testObj testAction];
    }
    
    BOOL conformP1 = [testObj conformsToProtocol:@protocol(TestObjectProtocol)];
    BOOL conformC1 = class_conformsToProtocol([TestObject class], @protocol(TestObjectProtocol));
    
    NSLog(@"是否实现协议p1 --- %zd  conformC1 -- %zd",conformP1,conformC1);
    
    MyTestObject *myTest = [[MyTestObject alloc]init];
    BOOL conformP2 = [myTest conformsToProtocol:@protocol(TestObjectProtocol)];
    
    NSLog(@"是否实现协议p2 --- %zd",conformP2);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 70, 200, 40);
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(presentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)presentAction
{
    [BaseWebVController webViewWithTitle:@"sad" url:@"http://www.cnblogs.com/Mr-Ygs/p/6061869.html" navigationController:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
