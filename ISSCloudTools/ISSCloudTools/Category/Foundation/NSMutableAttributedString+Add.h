//
//  NSMutableAttributedString+Add.h
//  ChargingPoleApp
//
//  Created by huangjian on 2018/4/12.
//  Copyright © 2018年 huawei. All rights reserved.
//
/*
 使用：
 [NSMutableAttributedString new]
 .add(@"红色字体，字号11",@{
                    NSForegroundColorAttributeName:[UIColor redColor],
                    NSFontAttributeName :[UIFont systemFontOfSize:11],
                    })
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (Add)

- (NSMutableAttributedString *(^)(NSString *,NSDictionary <NSString *,id > *))add;

@end

FOUNDATION_EXTERN NSString *const NSImageAttributeName;  //图片，传UIImage
FOUNDATION_EXTERN NSString *const NSImageBoundsAttributeName; //图片尺寸
