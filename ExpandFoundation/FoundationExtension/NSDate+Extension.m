/*
 *  ExpandFoundation
 *  NSDate+Extension.m
 *
 *  Created by apple on 2017/8/14
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */


#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return [components year];
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

- (NSInteger)weekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return [components weekday];
}

- (NSDate *)beginningOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}

- (BOOL)isSameDayWith:(NSDate *)anotherDay
{
    BOOL sameDay = NO;
    if (anotherDay != nil) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps1 = [cal components:(NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay)
                                          fromDate:self];
        NSDateComponents *comps2 = [cal components:(NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay)
                                          fromDate:anotherDay];
        sameDay = ([comps1 day] == [comps2 day]
                   && [comps1 month] == [comps2 month]
                   && [comps1 year] == [comps2 year]);
    }
    return sameDay;
}

//格式化时间
- (NSString *)toStringWithFormat:(NSString *)format
{
    [[[self class] sharedFormatter] setDateFormat:format];
    return [[[self class] sharedFormatter] stringFromDate:self];
}

//根据枚举格式化时间
- (NSString *)toStringWithType:(DateFormatterType)type
{
    NSString *format = nil;
    switch (type) {
        case DateFormatterTypeDefault:
            format = @"yyyy-MM-dd";
            break;
        case DateFormatterTypefirst:
            format = @"yyyy-MM-dd HH:mm:ss";
            break;
        case DateFormatterTypeThird:
            format = @"yyyy年MM月dd日";
            break;
        default:
            format = @"yyyy.MM.dd";
            break;
    }
    
    [[[self class] sharedFormatter] setDateFormat:format];
    return [[[self class] sharedFormatter] stringFromDate:self];
}

#pragma mark - Private

+ (NSDateFormatter *)sharedFormatter
{
    static NSDateFormatter * _fmt = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fmt = [[NSDateFormatter alloc] init];
    });
    return _fmt;
}

@end
