//
//  HJLabelHelper.m
//  ISSCloudTools
//
//  Created by huangjian on 2019/1/4.
//  Copyright © 2019 huawei. All rights reserved.
//

#import "HJLabelHelper.h"

@implementation HJLabelHelper

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

+ (NSMutableAttributedString *)setLabelShadow:(NSString *)value offset:(CGFloat)y
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:value];
    if (value.length == 0) {
        return attributed;
    }
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = RGBA(0, 0, 0, 8);
    shadow.shadowOffset = CGSizeMake(0, y);
    
    [attributed addAttributes:@{NSForegroundColorAttributeName :UIColorFromRGBA(0xffffff, 1) ,
                                NSShadowAttributeName : shadow
                                }
                        range:NSMakeRange(0, value.length)];
    return attributed;
}

+ (NSMutableAttributedString *)setLabelAttributed:(NSString *)value
                                            range:(NSRange)range
                                            color:(UIColor *)color
                                             font:(UIFont *)font
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:value];
    if (value.length == 0) {
        return attributed;
    }
    [attributed addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attributed addAttribute:NSFontAttributeName value:font range:range];
    
    return attributed;
}

@end

