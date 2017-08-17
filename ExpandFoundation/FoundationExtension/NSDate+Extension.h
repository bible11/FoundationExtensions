/*
 *  ExpandFoundation
 *  NSDate+Extension.h
 *
 *  Created by apple on 2017/8/14
 *  Copyright © 2017年 zoufuqiang. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DateFormatterType) {
    DateFormatterTypeDefault = 0, //@"yyyy-MM-dd"
    DateFormatterTypefirst = 1, //@"yyyy-MM-dd HH:mm:ss"
    DateFormatterTypeThird = 2 //@"yyyy年MM月dd日"
};

@interface NSDate (Extension)

@property(nonatomic,readonly)NSInteger year;
@property(nonatomic,readonly)NSInteger month;
@property(nonatomic,readonly)NSInteger day;
@property(nonatomic,readonly)NSInteger hour;
@property(nonatomic,readonly)NSInteger weekday;

/**
 格式化时间

 @param format 时间格式
 @return 格式化的时间
 */
- (NSString *)toStringWithFormat:(NSString *)format;

/**
 格式化时间

 @param type DateFormatterType
 @return 格式化的时间
 */
- (NSString *)toStringWithType:(DateFormatterType)type;

/**
 比较2个时间是否相同

 @param anotherDay 另一个时间
 @return 比较的BOOL值
 */
- (BOOL)isSameDayWith:(NSDate *)anotherDay;

@end
