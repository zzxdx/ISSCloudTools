//
//  HJCreateUIHelper.h
//  ISSCloudTools
//
//  Created by huangjian on 2019/1/4.
//  Copyright © 2019 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJCreateUIHelper : NSObject
//********************创建TextField***************************/

+ (UITextField *)makeTextField:(id)delegate
                     withFrame:(CGRect)frame
                     maxLength:(NSInteger)maxLength;

+ (UITextField *)makeTextField:(id)delegate
                     withFrame:(CGRect)frame
                andPlaceholder:(NSString *)holder
                     maxLength:(NSInteger)maxLength;

+ (UITextField *)makeTextField:(id)delegate
                     withFrame:(CGRect)frame
                        andTag:(NSInteger)tag
                andPlaceholder:(NSString *)holder
                     maxLength:(NSInteger)maxLength;
@end

NS_ASSUME_NONNULL_END
