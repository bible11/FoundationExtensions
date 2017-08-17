/*
 *  ExpandFoundation
 *  NSBundle+Extension.m
 *
 *  Created by apple on 2017/8/17
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */


#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

+ (NSString *)bundleDisplayName
{
    return [[self mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)bundleIdentifier
{
    return [[self mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)bundleShortVersion
{
    return [[self mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)bundleBuildVersion
{
    return [[self mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end
