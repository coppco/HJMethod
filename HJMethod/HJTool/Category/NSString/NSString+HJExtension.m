//
//  NSString+HJExtension.m
//  HJMethod
//
//  Created by coco on 16/6/6.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "NSString+HJExtension.h"


@implementation NSString (HJExtension)
#pragma - mark 路径相关
+ (NSString *)hj_pathDocuments {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)hj_pathDocumentsFileName:(NSString *)fileName {
    NSAssert(fileName.length != 0, @"fileName must not be nil or empty string");
    return [[self hj_pathDocuments] stringByAppendingPathComponent:fileName];
}

+ (NSString *)hj_pathDocumentsSubPath:(NSString *)subPath fileName:(NSString *)fileName {
    NSAssert(subPath.length != 0 && fileName.length != 0, @"subPath or fileName must not be nil or empty string");
    NSString *path = [self hj_pathDocumentsFileName:subPath];
    //不存在则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString *)hj_pathCaches {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}
+ (NSString *)hj_pathCachesFileName:(NSString *)fileName {
    NSAssert(fileName.length != 0, @"fileName must not be nil or empty string");
    return [[self hj_pathCaches] stringByAppendingPathComponent:fileName];
}
+ (NSString *)hj_pathCachesSubPath:(NSString *)subPath fileName:(NSString *)fileName {
    NSAssert(fileName.length != 0 && subPath.length != 0, @"subPath or fileName must not be nil or empty string");
    NSString *path = [self hj_pathCachesFileName:subPath];
    //不存在则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:fileName];
}
#pragma - mark 字符串判断

- (BOOL)hj_isEmpty {
    return self.length == 0;
}

- (NSString *)hj_filerSpecial {
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+,.;':|/@!? "];
    //stringByTrimmingCharactersInSet只能去掉首尾的特殊字符串
    return [[[self componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (BOOL)hj_isContainerChineseCharacter {
    for (int i = 0; i < self.length; i++) {
        unichar a = [self characterAtIndex:i];
        if (a >= 0x4e00 && a <= 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)hj_transformPinYinType:(PinYinType)type trimmingWhitespace:(BOOL)trimming {
    if (self.length == 0) {
        return nil;
    }
    if (![self hj_isContainerChineseCharacter]) {
        return self;
    }
    //先转换为带音标的字符串
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformMandarinLatin, NO);
    if (type == PinYinTypePhoneticSymbol) {
        if (trimming) {
            return [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        return pinyin;
    } else {
        //再转为不带音标字符串
        NSMutableString *pinyinPhoneticSymbol = [NSMutableString stringWithString:pinyin];
        CFStringTransform((__bridge CFMutableStringRef)(pinyinPhoneticSymbol), NULL, kCFStringTransformStripCombiningMarks, NO);
        if (trimming) {
            return [pinyinPhoneticSymbol stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        return pinyinPhoneticSymbol;
    }
}

- (BOOL)hj_isOnlyLetters {
    NSCharacterSet *set = [[NSCharacterSet letterCharacterSet] invertedSet];
    return [self rangeOfCharacterFromSet:set].location == NSNotFound;
}
- (BOOL)hj_isOnlyNumbers {
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return [self rangeOfCharacterFromSet:set].location == NSNotFound;
}
- (BOOL)hj_isOnlyLettersAndNumbers {
    NSCharacterSet *set = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return [self rangeOfCharacterFromSet:set].location == NSNotFound;
}
- (NSString *)hj_inverted {
    NSMutableString *invertString = [[NSMutableString alloc] init];
    NSInteger charIndex = [self length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [invertString appendString:[self substringWithRange:subStrRange]];
    }
    return invertString;
}

- (BOOL)hj_isValidPhoneNumber {
    NSString *MOBILE    = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM        = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378]|7[7])\\d)\\d{7}$";   // 包含电信4G 177号段
    NSString *CU        = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT        = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    //
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    
    return NO;
}
- (BOOL)hj_isValidEmailAddress {
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    //先把NSString转换为小写
    NSString *lowerString       = self.lowercaseString;
    
    return [regExPredicate evaluateWithObject:lowerString] ;
}
- (BOOL)hj_isValidIndentifyNumber {
    //     //必须满足以下规则
    //     //1. 长度必须是18位或者15位，前17位必须是数字，第十八位可以是数字或X
    //     //2. 前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
    //     //3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
    //     //4. 第17位表示性别，双数表示女，单数表示男
    //     //5. 第18位为前17位的校验位
    //     //算法如下：
    //     //（1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
    //     //（2）余数 ＝ 校验和 % 11
    //     //（3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“0X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
    //     //6. 出生年份的前两位必须是19或20
    //number = [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *number = [self hj_filerSpecial];
    //1⃣️判断位数
    if (number.length != 15 && number.length != 18) {
        return NO;
    }
    //2⃣️将15位身份证转为18位
    NSMutableString *mString = [NSMutableString stringWithString:number];
    if (number.length == 15) {
        //出生日期加上年的开头
        [mString insertString:@"19" atIndex:6];
        //最后一位加上校验码
        [mString insertString:[mString getLastIdentifyNumber] atIndex:[mString length]];
        number = mString;
    }
    //3⃣️开始判断
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    //区域
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![regexTest evaluateWithObject:number]) {
        return NO;
    }
    //4⃣️验证校验码
    return [[number getLastIdentifyNumber] isEqualToString:[number substringWithRange:NSMakeRange(17, 1)]];
}
//获取身份证最后一位验证码
- (NSString *)getLastIdentifyNumber {
    //位数不小于17
    if (self.length < 17) {
        return nil;
    }
    //加权因子
    int R[] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
    //校验码
    unsigned char sChecker[11] = {'1','0','X','9','8','7','6','5','4','3','2'};
    long p =0;
    for (int i =0; i<=16; i++){
        NSString * s = [self substringWithRange:NSMakeRange(i, 1)];
        p += [s intValue]*R[i];
    }
    //校验位
    int o = p%11;
    NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
    return string_content;
}
- (NSString *)hj_getBirthdayFromIndentifyNumber {
    if (![self hj_isValidIndentifyNumber]) {
        return nil;
    }
    NSString *number = [self hj_filerSpecial];
    if (number.length == 18) {
        return [NSString stringWithFormat:@"%@-%@-%@-",[number substringWithRange:NSMakeRange(6,4)], [number substringWithRange:NSMakeRange(10,2)], [number substringWithRange:NSMakeRange(12,2)]];
    }
    if (number.length == 15) {
        return [NSString stringWithFormat:@"19%@-%@-%@-",[number substringWithRange:NSMakeRange(6,2)], [number substringWithRange:NSMakeRange(8,2)], [number substringWithRange:NSMakeRange(10,2)]];
    };
    return nil;
}

- (NSString *)hj_getGenderFromIndentifyNumber {
    if (![self hj_isValidIndentifyNumber]) {
        return nil;
    }
    NSString *number = [self hj_filerSpecial];
    NSInteger i = [[number substringWithRange:NSMakeRange(number.length - 2, 1)] integerValue];
    return (i % 2 == 1) ? @"man" : @"woman";
}

#pragma - mark 字符串size
- (CGSize)hj_sizeWithFont:(UIFont *)font size:(CGSize)size {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (font != nil) {
        dic[NSFontAttributeName] = font;
    }
    return [self boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size;
}

- (CGSize)hj_sizeWithFont:(UIFont *)font{
    return [self hj_sizeWithFont:font size:CGSizeMake(10000, 10000)];
}

- (CGFloat)hj_heightForWidth:(CGFloat)width font:(UIFont *)font {
    return [self hj_sizeWithFont:font size:CGSizeMake(width, 10000)].height;
}

- (CGFloat)hj_widthForHeight:(CGFloat)height font:(UIFont *)font {
    return [self hj_sizeWithFont:font size:CGSizeMake(10000, height)].width;
}

#pragma - mark 安全相关
//md5  sha加密
+ (NSString *)hj_safedStringWithData:(NSData *)data type:(EncryptType)type {
    if (!data) {
        return nil;
    }
    NSString *encryptString;
    switch (type) {
        case EncryptTypeMD2:
        {
            unsigned char result[CC_MD2_DIGEST_LENGTH];
            CC_MD2(data.bytes, (CC_LONG)data.length, result);
            encryptString = [NSString stringWithFormat:
                             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                             result[0], result[1], result[2], result[3],
                             result[4], result[5], result[6], result[7],
                             result[8], result[9], result[10], result[11],
                             result[12], result[13], result[14], result[15]
                             ];
        }
            break;
        case EncryptTypeMD4:
        {
            unsigned char result[CC_MD4_DIGEST_LENGTH];
            CC_MD4(data.bytes, (CC_LONG)data.length, result);
            encryptString = [NSString stringWithFormat:
                             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                             result[0], result[1], result[2], result[3],
                             result[4], result[5], result[6], result[7],
                             result[8], result[9], result[10], result[11],
                             result[12], result[13], result[14], result[15]
                             ];
        }
            break;
        case EncryptTypeMD5:
        {
            unsigned char result[CC_MD5_DIGEST_LENGTH];
            CC_MD5(data.bytes, (CC_LONG)data.length, result);
            encryptString = [NSString stringWithFormat:
                             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                             result[0], result[1], result[2], result[3],
                             result[4], result[5], result[6], result[7],
                             result[8], result[9], result[10], result[11],
                             result[12], result[13], result[14], result[15]
                             ];
        }
            break;
        case EncryptTypeSHA1:
        {
            unsigned char result[CC_SHA1_DIGEST_LENGTH];
            CC_SHA1(data.bytes, (CC_LONG)data.length, result);
            NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
            for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
                [hash appendFormat:@"%02x", result[i]];
            }
            encryptString = hash;
        }
            break;
        case EncryptTypeSHA224:
        {
            unsigned char result[CC_SHA224_DIGEST_LENGTH];
            CC_SHA224(data.bytes, (CC_LONG)data.length, result);
            NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
            for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
                [hash appendFormat:@"%02x", result[i]];
            }
            encryptString = hash;
        }
            break;
        case EncryptTypeSHA256:
        {
            unsigned char result[CC_SHA256_DIGEST_LENGTH];
            CC_SHA256(data.bytes, (CC_LONG)data.length, result);
            NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
            for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
                [hash appendFormat:@"%02x", result[i]];
            }
            encryptString = hash;
        }
            break;
        case EncryptTypeSHA384:
        {
            unsigned char result[CC_SHA384_DIGEST_LENGTH];
            CC_SHA384(data.bytes, (CC_LONG)data.length, result);
            NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
            for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
                [hash appendFormat:@"%02x", result[i]];
            }
            encryptString = hash;
        }
            break;
        case EncryptTypeSHA512:
        {
            unsigned char result[CC_SHA512_DIGEST_LENGTH];
            CC_SHA512(data.bytes, (CC_LONG)data.length, result);
            NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
            for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
                [hash appendFormat:@"%02x", result[i]];
            }
            encryptString = hash;
        }
            break;
        default:
            return nil;
            break;
    }
    return encryptString;
}

- (NSString *)hj_safedStringWithType:(EncryptType)type {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [[self class] hj_safedStringWithData:data type:type];
}
- (NSData *)hj_safedDataWithType:(EncryptType)type {
    return [[self class] hj_safedDataWithData:[self dataUsingEncoding:NSUTF8StringEncoding] type:type];
}
+ (NSData *)hj_safedDataWithData:(NSData *)data type:(EncryptType)type {
    if (!data) {
        return nil;
    }
    NSData *encryptData = nil;
    switch (type) {
        case EncryptTypeMD2:
        {
            unsigned char result[CC_MD2_DIGEST_LENGTH];
            CC_MD2(data.bytes, (CC_LONG)data.length, result);
            encryptData = [NSData dataWithBytes:result length:CC_MD2_DIGEST_LENGTH];
        }
            break;
        case EncryptTypeMD4:
        {
            unsigned char result[CC_MD4_DIGEST_LENGTH];
            CC_MD4(data.bytes, (CC_LONG)data.length, result);
            encryptData = [NSData dataWithBytes:result length:CC_MD4_DIGEST_LENGTH];
        }
            break;
        case EncryptTypeMD5:
        {
            unsigned char result[CC_MD5_DIGEST_LENGTH];
            CC_MD5(data.bytes, (CC_LONG)data.length, result);
            encryptData = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
        }
            break;
        case EncryptTypeSHA1:
        {
            unsigned char result[CC_SHA1_DIGEST_LENGTH];
            CC_SHA1(data.bytes, (CC_LONG)data.length, result);
            encryptData = [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
        }
            break;
        case EncryptTypeSHA224:
        {
            unsigned char result[CC_SHA224_DIGEST_LENGTH];
            CC_SHA224(data.bytes, (CC_LONG)data.length, result);
            encryptData = [NSData dataWithBytes:result length:CC_SHA224_DIGEST_LENGTH];
        }
            break;
        case EncryptTypeSHA256:
        {
            unsigned char result[CC_SHA256_DIGEST_LENGTH];
            CC_SHA256(data.bytes, (CC_LONG)data.length, result);
            encryptData = [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
        }
            break;
        case EncryptTypeSHA384:
        {
            unsigned char result[CC_SHA384_DIGEST_LENGTH];
            CC_SHA384(data.bytes, (CC_LONG)data.length, result);
            encryptData = [NSData dataWithBytes:result length:CC_SHA384_DIGEST_LENGTH];
        }
            break;
        case EncryptTypeSHA512:
        {
            unsigned char result[CC_SHA512_DIGEST_LENGTH];
            CC_SHA512(data.bytes, (CC_LONG)data.length, result);
            encryptData = [NSData dataWithBytes:result length:CC_SHA512_DIGEST_LENGTH];
        }
            break;
        default:
            return nil;
            break;
    }
    return encryptData;
}

//crc32加密
- (NSString *)hj_safedCRC32String {
    return [[self class] hj_safedCRC32StringForData:[self dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (NSString *)hj_safedCRC32StringForData:(NSData *)data {
    if (!data) {
        return nil;
    }
    uLong result = crc32(0, [data bytes], (uInt)data.length);
    return [NSString stringWithFormat:@"%08x", (uint32_t)result];
}

//hmac加密
+ (NSString *)hj_safedStringHMACWithData:(NSData *)data type:(CCHmacAlgorithm)hmacType key:(NSString *)key {
    if (!data) {
        return nil;
    }
    size_t size;
    switch (hmacType) {
        case kCCHmacAlgMD5:
            size = CC_MD5_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA1:
            size = CC_SHA1_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA224:
            size = CC_SHA224_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA256:
            size = CC_SHA256_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA384:
            size = CC_SHA384_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA512:
            size = CC_SHA512_DIGEST_LENGTH;
            break;
        default:
            return nil;
            break;
    }
    unsigned char result[size];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(hmacType, cKey, strlen(cKey), data.bytes, data.length, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:size * 2];
    for (int i = 0; i < size; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)hj_safedStringHMACWithType:(CCHmacAlgorithm)hmacType key:(NSString *)key {
    return [[self class] hj_safedStringHMACWithData:[self dataUsingEncoding:NSUTF8StringEncoding] type:hmacType key:key];
}

- (NSString *)md5String {
    return [self hj_safedStringWithType:(EncryptTypeMD5)];
}

- (NSString *)sha1String {
    return [self hj_safedStringWithType:(EncryptTypeSHA1)];
}

-(BOOL)containsEmoji{
    if (!self || self.length <= 0) {
        return NO;
    }
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

//size大小
+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte{
    NSString *sizeDisplayStr;
    if (sizeOfByte < 1024) {
        sizeDisplayStr = [NSString stringWithFormat:@"%.2f bytes", sizeOfByte];
    }else{
        CGFloat sizeOfKB = sizeOfByte/1024;
        if (sizeOfKB < 1024) {
            sizeDisplayStr = [NSString stringWithFormat:@"%.2f KB", sizeOfKB];
        }else{
            CGFloat sizeOfM = sizeOfKB/1024;
            if (sizeOfM < 1024) {
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f M", sizeOfM];
            }else{
                CGFloat sizeOfG = sizeOfKB/1024;
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f G", sizeOfG];
            }
        }
    }
    return sizeDisplayStr;
}
@end

