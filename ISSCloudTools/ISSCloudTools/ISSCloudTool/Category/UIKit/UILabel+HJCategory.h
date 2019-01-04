//
//  UILabel+HJCategory.h
//  Lamp
//
//  Created by huangjian on 2018/11/15.
//  Copyright © 2018 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UILabel (HJCategory)

#pragma mark - 倒计时
-(void)jk_startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;

@end


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
                      color:(UIColor *)colorxcgn
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



//! Project version number for UILabel-AutomaticWriting.
FOUNDATION_EXPORT double UILabelAutomaticWritingVersionNumber;

//! Project version string for UILabel-AutomaticWriting.
FOUNDATION_EXPORT const unsigned char UILabelAutomaticWritingVersionString[];

extern NSTimeInterval const UILabelAWDefaultDuration;

extern unichar const UILabelAWDefaultCharacter;

typedef NS_ENUM(NSInteger, UILabelJKlinkingMode)
{
    UILabelJKlinkingModeNone,
    UILabelJKlinkingModeUntilFinish,
    UILabelJKlinkingModeUntilFinishKeeping,
    UILabelJKlinkingModeWhenFinish,
    UILabelJKlinkingModeWhenFinishShowing,
    UILabelJKlinkingModeAlways
};

@interface UILabel (JKAutomaticWriting)

@property (strong, nonatomic) NSOperationQueue *jk_automaticWritingOperationQueue;
@property (assign, nonatomic) UIEdgeInsets jk_edgeInsets;

- (void)jk_setTextWithAutomaticWritingAnimation:(NSString *)text;

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithBlinkingMode:(UILabelJKlinkingMode)blinkingMode;

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration;

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(UILabelJKlinkingMode)blinkingMode;

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(UILabelJKlinkingMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter;

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(UILabelJKlinkingMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter completion:(void (^)(void))completion;

@end

