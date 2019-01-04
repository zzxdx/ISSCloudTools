//
//  UITextField+HJCategory.h
//  Lamp
//
//  Created by huangjian on 2018/11/15.
//  Copyright © 2018 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UITextField (HJCategory)

@end




@interface UITextField (JKInputLimit)
@property (assign, nonatomic)  NSInteger jk_maxLength;//if <=0, no limit
@end
