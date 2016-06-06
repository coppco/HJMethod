//
//  NSString+HJExtension.h
//  HJMethod
//
//  Created by coco on 16/6/6.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*拼音类型*/
typedef NS_ENUM(NSInteger, PinYinType) {
    PinYinTypePhoneticSymbol,  //带音标
    PinYinTypeOnly   //不带音标
};

@interface NSString (HJExtension)
/*=========沙盒路径相关=========*/

/**
 *  Documents路径
 *
 *  @return 返回Documents路径
 */
+ (NSString *)hj_pathDocuments;

/**
 *  documents/FileName路径
 *
 *  @param fileName 文件名称
 *
 *  @return 路径
 */
+ (NSString *)hj_pathDocumentsFileName:(NSString *)fileName;

/**
 *  documents/subPath/fileName路径
 *
 *  @param subPath 子文件夹subPath
 *  @param fileName    fileName名称
 *
 *  @return 路径
 */
+ (NSString *)hj_pathDocumentsSubPath:(NSString *)subPath fileName:(NSString *)fileName;

/**
 *  caches路径
 *
 *  @return caches路径
 */
+ (NSString *)hj_pathCaches;

/**
 *  caches/fileName路径
 *
 *  @param fileName
 *
 *  @return 路径
 */
+ (NSString *)hj_pathCachesFileName:(NSString *)fileName;

/**
 *  caches/subPath/fileName路径
 *
 *  @param subPath 子文件夹
 *  @param name    fileName路径
 *
 *  @return 路径
 */
+ (NSString *)hj_pathCachesSubPath:(NSString *)subPath fileName:(NSString *)fileName;

/*========字符串判断相关=========*/

/**
 *  判断字符串是否为空
 *
 *  @return YES 即为空
 */
- (BOOL)hj_isEmpty;

/**
 *  过滤掉特殊字符串
 *
 *  @return 返回去除后的字符串
 */
- (NSString *)hj_filerSpecial;

/**
 *  判断字符串是否包含中文
 *
 *  @return 返回包含字符串与否
 */
- (BOOL)hj_isContainerChineseCharacter;

/**
 *  把汉字转成拼音,默认没有音标
 *
 *  @param type     拼音类型, 有音标和无音标
 *  @param trimming 是否包含空格
 *
 *  @return 返回汉字拼音
 */
- (NSString *)hj_transformPinYinType:(PinYinType)type trimmingWhitespace:(BOOL)trimming;

/**
 *  字符串是否只包含字母
 *
 *  @return YES只包含字母
 */
- (BOOL)hj_isOnlyLetters;

/**
 *  字符串是否只包含数字
 *
 *  @return YES只包含数字
 */
- (BOOL)hj_isOnlyNumbers;

/**
 *  字符串是否只包含字母或者数字
 *
 *  @return YES 只包含数字或者字母
 */
- (BOOL)hj_isOnlyLettersAndNumbers;

/**
 *  反转字符串
 *
 *  @return 返回反转后的字符串
 */
- (NSString *)hj_inverted;

/**
 *  判断字符串是否是合法的手机号
 *
 *  @return YES 手机号合法
 */
- (BOOL)hj_isValidPhoneNumber;

/**
 *  判断字符串是否是合法的email地址
 *
 *  @return YES 邮箱地址合法
 */
- (BOOL)hj_isValidEmailAddress;

/**
 *  判断字符串是否是合法的身份证号
 *
 *  @return YES 身份证合法
 */
- (BOOL)hj_isValidIndentifyNumber;

/**
 *  从身份证获取出生年月日,如:2000-01-01 or nil
 *
 *  @return 返回出生年月日
 */
- (NSString *)hj_getBirthdayFromIndentifyNumber;

/**
 *  从身份证获取性别,man 、woman or nil
 *
 *  @return 返回性别
 */
- (NSString *)hj_getGenderFromIndentifyNumber;

/**
 *  指定文本的绘制的范围,返回文本的宽高
 *
 *  @param font 字符
 *  @param size 范围
 *
 *  @return 
 */
- (CGSize)hj_sizeWithFont:(UIFont *)font size:(CGSize)size;

/**
 *  根据文字的字体返回文字的范围(未指定宽高)
 *
 *  @param font 字体
 *
 *  @return CGSize
 */
- (CGSize)hj_sizeWithFont:(UIFont *)font;

/**
 *  指定文本的高度,返回文本的宽度
 *
 *  @param width 文本的宽度
 *  @param font  字体
 *
 *  @return
 */
- (CGFloat)hj_heightForWidth:(CGFloat)width font:(UIFont *)font;

/**
 *  指定文本的高度返回文本的宽度
 *
 *  @param height 高度
 *  @param font   字体
 *
 *  @return 
 */
- (CGFloat)hj_widthForHeight:(CGFloat)height font:(UIFont *)font;
@end
