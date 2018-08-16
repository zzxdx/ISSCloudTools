//
//  UIViewController+Alert.h
//  ChargingPoleApp
//
//  Created by xiongjw on 2018/4/19.
//  Copyright © 2018年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertActionHandler)(NSInteger index);

@interface UIViewController (Alert)

/// 提示
- (void)showAlertControllerWithMessage:(NSString *)message
                               handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (void)showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                             handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (void)showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                             btnList:(NSArray *)btnList
                             handler:(UIAlertActionHandler)handler;
/// 有确定，取消
- (void)showCommonAlertControllerWithMessage:(NSString *)message
                                     handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end
