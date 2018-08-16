//
//  NSMutableAttributedString+Add.m
//  ChargingPoleApp
//
//  Created by huangjian on 2018/4/12.
//  Copyright © 2018年 huawei. All rights reserved.
//

/*
 self.tapMessageLabel.attributedText =
 [NSMutableAttributedString new]
 .add(@"红色字体，字号11",@{
 NSForegroundColorAttributeName:[UIColor redColor],
 NSFontAttributeName :[UIFont systemFontOfSize:11],
 })
 .add(@"蓝色字体，字号13",@{
 NSForegroundColorAttributeName:[UIColor blueColor],
 NSFontAttributeName :[UIFont systemFontOfSize:13],
 })
 .add(@"黑色字体，字号15",@{
 NSForegroundColorAttributeName:[UIColor blackColor],
 NSFontAttributeName :[UIFont systemFontOfSize:15],
 });

 */

#import "NSMutableAttributedString+Add.h"

@implementation NSMutableAttributedString (Add)

- (NSMutableAttributedString *(^)(NSString *, NSDictionary<NSString *,id> *))add {
    return ^NSMutableAttributedString * (NSString *string, NSDictionary <NSString *,id>*attrDic) {
        if ([[attrDic allKeys] containsObject:NSImageAttributeName] && [[attrDic allKeys] containsObject:NSImageBoundsAttributeName]) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
            CGRect rect = CGRectFromString(attrDic[NSImageBoundsAttributeName]);
            attach.bounds = rect;
            attach.image = attrDic[NSImageAttributeName];
            
            [self appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        } else {
            if ([self isBlankString:string]) {
                [self appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:attrDic]];
            } else {
                [self appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:attrDic]];
            }
        }
        
        return self;
    };
}

- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

@end


NSString *const NSImageAttributeName = @"NSImageAttributeName";
NSString *const NSImageBoundsAttributeName = @"NSImageBoundsAttributeName";

