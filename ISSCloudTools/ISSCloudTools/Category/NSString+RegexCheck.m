//
//  NSString+RegexCheck.m
//  CommonLibrary
//
//  Created by Alexi on 14-2-13.
//  Copyright (c) 2014年 CommonLibrary. All rights reserved.
//

#import "NSString+RegexCheck.h"


@implementation NSString (RegexCheck)

- (BOOL)matchRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return  [predicate evaluateWithObject:self];
}

- (BOOL)isValidateMobile
{
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|(7[0[059]|3|6｜7｜8])|8[0-9])\\d{8}$";
    return [self matchRegex:phoneRegex];
}

- (BOOL)isValidatePassword
{
    NSString *passWordRegex = @"^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[~!@#$%^&*])[0-9a-zA-Z~!@#$%^&*]{6,12}$";
    //NSString *passWordRegex = @"^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[~!@#$%^&*])[0-9a-zA-Z~!@#$%^&*]{6,12}$";
    return [self matchRegex:passWordRegex];
}

/// 判断是否是0-10000的整数或小数
- (BOOL)isDistanceNumCheck
{
    NSString *distanceNumRegex = @"(([0]|(0[.]\\d{0,1}))|([1-9]\\d{0,3}(([.]\\d{0,1})?)))";

    return [self matchRegex:distanceNumRegex];
}

- (BOOL)isValidateeMail
{
    NSString *emailRegex = @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
    return [self matchRegex:emailRegex];
}

/// 正则匹配手机号
- (BOOL)checkTelNumber:(NSString *) telNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString *CM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:telNumber] == YES)
        || ([regextestcm evaluateWithObject:telNumber] == YES)
        || ([regextestct evaluateWithObject:telNumber] == YES)
        || ([regextestcu evaluateWithObject:telNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    //    NSString *pattern = @"^1+[3578]+\\d{9}";
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    //    BOOL isMatch = [pred evaluateWithObject:telNumber];
    //    return isMatch;
}


/// 正则匹配用户密码6-18位数字和字母组合
- (BOOL)checkPassword:(NSString *) password
{
    NSString *passwordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    return [self matchRegex:passwordRegex];
}

@end
