//
//  YQNetworkingCodeCheck.m
//  ChargingPoleApp
//
//  Created by huangjian on 2018/5/10.
//  Copyright © 2018年 huawei. All rights reserved.
//

#import "YQNetworkingCodeCheck.h"

#define YQ_ERROR_IMFORMATION @"网络出现错误，请检查网络连接"

@implementation YQNetworkingCodeCheck

+ (BOOL)checkCodeResponseObject:(id)responseObject
{
    
    return YES;
//    NSDictionary *resultData = responseObject;
//    int code = [resultData[@"code"] intValue];
//    if (code == 0) {
//        return YES;
//    }
//    else {
//
////        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ISSNetCodeList" ofType:@"plist"];
////
////        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
////
////        NSString *key = data[[NSString stringWithFormat:@"%d", code]];
////        NSString *msg = ISSLocalizedString(key);
////
////        if (msg == nil || msg.length == 0) msg = NSLocalizedString(YQ_ERROR_IMFORMATION, nil);
////        [[UIApplication sharedApplication].keyWindow makeToast:msg];
////        //账号禁用
////        if (code == 989) {
////             [[NSNotificationCenter defaultCenter] postNotificationName:@"ISSLogoutNote" object:msg];
////        }
//
//        return NO;
//    }
}

@end
