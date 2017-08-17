/*
 *  ExpandFoundation
 *  NSError+Extension.m
 *
 *  Created by apple on 2017/8/17
 *    Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */


#import "NSError+Extension.h"

@implementation NSError (Extension)

+ (nonnull instancetype)errorWithCode:(NSInteger)code localizedDescription:(nullable NSString *)description
{
    return [self errorWithDomain:@"Undefined error domain" code:code localizedDescription:description];
}

+ (nonnull instancetype)errorWithDomain:(nonnull NSString *)domain
                                   code:(NSInteger)code
                   localizedDescription:(nullable NSString *)description
{
    NSDictionary *userInfo = nil;
    if (description) {
        userInfo = @{NSLocalizedDescriptionKey: description,
                     NSLocalizedFailureReasonErrorKey: description};
    }
    
    return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

@end
