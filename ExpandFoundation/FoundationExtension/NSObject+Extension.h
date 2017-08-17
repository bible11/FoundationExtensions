/*
 *  ExpandFoundation
 *  NSObject+Extension.h
 *
 *  Created by apple on 2017/8/14
 *    Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Extension)

/**
 获取NSString的CGSize

 @param content NSString字符串
 @param font 字体和大小
 @param maxWidth 最大width
 @return CGSize尺寸
 */
- (CGSize)sizeWithString:(NSString *)content Font:(UIFont *)font withMaxWidth:(CGFloat)maxWidth;

@end
