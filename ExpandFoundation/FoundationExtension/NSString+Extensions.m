/*
 *  ExpandFoundation
 *  NSString+Extensions.m
 *
 *  Created by apple on 2017/8/14
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */


#import "NSString+Extensions.h"

@implementation NSString (Extensions)

#pragma mark - 数据转换

//去掉两端的空格
- (NSString *)clearLeadingTrailingSpace
{
   return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//去掉多余的空格
- (NSString *)clearAllSpace
{
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    
    string = [components componentsJoinedByString:@" "];
    return string;
}

//是否为空
- (BOOL)isNotNilOrWhiteSpace
{
    return (self != nil ? self.clearLeadingTrailingSpace.length > 0: NO);
}

//是否为数字
- (BOOL)isNumbers
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]+$"];
    return [predicate evaluateWithObject:self];
}

//是否为字母 或者 数字
- (BOOL)isAlphabetOrNumbers
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]+$"];
    return [predicate evaluateWithObject:self];
}

//是否为邮箱
- (BOOL)isValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//是否为身份证号
- (BOOL)isIDCard
{
    NSString *regex = @"^(\\d{6})(\\d{4})(\\d{2})(\\d{2})(\\d{3})([0-9]|X)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

//是否为银行卡号
- (BOOL)isBankCard
{
    if(self.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < self.length; i++)
    {
        c = [self characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

//是否为手机号
- (BOOL)isChinesePhoneNumber
{
    NSString *regex = @"^(1[3-9][0-9])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

//账号以字母，下划线开头 后边是数组
- (BOOL)isAccount
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9_]{3,16}$"];
    return [predicate evaluateWithObject:self];
}

//验证码数字，个数
- (BOOL)isPhoneCode
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]{6}$"];
    return [predicate evaluateWithObject:self];
}

#pragma mark - 将对象转换为json的字符串

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary
{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    
    //TODO:需要对 NSDictionary的key进行 a~z的字母排序
    NSArray *sortKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    for (int i=0; i<[sortKeys count]; i++) {
        NSString *name = [sortKeys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
    
    return nil;
}

+ (NSString *)jsonStringWithArray:(NSArray *)array
{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+ (NSString *)jsonStringWithString:(NSString *)string
{
    NSString *value = [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    return [NSString stringWithFormat:@"\"%@\"",value];
}

+ (NSString *)jsonStringWithObject:(id)object
{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

#pragma mark - 手机号，银行卡，格式化

//格式化11位手机号 显示为“135****7263”
- (NSString *)dealWithPhoneNumber
{
    if (self.length != 11) {
        return self;
    }
    
    NSString *str = nil;
    if (self.length == 11) {
        str = [self substringWithRange:NSMakeRange(3, 4)];
        str = [self stringByReplacingOccurrencesOfString:str withString:@"****"];
    }
    return str;
}

//格式化 银行卡号 显示为“6122 **** **** 1234”
- (NSString *)dealWithBankCardNumber
{
    if (self.length == 0) {
        return @"";
    }
    //头部
    NSString *headString = [self substringWithRange:NSMakeRange(0, 4)];
    //尾部
    NSString *footString = [self substringWithRange:NSMakeRange(self.length-4, 4)];
    //中间
    NSString *middleString = @" **** **** ";
    
    return [NSString stringWithFormat:@"%@%@%@",headString,middleString,footString];
}

//格式化 银行卡号 显示为“6122 **** **** **** 1234” 或 “6122 **** **** **** 123”
- (NSString *)getBankNumberStar
{
    NSString *str = nil;
    
    NSMutableString *mutableStr;
    if (self.length) {
        mutableStr = [NSMutableString stringWithString:self];
        for (int i = 0 ; i < mutableStr.length; i ++) {
            if (i>3&&i<mutableStr.length - 4) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        NSString *text = mutableStr;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    return str;
}

@end
