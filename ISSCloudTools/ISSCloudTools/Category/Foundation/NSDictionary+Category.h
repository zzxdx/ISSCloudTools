
#import <Foundation/Foundation.h>

@interface NSDictionary (Category)

- (id)safeObjectForKey:(NSString *)key;

/// 设置键值对 针对对象为空处理
- (void)safeSetObject:(id)object forKey:(id)key;

- (id)objectForKeyCustom:(id)aKey;

- (id)safeKeyForValue:(id)value;

/// 字段转成json的字符串
- (NSString *)toJSONStringForDictionary;

@end
