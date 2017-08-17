/*
 *  ExpandFoundation
 *  NSString+URLExtension.h
 *
 *  Created by apple on 2017/8/14
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */



#import <Foundation/Foundation.h>

@interface NSString (URLExtension)

/** 截取URL中的参数 **/
@property(nonatomic,readonly)NSString *getURLParameters;
/** url enCode **/
@property(nonatomic,readonly)NSString *urlEncodedString;
/** url deCode **/
@property(nonatomic,readonly)NSString *urlDecodedString;

/**
 将NSDictionary转换为NSString

 @param parameters 参数字典
 @return 转换后的NSString
 */
+ (NSString *)URLqueryStringForParameters:(NSDictionary<NSString *, id> *)parameters;

/**
 获取URL参数获取，转换为NSDictionary

 @return 转换后的NSDictionary
 */
- (NSDictionary<NSString *, NSString *> *)URLQueryParameters;

@end
