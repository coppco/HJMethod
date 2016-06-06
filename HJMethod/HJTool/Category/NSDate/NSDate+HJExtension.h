//
//  NSDate+HJExtension.h
//  HJMethod
//
//  Created by coco on 16/6/6.
//  Copyright © 2016年 XHJ. All rights reserved.
//
/**
 G  公元
 yy 年后两位 yyyy 年后四位
 M 1~12  MM  01~12两位不足补零 MMM 英文缩写   MMMM英文全写
 d 1~31 dd 01~31两位不足补零
 EEE 英文缩写   EEEE 英文全写
 aa  显示AM/PM
 H  0~23 (24小时制) HH 00~23两位不足补零(24小时制) K 0~12(12小时制) KK 00~12 两位不足补零(12小时制)
 m 显示0~59，1位数或2位数  mm显示00~59，不足2位数会补0
 s 显示0~59，1位数或2位数  ss显示00~59，不足2位数会补0  S 毫秒的显示
 zzzz：Pacific Daylight Time   Z / ZZ / ZZZ ：-0800   ZZZZ：GMT -08:00  v：PT vvvv：Pacific Time
 */

#import <Foundation/Foundation.h>



/*时间戳类型*/
typedef NS_ENUM(NSInteger, TimestampTpye) {
    TimestampTpyeSecond,  //精确到秒
    TimestampTpyeMillisecond  //精确到毫秒
};

@interface NSDate (HJExtension)

/**年*/
- (NSInteger)year;
/**月*/
- (NSInteger)month;
/**日*/
- (NSInteger)day;
/**周*/
- (NSInteger)weekday;
/**时*/
- (NSInteger)hour;
/**分*/
- (NSInteger)minute;
/**秒*/
- (NSInteger)second;

/**
 *  获取当前时间字符串,默认2001-01-01
 *
 *  @return 返回字符串
 */
+ (NSString *)hj_currentDateString;

/**
 *  获取当前since1970的10位或者13位时间戳
 *
 *  @param type 10位或者13位
 *
 *  @return 返回字符串
 */
+ (NSString *)hj_currentDateTimestampWithType:(TimestampTpye)type;

/**
 *  时间戳转字符串格式:@"yyyy-MM-dd HH:mm:ss"
 *
 *  @param timestamp 时间戳
 *
 *  @return
 */
+ (NSString *)hj_stringFromTimestamp:(NSString *)timestamp;

/**
 *  时间戳转NSdate
 *
 *  @param timestamp 时间戳
 *
 *  @return 
 */
+ (NSDate *)hj_dateFromTimestamp:(NSString *)timestamp;

/**
 *  判断两个日期是否是同一天
 *
 *  @param anotherDate 日期
 *
 *  @return YES 同一天
 */
- (BOOL)hj_isSameDay:(NSDate *)anotherDate;

/**
 *  本身since1970的间隔
 *
 *  @return 
 */
- (NSTimeInterval)hj_timestamp; //full seconds since

/**
 *  字符串转为NSDate,默认@"yyyy-MM-dd HH:mm:ss"
 *
 *  @param string 字符串
 *
 *  @return
 */
+ (NSDate *)hj_dateFromString:(NSString *)string;

/**
 *  根据字符串和格式转成NSDate
 *
 *  @param string 字符串
 *  @param format 格式
 *
 *  @return 
 */
+ (NSDate *)hj_dateFromString:(NSString *)string withFormat:(NSString *)format;

/**
 *  根据格式把日期NSDate转成字符串
 *
 *  @param date   日期
 *  @param string 格式
 *
 *  @return
 */
+ (NSString *)hj_stringFromDate:(NSDate *)date withFormat:(NSString *)format;

/**
 *  把日期转成@"yyyy-MM-dd HH:mm:ss"格式的字符串
 *
 *  @param date 日期
 *
 *  @return
 */
+ (NSString *)hj_stringFromDate:(NSDate *)date;

/**
 *  date的字符串@"yyyy-MM-dd HH:mm:ss"格式
 *
 *  @return 
 */
- (NSString *)hj_string;

/**
 *  把NSDate对象转换成字符串
 *
 *  @param format 格式
 *
 *  @return
 */
- (NSString *)hj_stringWithFormat:(NSString *)format;



@end
