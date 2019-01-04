//
//  UILabel+HJCategory.m
//  Lamp
//
//  Created by huangjian on 2018/11/15.
//  Copyright © 2018 huawei. All rights reserved.
//

#import "UILabel+HJCategory.h"
#import <objc/runtime.h>
#import "HJLabelHelper.h"

@implementation UILabel (HJCategory)
#pragma mark - 倒计时
-(void)jk_startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle{
    __block NSInteger timeOut=timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.text = [NSString stringWithFormat:@"%@00:00:00",tittle];
            });
        }else{
            //            int minutes = timeout / 60;
            NSInteger days = (int)(timeout/(3600*24));
            NSInteger hours = (int)((timeout-days*24*3600)/3600);
            NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
            NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
            hours = hours + days*24;
            NSString *strTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minute, second];
            
//            int seconds = (int)timeOut;
//            NSString *strTime = [NSString stringWithFormat:@"%ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                self.text = [NSString stringWithFormat:@"%@%@",waitTittle,strTime];
                
            });
            timeOut--;
            
        }
    });
    dispatch_resume(_timer);
}

@end


//最常见的label 颜色
#define DefaultColor    UIColorFromRGB(0x333333)
#define UIColorFromRGBA(rgb,a)      [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:a]
#define UIColorFromRGB(rgb)         UIColorFromRGBA(rgb,1.0)

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
        label.frame = [HJLabelHelper getLabelRect:label];
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
        label.frame = [HJLabelHelper getLabelRect:label];
    }
    return label;
}

@end



NSTimeInterval const UILabelAWDefaultDuration = 0.4f;

unichar const UILabelAWDefaultCharacter = 124;

static inline void jk_AutomaticWritingSwizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static char kAutomaticWritingOperationQueueKey;
static char kAutomaticWritingEdgeInsetsKey;


@implementation UILabel (JKAutomaticWriting)

@dynamic jk_automaticWritingOperationQueue, jk_edgeInsets;

#pragma mark - Public Methods

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jk_AutomaticWritingSwizzleSelector([self class], @selector(textRectForBounds:limitedToNumberOfLines:), @selector(jk_automaticWritingTextRectForBounds:limitedToNumberOfLines:));
        jk_AutomaticWritingSwizzleSelector([self class], @selector(drawTextInRect:), @selector(jk_drawAutomaticWritingTextInRect:));
    });
}

-(void)jk_drawAutomaticWritingTextInRect:(CGRect)rect
{
    [self jk_drawAutomaticWritingTextInRect:UIEdgeInsetsInsetRect(rect, self.jk_edgeInsets)];
}

- (CGRect)jk_automaticWritingTextRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [self jk_automaticWritingTextRectForBounds:UIEdgeInsetsInsetRect(bounds, self.jk_edgeInsets) limitedToNumberOfLines:numberOfLines];
    return textRect;
}

