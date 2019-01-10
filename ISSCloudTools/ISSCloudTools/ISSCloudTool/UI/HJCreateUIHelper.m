//
//  HJCreateUIHelper.m
//  ISSCloudTools
//
//  Created by huangjian on 2019/1/4.
//  Copyright © 2019 huawei. All rights reserved.
//

#import "HJCreateUIHelper.h"
#import "UITextField+HJCategory.h"
#import "MacroDefinition.h"

@implementation HJCreateUIHelper
//********************创建TextField***************************/

+ (UITextField *)makeTextField:(id)delegate
                     withFrame:(CGRect)frame
                     maxLength:(NSInteger)maxLength
{
    return [self makeTextField:delegate withFrame:frame andPlaceholder:@"" maxLength:maxLength];
}

+ (UITextField *)makeTextField:(id)delegate
                     withFrame:(CGRect)frame
                andPlaceholder:(NSString *)holder
                     maxLength:(NSInteger)maxLength
{
    return [self makeTextField:delegate withFrame:frame andTag:0 andPlaceholder:holder maxLength:maxLength];
}

+ (UITextField *) makeTextField:(id)delegate
                      withFrame:(CGRect)frame
                         andTag:(NSInteger)tag
                 andPlaceholder:(NSString *)holder
                      maxLength:(NSInteger)maxLength
{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.tintColor = UIColorFromRGB(0x616161);
    textField.placeholder = holder;
    
    //[textField setAttributedPlaceholder:<#(NSAttributedString * _Nullable)#>];ios10
    [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor = UIColorFromRGB(0x616161);
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
    textField.font = [UIFont systemFontOfSize:14];
    
    textField.backgroundColor = [UIColor clearColor];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;    // no auto correction support
    textField.keyboardType = UIKeyboardTypeDefault;
    
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;    // has a clear 'x' button to the right
    
    textField.tag = tag;
    
    [textField setAccessibilityLabel:@"textField"];
    
    //textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textField.text = @"";
    if (delegate) textField.delegate = delegate;    // let us be the delegate so we know when the keyboard's "Done" button is pressed
    
    if (maxLength > 0) {
        textField.jk_maxLength = (int)maxLength;
    }
    
    return textField;
}

@end
