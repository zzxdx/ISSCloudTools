//
//  HJCountDownManager.h
//  工程多多
//
//  Created by huangjian on 2018/12/23.
//  Copyright © 2018 com.LinkGap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCCountdown.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJCountDownManager : NSObject
@property (nonatomic, strong) HCCountdown *countdown;
@property (nonatomic) long nowTimeSp;
@property (nonatomic) long endTimeSp;
@end

NS_ASSUME_NONNULL_END
