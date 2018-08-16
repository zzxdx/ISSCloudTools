//
//  NSString+RegexCheck.h
//  CommonLibrary
//
//  Created by Alexi on 14-2-13.
//  Copyright (c) 2014年 CommonLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegexCheck)

- (BOOL)matchRegex:(NSString *)regex;

- (BOOL)isValidateMobile;

- (BOOL)isValidatePassword;

/// 正则匹配手机号
- (BOOL)checkTelNumber:(NSString *) telNumber;

/// 正则匹配用户密码6-18位数字和字母组合
- (BOOL)checkPassword:(NSString *) password;

/// 判断是否是0-10000的整数或小数
- (BOOL)isDistanceNumCheck;

- (BOOL)isValidateeMail;

@end
