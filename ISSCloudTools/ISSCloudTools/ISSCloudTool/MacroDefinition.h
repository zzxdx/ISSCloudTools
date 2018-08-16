//
//  MacroDefinition.h
//  ChargingPoleApp
//
//  Created by xiongjw on 2018/4/19.
//  Copyright © 2018年 huawei. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

/*RGB*/
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)                        RGBA(r,g,b,1)

#define UIColorFromRGBA(rgb,a)      [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:a]
#define UIColorFromRGB(rgb)         UIColorFromRGBA(rgb,1.0)
#define ClearColor                  [UIColor clearColor]

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

//屏幕尺寸
#define kMainScreenFrameRect                     [[UIScreen mainScreen] bounds]
#define kMainScreenStatusBarFrameRect            [[UIApplication sharedApplication] statusBarFrame]
#define kMainScreenHeight                        kMainScreenFrameRect.size.height
#define kMainScreenWidth                         kMainScreenFrameRect.size.width

//等比缩放
#define kWidet(W) (W/375.0f)*kMainScreenWidth
#define kHigh(H) (H/667.0f)*kMainScreenHeight

#define IPHONE_NAVIGATIONBAR_HEIGHT  (IS_iPhoneX ? 88 : 64)
#define IPHONE_STATUSBAR_HEIGHT      (IS_iPhoneX ? 44 : 20)
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_iPhoneX ? 34 : 0)
#define IPHONE_TOPSENSOR_HEIGHT      (IS_iPhoneX ? 32 : 0)

//字体
//字体大小定义
#define FontSIZE(F)                 [UIFont systemFontOfSize:F]
//方正黑体简体字体定义
#define FZFont(F)                   [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]
//粗体字体大小定义
#define BoldFontSIZE(F)             [UIFont boldSystemFontOfSize:F]

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

//NSUserDefaults相关
#define NSUSER(def) NSUserDefaults *def=[NSUserDefaults standardUserDefaults]
#define NSUSER_DEF_NORSET(a,b) [[NSUserDefaults standardUserDefaults]setValue:a forKey:b]
#define NSUSER_DEF(a)  [[NSUserDefaults standardUserDefaults] valueForKey:a]

//Toasts
#define HUDMAKE(MESSAGE) [[UIApplication sharedApplication].keyWindow hideAllToasts];\
[[UIApplication sharedApplication].keyWindow makeToast:MESSAGE duration:2 position:[CSToastManager defaultPosition]];\

#define  HUDHidenAll [[UIApplication sharedApplication].keyWindow hideAllToasts];


//获取AppDelegate
#define ShareApp                    ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define KeyWindow [UIApplication sharedApplication].keyWindow


#define LoadNibName(nibName) [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] firstObject];

//格式化
#define FormatString(...)       [NSString stringWithFormat: __VA_ARGS__]

//DEBUG  模式下打印日志,当前行
#ifdef Debug
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


#define WeakSelf(type)              __weak typeof(type) weak##type = type;
#define StrongSelf(type)            __strong typeof(type) strong##type = type;


//获取地址
#define ISSFilePathWithName(filename) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:[NSString stringWithFormat:@"/%@",filename]]

#endif /* MacroDefinition_h */
