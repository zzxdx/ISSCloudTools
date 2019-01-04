//
//  UITextView+HJCategory.m
//  Lamp
//
//  Created by huangjian on 2018/11/15.
//  Copyright © 2018 huawei. All rights reserved.
//

#import "UITextView+HJCategory.h"
#import <objc/runtime.h>

@implementation UITextView (HJCategory)

@end


static const void *JKTextViewInputLimitMaxLength = &JKTextViewInputLimitMaxLength;
/// 输入长度限制
@implementation UITextView (JKInputLimit)
- (NSInteger)jk_maxLength {
    return [objc_getAssociatedObject(self, JKTextViewInputLimitMaxLength) integerValue];
}
- (void)setJk_maxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, JKTextViewInputLimitMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jk_textViewTextDidChange:)
                                                name:@"UITextViewTextDidChangeNotification" object:self];
    
}
- (void)jk_textViewTextDidChange:(NSNotification *)notification {
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //在iOS7下,position对象总是不为nil
    if ( (!position ||!selectedRange) && (self.jk_maxLength > 0 && toBeString.length > self.jk_maxLength))
    {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.jk_maxLength];
        if (rangeIndex.length == 1)
        {
            self.text = [toBeString substringToIndex:self.jk_maxLength];
        }
        else
        {
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.jk_maxLength)];
            NSInteger tmpLength;
            if (rangeRange.length > self.jk_maxLength) {
                tmpLength = rangeRange.length - rangeIndex.length;
            }else{
                tmpLength = rangeRange.length;
            }
            self.text = [toBeString substringWithRange:NSMakeRange(0, tmpLength)];
        }
    }
}
+ (void)load {
    [super load];
    Method origMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method newMethod = class_getInstanceMethod([self class], @selector(jk_textView_limit_swizzledDealloc));
    method_exchangeImplementations(origMethod, newMethod);
}
- (void)jk_textView_limit_swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self jk_textView_limit_swizzledDealloc];
}
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
@end


static const char *jk_placeHolderTextView = "jk_placeHolderTextView";
/// placeholder
@implementation UITextView (JKPlaceHolder)
- (UITextView *)jk_placeHolderTextView {
    return objc_getAssociatedObject(self, jk_placeHolderTextView);
}
- (void)setJk_placeHolderTextView:(UITextView *)placeHolderTextView {
    objc_setAssociatedObject(self, jk_placeHolderTextView, placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)jk_addPlaceHolder:(NSString *)placeHolder {
    if (![self jk_placeHolderTextView]) {
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.font = self.font;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor grayColor];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        [self setJk_placeHolderTextView:textView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
        
    }
    self.jk_placeHolderTextView.text = placeHolder;
}
# pragma mark -
# pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(NSNotification *)noti {
    self.jk_placeHolderTextView.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)noti {
    if (self.text && [self.text isEqualToString:@""]) {
        self.jk_placeHolderTextView.hidden = NO;
    }
}
+ (void)load {
    [super load];
    Method origMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method newMethod = class_getInstanceMethod([self class], @selector(jk_textView_placeholder_swizzledDealloc));
    method_exchangeImplementations(origMethod, newMethod);
}
- (void)jk_textView_placeholder_swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self jk_textView_placeholder_swizzledDealloc];
}
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
@end
