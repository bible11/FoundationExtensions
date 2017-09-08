/*
 *  ExpandFoundation
 *  TestObject.h
 *
 *  Created by apple on 2017/9/7
 *    Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 *  描述: <描述>
 *
 */

#import <Foundation/Foundation.h>

@protocol TestObjectProtocol <NSObject>

- (void)doSomething;

@end

@interface TestObject : NSObject <TestObjectProtocol>

//@property(nonatomic,copy)

- (void)testAction;

- (void)clogText:(NSString *)text;

@end