- (void)setJk_edgeInsets:(UIEdgeInsets)edgeInsets
{
    objc_setAssociatedObject(self, &kAutomaticWritingEdgeInsetsKey, [NSValue valueWithUIEdgeInsets:edgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)jk_edgeInsets
{
    NSValue *edgeInsetsValue = objc_getAssociatedObject(self, &kAutomaticWritingEdgeInsetsKey);
    
    if (edgeInsetsValue)
    {
        return edgeInsetsValue.UIEdgeInsetsValue;
    }
    
    edgeInsetsValue = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero];
    
    objc_setAssociatedObject(self, &kAutomaticWritingEdgeInsetsKey, edgeInsetsValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return edgeInsetsValue.UIEdgeInsetsValue;
}

- (void)setJk_automaticWritingOperationQueue:(NSOperationQueue *)automaticWritingOperationQueue
{
    objc_setAssociatedObject(self, &kAutomaticWritingOperationQueueKey, automaticWritingOperationQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSOperationQueue *)jk_automaticWritingOperationQueue
{
    NSOperationQueue *operationQueue = objc_getAssociatedObject(self, &kAutomaticWritingOperationQueueKey);
    
    if (operationQueue)
    {
        return operationQueue;
    }
    
    operationQueue = NSOperationQueue.new;
    operationQueue.name = @"Automatic Writing Operation Queue";
    operationQueue.maxConcurrentOperationCount = 1;
    
    objc_setAssociatedObject(self, &kAutomaticWritingOperationQueueKey, operationQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return operationQueue;
}

- (void)jk_setTextWithAutomaticWritingAnimation:(NSString *)text
{
    [self jk_setText:text automaticWritingAnimationWithBlinkingMode:UILabelJKlinkingModeNone];
}

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithBlinkingMode:(UILabelJKlinkingMode)blinkingMode
{
    [self jk_setText:text automaticWritingAnimationWithDuration:UILabelAWDefaultDuration blinkingMode:blinkingMode];
}

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration
{
    [self jk_setText:text automaticWritingAnimationWithDuration:duration blinkingMode:UILabelJKlinkingModeNone];
}

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(UILabelJKlinkingMode)blinkingMode
{
    [self jk_setText:text automaticWritingAnimationWithDuration:duration blinkingMode:blinkingMode blinkingCharacter:UILabelAWDefaultCharacter];
}

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(UILabelJKlinkingMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter
{
    [self jk_setText:text automaticWritingAnimationWithDuration:duration blinkingMode:blinkingMode blinkingCharacter:blinkingCharacter completion:nil];
}

- (void)jk_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(UILabelJKlinkingMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter completion:(void (^)(void))completion
{
    self.jk_automaticWritingOperationQueue.suspended = YES;
    self.jk_automaticWritingOperationQueue = nil;
    
    self.text = @"";
    
    NSMutableString *automaticWritingText = NSMutableString.new;
    
    if (text)
    {
        [automaticWritingText appendString:text];
    }
    
    [self.jk_automaticWritingOperationQueue addOperationWithBlock:^{
        [self jk_automaticWriting:automaticWritingText duration:duration mode:blinkingMode character:blinkingCharacter completion:completion];
    }];
}

#pragma mark - Private Methods

- (void)jk_automaticWriting:(NSMutableString *)text duration:(NSTimeInterval)duration mode:(UILabelJKlinkingMode)mode character:(unichar)character completion:(void (^)(void))completion
{
    NSOperationQueue *currentQueue = NSOperationQueue.currentQueue;
    if ((text.length || mode >= UILabelJKlinkingModeWhenFinish) && !currentQueue.isSuspended)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (mode != UILabelJKlinkingModeNone)
            {
                if ([self jk_isLastCharacter:character])
                {
                    [self jk_deleteLastCharacter];
                }
                else if (mode != UILabelJKlinkingModeWhenFinish || !text.length)
                {
                    [text insertString:[self jk_stringWithCharacter:character] atIndex:0];
                }
            }
            
            if (text.length)
            {
                [self jk_appendCharacter:[text characterAtIndex:0]];
                [text deleteCharactersInRange:NSMakeRange(0, 1)];
                if ((![self jk_isLastCharacter:character] && mode == UILabelJKlinkingModeWhenFinishShowing) || (!text.length && mode == UILabelJKlinkingModeUntilFinishKeeping))
                {
                    [self jk_appendCharacter:character];
                }
            }
            
            if (!currentQueue.isSuspended)
            {
                [currentQueue addOperationWithBlock:^{
                    [self jk_automaticWriting:text duration:duration mode:mode character:character completion:completion];
                }];
            }
            else if (completion)
            {
                completion();
            }
        });
    }
    else if (completion)
    {
        completion();
    }
}

- (NSString *)jk_stringWithCharacter:(unichar)character
{
    return [self jk_stringWithCharacters:@[@(character)]];
}

- (NSString *)jk_stringWithCharacters:(NSArray *)characters
{
    NSMutableString *string = NSMutableString.new;
    
    for (NSNumber *character in characters)
    {
        [string appendFormat:@"%C", character.unsignedShortValue];
    }
    
    return string.copy;
}

- (void)jk_appendCharacter:(unichar)character
{
    [self jk_appendCharacters:@[@(character)]];
}

- (void)jk_appendCharacters:(NSArray *)characters
{
    self.text = [self.text stringByAppendingString:[self jk_stringWithCharacters:characters]];
}

- (BOOL)jk_isLastCharacters:(NSArray *)characters
{
    if (self.text.length >= characters.count)
    {
        return [self.text hasSuffix:[self jk_stringWithCharacters:characters]];
    }
    return NO;
}

- (BOOL)jk_isLastCharacter:(unichar)character
{
    return [self jk_isLastCharacters:@[@(character)]];
}

- (BOOL)jk_deleteLastCharacters:(NSUInteger)characters
{
    if (self.text.length >= characters)
    {
        self.text = [self.text substringToIndex:self.text.length-characters];
        return YES;
    }
    return NO;
}

- (BOOL)jk_deleteLastCharacter
{
    return [self jk_deleteLastCharacters:1];
}

@end

