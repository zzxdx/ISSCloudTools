
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (Category)

- (NSString *)safeSubstringFromIndex:(NSUInteger)from;

- (NSString *)safeSubstringToIndex:(NSUInteger)to;

- (NSString *)safeSubstringWithRange:(NSRange)range;

- (NSRange)safeRangeOfString:(NSString *)aString;

- (NSRange)safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask;

- (NSString *)safeStringByAppendingString:(NSString *)aString;

/**
 *  NSString转为NSNumber
 *
 *  @return NSNumber
 */
- (NSNumber*) toNumber;

/**
 计算文字高度
 
 @param fontSize 字体
 @param width 最大宽度
 @return <#return value description#>
 */
- (CGFloat  ) heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width;

/**
 计算文字宽度

 @param fontSize 字体
 @param maxHeight 最大高度
 @return <#return value description#>
 */
- (CGFloat  ) widthWithFontSize:(CGFloat)fontSize height:(CGFloat)maxHeight;
/**
 抹除小数末尾的0

 @return <#return value description#>
 */
- (NSString*) removeUnwantedZero;

/**
 //去掉前后空格

 @return <#return value description#>
 */
- (NSString*) trimmedString;

/**
 *  判断字符串是不是空
 *
 *  @return YES-空，NO-不空
 */
- (BOOL) isEmptyString;

@end
