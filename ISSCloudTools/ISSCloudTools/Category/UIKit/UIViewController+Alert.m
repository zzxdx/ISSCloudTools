//
//  UIViewController+Alert.m
//  ChargingPoleApp
//
//  Created by xiongjw on 2018/4/19.
//  Copyright © 2018年 huawei. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showAlertControllerWithMessage:(NSString *)message
                               handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    [self showAlertControllerWithTitle:@"提示" message:message handler:handler];
}

- (void)showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                             handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 响应方法-相册
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    // 添加响应方式
    [ac addAction:action];
    // 显示
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                             btnList:(NSArray *)btnList
                             handler:(UIAlertActionHandler)handler
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i = 0; i < btnList.count; i++)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:btnList[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) handler(i);
        }];
        // 添加响应方式
        [ac addAction:action];
    }
    // 显示
    [self presentViewController:ac animated:YES completion:nil];
}

/// 有确定，取消
- (void)showCommonAlertControllerWithMessage:(NSString *)message
                                     handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:message  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
