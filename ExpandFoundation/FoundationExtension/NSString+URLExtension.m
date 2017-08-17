/*
 *  ExpandFoundation
 *  NSString+URLExtension.m
 *
 *  Created by apple on 2017/8/14
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *  "借鉴 RequestUtils -- https://github.com/nicklockwood/RequestUtils"
 */


#import "NSString+URLExtension.h"

@implementation NSString (URLExtension)

//截取URL中的参数
- (NSMutableDictionary *)getURLParameters
{
    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

#pragma mark - URL Encode/Decode

//URL Encode
- (NSString *)urlEncodedString
{
    static NSString *const unsafeChars = @"!*'\"();:@&=+$,/?%#[]% ";
    static NSCharacterSet *allowedChars;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSCharacterSet *disallowedChars = [NSCharacterSet characterSetWithCharactersInString:unsafeChars];
        allowedChars = [disallowedChars invertedSet];
    });
    
    return (NSString *)[self stringByAddingPercentEncodingWithAllowedCharacters:allowedChars];
}

//URL Decode
- (NSString *)urlDecodedString
{
    return [self URLDecodedString:NO];
}

//URL Decode
- (NSString *)URLDecodedString:(BOOL)decodePlusAsSpace
{
    NSString *string = self;
    if (decodePlusAsSpace)
    {
        string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    
    return (NSString *)[string stringByRemovingPercentEncoding];
}

//将NSDictionary转换为NSString
+ (NSString *)URLqueryStringForParameters:(NSDictionary<NSString *, id> *)parameters
{
    NSMutableString *result = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //make sure key and value only be encode once
        NSString *encodedKey = key.urlDecodedString.urlEncodedString;
        NSAssert([obj respondsToSelector:@selector(description)], @"can't get value description, maybe you need convert it to a string");
        NSString *encodeValue = [obj description].urlDecodedString.urlEncodedString;
        if (encodedKey == nil || encodeValue == nil) {
            return;
        }
        
        [result appendFormat:@"&%@=%@", encodedKey, encodeValue];
    }];
    
    if ([result hasPrefix:@"&"]) {
        [result deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    return (result.length > 0 ? result: nil);
}

//获取URL参数获取，转换为NSDictionary
- (NSDictionary<NSString *, NSString *> *)URLQueryParameters
{
    NSString *queryString = self.URLQuery;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *parameters = [queryString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters)
    {
        NSRange seperatorRange = [parameter rangeOfString:@"="];
        
        if (seperatorRange.location == NSNotFound) {
            continue;
        }
        
        NSString *key = [parameter substringToIndex:seperatorRange.location];
        NSString *value = (parameter.length > seperatorRange.location + seperatorRange.length?
                           [parameter substringFromIndex:seperatorRange.location + seperatorRange.length]: @"");
        if (key != nil && value != nil) {
            [result setObject:value forKey:key];
        }
    }
    return result;
}

- (NSString *)URLQuery
{
    NSRange queryRange = [self rangeOfURLQuery];
    if (queryRange.location == NSNotFound)
    {
        return nil;
    }
    NSString *queryString = [self substringWithRange:queryRange];
    if ([queryString hasPrefix:@"?"])
    {
        queryString = [queryString substringFromIndex:1];
    }
    return queryString;
}

- (NSRange)rangeOfURLQuery
{
    NSRange queryRange = NSMakeRange(0, self.length);
    NSRange fragmentStart = [self rangeOfString:@"#"];
    if (fragmentStart.length)
    {
        queryRange.length -= (queryRange.length - fragmentStart.location);
    }
    NSRange queryStart = [self rangeOfString:@"?"];
    if (queryStart.length)
    {
        queryRange.location = queryStart.location;
        queryRange.length -= queryRange.location;
    }
    NSString *queryString = [self substringWithRange:queryRange];
    if (queryStart.length || [queryString rangeOfString:@"="].length)
    {
        return queryRange;
    }
    return NSMakeRange(NSNotFound, 0);
}

@end
