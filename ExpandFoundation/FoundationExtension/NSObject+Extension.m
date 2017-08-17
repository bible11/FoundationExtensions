/*
 *  ExpandFoundation
 *  NSObject+Extension.m
 *
 *  Created by apple on 2017/8/14
 *    Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */


#import "NSObject+Extension.h"

@implementation NSObject (Extension)

#pragma mark - Size

//获取NSString的CGSize
- (CGSize)sizeWithString:(NSString *)content Font:(UIFont *)font withMaxWidth:(CGFloat)maxWidth
{
    {
        NSDictionary *attributes = [NSString _textAttributesWithFont:font lineBreakMode:NSLineBreakByCharWrapping];
        CGRect bounds = [content boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil];
        return CGSizeMake(ceilf(CGRectGetWidth(bounds)),
                          ceilf(CGRectGetHeight(bounds)));
    }
}

#pragma mark - Private

+ (NSDictionary *)_textAttributesWithFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    attributes[NSParagraphStyleAttributeName] = style;
    if (font != nil) {
        attributes[NSFontAttributeName] = font;
    }
    
    return attributes;
}

@end
