/*
 *  ExpandFoundation
 *  NSString+Extensions.h
 *
 *  Created by apple on 2017/8/14
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#define FormatString(args...) [NSString stringWithFormat:args]

@interface NSString (Extensions)

/** 去掉两端的空格 **/
@property(nonatomic,readonly)NSString *clearLeadingTrailingSpace;
/** 去掉多余的空格 **/
@property(nonatomic,readonly)NSString *clearAllSpace;
/** 是否为空 **/
@property(nonatomic,readonly)BOOL isNotNilOrWhiteSpace;
/** 是否为数字 **/
@property(nonatomic,readonly)BOOL isNumbers;
/** 是否为字母 或者 数字 **/
@property(nonatomic,readonly)BOOL isAlphabetOrNumbers;
/** 是否为邮箱 **/
@property(nonatomic,readonly)BOOL isChinesePhoneNumber;
/** 是否为手机号 **/
@property(nonatomic,readonly)BOOL isValidEmail;
/** 是否为身份证号 **/
@property(nonatomic,readonly)BOOL isIDCard;
/** 是否为银行卡号 **/
@property(nonatomic,readonly)BOOL isBankCard;
/** 账号以字母，下划线开头 后边是数组 **/
@property(nonatomic,readonly)BOOL isAccount;
/** 验证码为6位数字 **/
@property(nonatomic,readonly)BOOL isPhoneCode;

#pragma mark - 数据转换

/**
 去掉两端的空格

 @return 格式化后的string
 */
- (NSString *)clearLeadingTrailingSpace;

/**
 去掉多余的空格
 
 @return 格式化后的string
 */
- (NSString *)clearAllSpace;

#pragma mark - 将对象转换为json的字符串

/**
 将NSDictionary数据转换为json字符串
 
 @param dictionary 字典格式
 @return json字符串
 */
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;

/**
 将NSArray数据转换为json字符串
 
 @param array 数组格式
 @return json字符串
 */
+ (NSString *)jsonStringWithArray:(NSArray *)array;

/**
 将NSString数据转换为json字符串
 
 @param string 字符串格式
 @return json字符串
 */
+ (NSString *)jsonStringWithString:(NSString *)string;

/**
 将一个对象数据转换为json字符串
 
 @param object 任意格式对象
 @return json字符串
 */
+ (NSString *)jsonStringWithObject:(id)object;

#pragma mark - 手机号，银行卡，格式化

/**
 格式化11位手机号 显示为“135****7263”
 
 @return 格式化后的电话号码
 */
- (NSString *)dealWithPhoneNumber;


/**
 格式化 银行卡号 显示为“6122 **** **** 1234”
 
 @return 式化后的银行号码
 */
- (NSString *)dealWithBankCardNumber;

/**
 格式化 银行卡号 显示为“6122 **** **** **** 1234” 
                   “6122 **** **** **** 123”
 
 @return 格式化后的银行号码
 */
- (NSString *)getBankNumberStar;

@end
