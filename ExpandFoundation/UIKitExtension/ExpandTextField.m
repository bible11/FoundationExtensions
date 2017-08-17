/*
 *  ExpandFoundation
 *  ExpandTextField.m
 *
 *  Created by apple on 2017/8/17
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 *  描述: UITextField的子类扩展
 *
 */

#import "ExpandTextField.h"

@implementation ExpandTextField

#pragma mark - Initialization

#pragma mark - Getter

#pragma mark - Setter

#pragma mark - Public Method

//设置placeholder 的文字颜色
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark - Private Method

#pragma mark - OverWrite Method


@end
