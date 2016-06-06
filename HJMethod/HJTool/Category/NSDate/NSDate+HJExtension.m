//
//  NSDate+HJExtension.m
//  HJMethod
//
//  Created by coco on 16/6/6.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "NSDate+HJExtension.h"

//NSString *const kNSDateFormatFullDateWithTime   = @"MMM d, yyyy h:mm a";
//NSString *const kNSDateFormatFullDate            = @"MMM d, yyyy";
//NSString *const kNSDateFormatShortDateWithTime   = @"MMM d h:mm a";
//NSString *const kNSDateFormatShortDate           = @"MMM d";
//NSString *const kNSDateFormatWeekday             = @"EEEE";
//NSString *const kNSDateFormatWeekdayWithTime     = @"EEEE h:mm a";
//NSString *const kNSDateFormatTime                = @"h:mm a";
//NSString *const kNSDateFormatTimeWithPrefix      = @"'at' h:mm a";
//NSString *const kNSDateFormatSQLDate             = @"yyyy-MM-dd";
//NSString *const kNSDateFormatSQLTime             = @"HH:mm:ss";
NSString *const kNSDateFormatSQLDateWithTime     = @"yyyy-MM-dd HH:mm:ss";

@implementation NSDate (HJExtension)
//components
- (NSDateComponents *)components {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unit fromDate:self];
    return components;
}

//年
- (NSInteger)year {
    return self.components.year;
}
//月
- (NSInteger)month {
    return self.components.month;
}
//日
- (NSInteger)day {
    return self.components.day;
}

//周
- (NSInteger)weekday {
    return self.components.weekday;
}

//时
- (NSInteger)hour {
    return self.components.hour;
}

//分
- (NSInteger)minute {
    return self.components.minute;
}
//秒
- (NSInteger)second {
    return self.components.second;
}
//当前时间字符串
+ (NSString *)hj_currentDateString {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formatter stringFromDate:date];
    return string;
}
//当前时间戳
+ (NSString *)hj_currentDateTimestampWithType:(TimestampTpye)type {
    return (type == TimestampTpyeSecond ? [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] : [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000]);
}
//时间戳--->@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)hj_stringFromTimestamp:(NSString *)timestamp {
    NSDate *date = [self hj_dateFromTimestamp:timestamp];
    return [self hj_stringFromDate:date];
}
//时间戳---->NSDate
+ (NSDate *)hj_dateFromTimestamp:(NSString *)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
}

//判断是否是同一天
- (BOOL)hj_isSameDay:(NSDate *)anotherDate {
    return (self.year == anotherDate.year) && (self.month == anotherDate.month) && (self.day == anotherDate.day);
}

//时间戳
- (NSTimeInterval)hj_timestamp {
    return [self timeIntervalSince1970];
    
}

//默认@"yyyy-MM-dd HH:mm:ss"
+ (NSDate *)hj_dateFromString:(NSString *)string {
    return [self hj_dateFromString:string withFormat:kNSDateFormatSQLDateWithTime];
}
+ (NSDate *)hj_dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+ (NSString *)hj_stringFromDate:(NSDate *)date withFormat:(NSString *)format
 {
     return [date hj_stringWithFormat:format];
 }

+ (NSString *)hj_stringFromDate:(NSDate *)date {
    return [self hj_stringFromDate:date withFormat:kNSDateFormatSQLDateWithTime];
}

- (NSString *)hj_string {
    return [self hj_stringWithFormat:kNSDateFormatSQLDateWithTime];
}
- (NSString *)hj_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}
@end
