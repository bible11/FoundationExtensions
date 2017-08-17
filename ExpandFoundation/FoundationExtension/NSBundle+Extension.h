/*
 *  ExpandFoundation
 *  NSBundle+Extension.h
 *
 *  Created by apple on 2017/8/17
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */



#import <Foundation/Foundation.h>

@interface NSBundle (Extension)

+ (NSString *)bundleDisplayName;

+ (NSString *)bundleIdentifier;

+ (NSString *)bundleShortVersion;

+ (NSString *)bundleBuildVersion;

@end
