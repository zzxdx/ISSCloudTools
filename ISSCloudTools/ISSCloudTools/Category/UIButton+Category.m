//
//  UIButton+Category.m
//  ChargingPoleApp
//
//  Created by huangjian on 2018/5/9.
//  Copyright © 2018年 huawei. All rights reserved.
//

#import "UIButton+Category.h"

#define MainTintColor [UIColor blueColor]
@implementation UIButton (Category)
+ (UIButton *)getWithBorderBtn:(NSString *)titleStr {
    UIButton *setBtn = [[UIButton alloc]init];
    [setBtn setTitle:titleStr forState:UIControlStateNormal];
    
    [setBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setBtn setTitleColor:MainTintColor forState:UIControlStateSelected];
    setBtn.layer.cornerRadius = 16 ; //CGRectGetWidth(setBtn.frame)/2
    setBtn.layer.borderWidth = 1.0f;
    setBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    setBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return setBtn;
}

@end
