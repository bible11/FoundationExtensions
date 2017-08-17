/*
 *  ExpandFoundation
 *  NSError+Extension.h
 *
 *  Created by apple on 2017/8/17
 *    Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */



#import <Foundation/Foundation.h>

@interface NSError (Extension)

+ (nonnull instancetype)errorWithCode:(NSInteger)code localizedDescription:(nullable NSString *)description;

+ (nonnull instancetype)errorWithDomain:(nonnull NSString *)domain
                                   code:(NSInteger)code
                   localizedDescription:(nullable NSString *)description;

@end
