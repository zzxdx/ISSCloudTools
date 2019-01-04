//
//  UITextView+HJCategory.h
//  Lamp
//
//  Created by huangjian on 2018/11/15.
//  Copyright © 2018 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UITextView (HJCategory)

@end

/// 输入长度限制
@interface UITextView (JKInputLimit)
@property (assign, nonatomic)  NSInteger jk_maxLength;//if <=0, no limit
@end

/// placeholder
@interface UITextView (JKPlaceHolder) <UITextViewDelegate>
@property (nonatomic, strong) UITextView *jk_placeHolderTextView;
- (void)jk_addPlaceHolder:(NSString *)placeHolder;
@end
