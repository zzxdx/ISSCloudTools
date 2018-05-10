
#import <Foundation/Foundation.h>

@interface NSArray (Category)

+ (instancetype)safeArrayWithObject:(id)object;

- (id)safeObjectAtIndex:(NSUInteger)index;

- (NSArray *)safeSubarrayWithRange:(NSRange)range;

- (NSUInteger)safeIndexOfObject:(id)anObject;

// 数组转成json 字符串
- (NSString *)toJSONStringForArray;


@end
