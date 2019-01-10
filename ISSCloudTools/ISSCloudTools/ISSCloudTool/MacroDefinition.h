//
//  MacroDefinition.h
//  ChargingPoleApp
//
//  Created by huangjian on 2018/4/19.
//  Copyright © 2018年 huawei. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

/*RGB*/
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)                        RGBA(r,g,b,1)

#define UIColorFromRGBA(rgb,a)      [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:a]
#define UIColorFromRGB(rgb)         UIColorFromRGBA(rgb,1.0)
//系统版本>=11
#define IOS11 ([[[UIDevice currentDevice] systemVersion] integerValue] >= 11)

//判断iPhad
#define IS_iPadmini ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_iPad ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone4/4s
#define IS_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone5/5s
#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6/6s/7/8
#define IS_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6+/6s+/7+/8+
#define IS_iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhoneX
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhoneXR
#define IS_iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhoneXS
#define IS_iPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhoneXSMax
#define IS_iPhoneXS_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

//屏幕尺寸
#define kMainScreenFrameRect                     [[UIScreen mainScreen] bounds]
#define kMainScreenStatusBarFrameRect            [[UIApplication sharedApplication] statusBarFrame]

#define kMainScreenHeight                        kMainScreenFrameRect.size.height
#define kMainScreenWidth                         kMainScreenFrameRect.size.width


#define IPHONE_NAVIGATIONBAR_HEIGHT  ((IS_iPhoneX == YES || IS_iPhoneXR ==YES || IS_iPhoneXS == YES || IS_iPhoneXS_Max == YES) ? 88.0 : 64.0)
#define IPHONE_STATUSBAR_HEIGHT      ((IS_iPhoneX == YES || IS_iPhoneXR ==YES || IS_iPhoneXS == YES || IS_iPhoneXS_Max == YES) ? 44.0 : 20.0)
#define IPHONE_SAFEBOTTOMAREA_HEIGHT ((IS_iPhoneX == YES || IS_iPhoneXR ==YES || IS_iPhoneXS == YES || IS_iPhoneXS_Max == YES) ? 34 : 0)
#define IPHONE_TOPSENSOR_HEIGHT      ((IS_iPhoneX == YES || IS_iPhoneXR ==YES || IS_iPhoneXS == YES || IS_iPhoneXS_Max == YES) ? 32 : 0)
#define Height_TabBar ((IS_iPhoneX == YES || IS_iPhoneXR == YES || IS_iPhoneXS == YES || IS_iPhoneXS_Max == YES) ? 83.0 : 49.0)


//字体
#define GOTHAM_BOOK(FONT_SIZE)         [UIFont fontWithName:@"Gotham-Book" size:FONT_SIZE] // Gotham Book
#define HEL_NEUE(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE] // Helvetica Neue
#define HEL_NEUE_REGULAR(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE] // Helvetica Neue Regular
#define HEL_NEUE_MEDIUM(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Medium" size:FONT_SIZE] // Helvetica Neue Medium
#define HEL_NEUE_LIGHT(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE] // Helvetica Neue Light
#define HEL_NEUE_THIN(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Thin" size:FONT_SIZE]; // Helvetica Neue Thin
#define HEL_NEUE_BOLD(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Bold" size:FONT_SIZE]; // Helvetica Neue Bold
#define HEL_OOBE_NEUE_BOLD(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Bold" size:FONT_SIZE] // Helvetica Neue Bold

//单例声明的公用函数
#define SINGLETON_FOR_HEADER(className) \
+ (className *)sharedInstance;

//单例实现的公用方法
#define SINGLETON_FOR_CLASS(className) \
+ (className *)sharedInstance { \
static className *shared = nil; \
static dispatch_once_t once_Token; \
dispatch_once(&once_Token, ^{ \
shared = [[self alloc] init]; \
}); \
return shared; \
}

//#define HUDMAKE(MESSAGE) [[UIApplication sharedApplication].keyWindow hideAllToasts];\
//[[UIApplication sharedApplication].keyWindow makeToast:MESSAGE duration:2 position:CSToastPositionCenter];\
//#define  HUDHidenAll [[UIApplication sharedApplication].keyWindow hideAllToasts];


//获取AppDelegate
#define ShareApp                    ((AppDelegate *)[[UIApplication sharedApplication] delegate])

///是否为空或是[NSNull null]
#define NOTNILANDNULL(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define ISNILORNULL(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
///字符串是否为空
#define ISSTREMPTY(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
///数组是否为空
#define ISARREMPTY(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))


#define LoadNibName(nibName) [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] firstObject];
#define KeyWindow [UIApplication sharedApplication].keyWindow

#define WeakSelf(type)              __weak typeof(type) weak##type = type;
#define StrongSelf(type)            __strong typeof(type) strong##type = type;
#define WS(weakSelf)                __weak __typeof(&*self)weakSelf = self;


//获取地址
#define ISSFilePathWithName(filename) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:[NSString stringWithFormat:@"/%@",filename]]


#endif /* MacroDefinition_h */
