//
//  UILabel+Create.h
//  AXGY
//
//  Created by xiongjw on 16/5/26.
//  Copyright © 2016年 xiongjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Create)

/**
 *  1、一行label－默认字体大小、字体颜色
 */
+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                       text:(NSString *)text;

/**
 *  2、一行label－默认字体大小
 */
+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                   fontSize:(CGFloat)fontSize
                       text:(NSString *)text;

/**
 *  3、一行label－默认字体颜色
 */
+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      color:(UIColor *)color
                       text:(NSString *)text;

/**
 *  4、一行label－指定字体大小、字体颜色
 */
+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                   fontSize:(CGFloat)fontSize
                      color:(UIColor *)color
                       text:(NSString *)text;

/**
 *  5、一行label－指定字体大小、字体颜色、宽度
 */
+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize
                      color:(UIColor *)color
                       text:(NSString *)text;

/**
 *  1、多行label－默认字体大小和字体颜色
 */
+ (UILabel *)mutLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                       text:(NSString *)text;

+ (UILabel *)mutLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize
                       text:(NSString *)text;

+ (UILabel *)mutLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                      color:(UIColor *)color
                       text:(NSString *)text;

+ (UILabel *)mutLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize
                      color:(UIColor *)color
                       text:(NSString *)text;

/**
 *  以前的方式创建label
 */
+ (UILabel *)initWithFrame:(CGRect)frame
                      text:(NSString *)text;

+ (UILabel *)initWithFrame:(CGRect)frame
                     color:(UIColor *)color
                      text:(NSString *)text
                singleLine:(BOOL)oneLine;

+ (UILabel *)initWithFrame:(CGRect)frame
                      font:(UIFont *)font
                     color:(UIColor *)color
                      text:(NSString *)text
                singleLine:(BOOL)oneLine;

+ (UILabel *)initWithFrame:(CGRect)frame
                      font:(UIFont *)font
                     color:(UIColor *)color
                      text:(NSString *)text
                 alignment:(NSTextAlignment)alignment
                singleLine:(BOOL)oneLine;

@end


@interface UILabel (Helper)

+ (CGFloat)getLabelHeight:(CGFloat)contentWidth font:(UIFont *)font text:(NSString *)text;
+ (CGFloat)getLabelHeight:(UILabel *)label;

+ (CGSize)getLabelSize:(NSString *)value font:(UIFont *)font;
+ (CGSize)getLabelSize:(UILabel *)label;

+ (CGRect)getLabelRect:(UILabel *)textLabel;

+ (CGRect)getOneLineLabelRect:(UILabel *)textLabel;

+ (CGRect)getLimitLabelRect:(UILabel *)label limitLine:(NSInteger)line;

@end
