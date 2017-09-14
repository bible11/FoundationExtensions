/*
 *  ExpandFoundation
 *  UIButton+Extension.h
 *
 *  Created by apple on 2017/9/14
 *  Copyright © 2017年 coder. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

#pragma mark -
// with size (32, 32)
+ (instancetype)createBarButtonItem:(UIBarButtonItem **)item
                          withImage:(UIImage *)image
                             target:(id)target
                             action:(SEL)action;

+ (instancetype)createBarButtonItem:(UIBarButtonItem **)item
                     withButtonSize:(CGSize)size
                              image:(UIImage *)image
                             target:(id)target
                             action:(SEL)action;

#pragma mark - VerticallyLayout
- (void)centerVertically;
- (void)centerVerticallyWithPadding:(float)padding;

@end
