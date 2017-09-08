/*
 *  ExpandFoundation
 *  UIColor+Extension.h
 *
 *  Created by apple on 2017/8/18
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */

#define UIColorFrom16String(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 设置颜色为16进制的字符串

 @param color16Str 16进制字符串
 @param alpha 透明度
 @return 返回颜色
 */
+ (UIColor *)colorWith16String:(NSString *)color16Str alpha:(CGFloat)alpha;

@end
