//
//  HJLabelHelper.h
//  ISSCloudTools
//
//  Created by huangjian on 2019/1/4.
//  Copyright © 2019 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJLabelHelper : NSObject
+ (CGFloat)getLabelHeight:(CGFloat)contentWidth font:(UIFont *)font text:(NSString *)text;
+ (CGFloat)getLabelHeight:(UILabel *)label;

+ (CGSize)getLabelSize:(NSString *)value font:(UIFont *)font;
+ (CGSize)getLabelSize:(UILabel *)label;

+ (CGRect)getLabelRect:(UILabel *)textLabel;

+ (CGRect)getOneLineLabelRect:(UILabel *)textLabel;

+ (CGRect)getLimitLabelRect:(UILabel *)label limitLine:(NSInteger)line;

+ (NSMutableAttributedString *)setLabelShadow:(NSString *)value offset:(CGFloat)y;

+ (NSMutableAttributedString *)setLabelAttributed:(NSString *)value
                                            range:(NSRange)range
                                            color:(UIColor *)color
                                             font:(UIFont *)font;



@end

NS_ASSUME_NONNULL_END
