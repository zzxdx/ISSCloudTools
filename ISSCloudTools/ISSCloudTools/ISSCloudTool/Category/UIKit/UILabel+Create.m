//
//  UILabel+Create.m
//  AXGY
//
//  Created by xiongjw on 16/5/26.
//  Copyright © 2016年 xiongjw. All rights reserved.
//

#import "UILabel+Create.h"

//最常见的label 颜色
#define DefaultColor   [UIColor colorWithRed:((float)((0x333333 & 0xFF0000) >> 16))/255.0 green:((float)((0x333333 & 0xFF00) >> 8))/255.0 blue:((float)(0x333333 & 0xFF))/255.0 alpha:1.0]

@implementation UILabel (Create)

// -------------------------------以下为创建单行label-------------------------------
+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                       text:(NSString *)text
{
    return [self oneLineLbWithX:x y:y fontSize:14 color:DefaultColor text:text];
}

+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                   fontSize:(CGFloat)fontSize
                       text:(NSString *)text
{
    return [self oneLineLbWithX:x y:y fontSize:fontSize color:DefaultColor text:text];
}

+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      color:(UIColor *)color
                       text:(NSString *)text
{
    return [self oneLineLbWithX:x y:y fontSize:14 color:color text:text];
}

+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                   fontSize:(CGFloat)fontSize
                      color:(UIColor *)color
                       text:(NSString *)text
{
    return [self oneLineLbWithX:x y:y width:0 fontSize:fontSize color:color text:text];
}

//width>0 text.length>0 两者必须满足其一,下面这个方法一般在自定义cell中创建控件时出现
+ (UILabel *)oneLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize
                      color:(UIColor *)color
                       text:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGRect rect;
    if (width > 0)
    {
        //表示固定宽度了
        rect = CGRectMake(x, y, width, font.lineHeight);
    }
    else
    {
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
        rect = CGRectMake(x, y, size.width, size.height);
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.numberOfLines = 1;
    label.font = font;
    label.textColor = color;
    label.text = text;
    return label;
}

// -------------------------------以下为创建多行label-------------------------------
+ (UILabel *)mutLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                       text:(NSString *)text
{
    return [self mutLineLbWithX:x y:y width:width fontSize:14 color:DefaultColor text:text];
}

+ (UILabel *)mutLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize
                       text:(NSString *)text
{
    return [self mutLineLbWithX:x y:y width:width fontSize:fontSize color:DefaultColor text:text];
}

+ (UILabel *)mutLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                      color:(UIColor *)color
                       text:(NSString *)text
{
    return [self mutLineLbWithX:x y:y width:width fontSize:14 color:color text:text];
}

+ (UILabel *)mutLineLbWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize
                      color:(UIColor *)color
                       text:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, font.lineHeight)];
    label.numberOfLines = 0;
    label.text = text;
    label.font = font;
    label.textColor = color;
    if (text.length > 0)
    {
        label.frame = [UILabel getLabelRect:label];
    }
    return label;
}


// -------------------------------以前的方式创建label-------------------------------
+ (UILabel *)initWithFrame:(CGRect)frame
                      text:(NSString *)text
{
    return [self initWithFrame:frame color:DefaultColor text:text singleLine:YES];
}

+ (UILabel *)initWithFrame:(CGRect)frame
                     color:(UIColor *)color
                      text:(NSString *)text
                singleLine:(BOOL)oneLine
{
    return [self initWithFrame:frame font:[UIFont systemFontOfSize:14] color:color text:text singleLine:oneLine];
}

+ (UILabel *)initWithFrame:(CGRect)frame
                      font:(UIFont *)font
                     color:(UIColor *)color
                      text:(NSString *)text
                singleLine:(BOOL)oneLine
{
    return [self initWithFrame:frame font:font color:color text:text alignment:NSTextAlignmentLeft singleLine:oneLine];
}

+ (UILabel *)initWithFrame:(CGRect)frame
                      font:(UIFont *)font
                     color:(UIColor *)color
                      text:(NSString *)text
                 alignment:(NSTextAlignment)alignment
                singleLine:(BOOL)oneLine
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (!oneLine) label.numberOfLines = 0;
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = alignment;
    if (text.length > 0 && !oneLine) {
        label.frame = [UILabel getLabelRect:label];
    }
    return label;
}

@end

@implementation UILabel (Helper)

+ (CGFloat)getLabelHeight:(CGFloat)contentWidth font:(UIFont *)font text:(NSString *)text
{
    return [self getLabelSize:contentWidth fontType:font label:text].height;
}

+ (CGFloat)getLabelHeight:(UILabel *)label {
    return [self getLabelSize:CGRectGetWidth(label.frame) fontType:label.font label:label.text].height;
}

+ (CGSize)getLabelSize:(CGFloat)contentWidth fontType:(UIFont *)font label:(NSString *)text
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                        options:(NSStringDrawingTruncatesLastVisibleLine |
                                                 NSStringDrawingUsesLineFragmentOrigin |
                                                 NSStringDrawingUsesFontLeading)
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

+ (CGSize)getLabelSize:(NSString *)value font:(UIFont *)font
{
    CGSize size = [value sizeWithAttributes:@{NSFontAttributeName : font}];
    return size;
}

+ (CGSize)getLabelSize:(UILabel *)label
{
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName : label.font}];
    return size;
}

+ (CGRect)getOneLineLabelRect:(UILabel *)textLabel
{
    CGRect rect = textLabel.frame;
    rect.size = [textLabel.text sizeWithAttributes:@{NSFontAttributeName:textLabel.font}];
    return rect;
}

+ (CGRect)getLabelRect:(UILabel *)textLabel
{
    CGRect rect = textLabel.frame;
    //rect.size.height = [self getLabelHeight:textLabel]+1;
    rect.size.height = [self getLabelHeight:textLabel];
    return rect;
}

+ (CGRect)getLimitLabelRect:(UILabel *)label limitLine:(NSInteger)line
{
    CGRect rect = [self getLabelRect:label];
    if (line == 1) {
        return rect;
    }
    NSMutableString *testString = [NSMutableString new];
    for (int i = 0; i < line - 1; i++) {
        [testString appendString:@"\r"];
    }
    CGSize testSize = [testString sizeWithAttributes:@{NSFontAttributeName : label.font}];
    if (rect.size.height > (testSize.height + 1)) {
        rect.size.height = testSize.height + 1;
    }
    
    return rect;
}


@end
