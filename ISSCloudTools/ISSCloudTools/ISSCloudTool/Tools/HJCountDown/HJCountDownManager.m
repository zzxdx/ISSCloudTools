//
//  HJCountDownManager.m
//  工程多多
//
//  Created by huangjian on 2018/12/23.
//  Copyright © 2018 com.LinkGap. All rights reserved.
//

#import "HJCountDownManager.h"

@implementation HJCountDownManager


- (void)beginTimeOut
{
    /// 1.viewDidLoad 里
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    _countdown = [[HCCountdown alloc] init];
    
//    //现在时间
//    NSDate *datenow = [NSDate date];
//
//    //获取当前时间的时间戳 long
//    long timeSpam = [_countdown timeStampWithDate:datenow];
//
//    //获取当前时间 NSSting
//    NSString *timeStr = [_countdown getNowTimeString];
//
//    //时间戳转时间
//    NSString *timeStrWithSpam = [_countdown dateWithTimeStamp:timeSpam];
//
//    NSLog(@"timeSpam = %ld", timeSpam);
//    NSLog(@"timeDate = %@", timeStr);
//    NSLog(@"timeStrWithSpam = %@", timeStrWithSpam);
}

/// 2.copy
#pragma mark - time
- (void)didInBackground: (NSNotification *)notification {
    
    NSLog(@"倒计时进入后台");
    [_countdown destoryTimer];
}

- (void)willEnterForground: (NSNotification *)notification {
    
    NSLog(@"倒计时进入前台");
    [self getNowTimeSP:@"" endSP:@""];  //进入前台重新获取当前的时间戳，在进行倒计时， 主要是为了解决app退到后台倒计时停止的问题，缺点就是不能防止用户更改本地时间造成的倒计时错误
}

- (void)getNowTimeSP:(NSString *)string endSP:(NSString *)endTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY年MM月dd日HH:mm:ss"];
    
    //现在时间
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString_1 = [formatter stringFromDate:datenow];
    NSDate *applyTimeString_1 = [formatter dateFromString:currentTimeString_1];
    _nowTimeSp = (long long)[applyTimeString_1 timeIntervalSince1970];
    
    //    if ([string isEqualToString:@"开始"]) {
    //结束时间
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//根据自己的需求定义格式
    NSDate* endDate = [formater dateFromString:endTime];
    _endTimeSp = [endDate timeIntervalSince1970];
    //    }
    
    
    //时间戳进行倒计时
    long startLong = _nowTimeSp;
    long finishLong = _endTimeSp;
    [self startLongLongStartStamp:startLong longlongFinishStamp:finishLong];
    
    NSLog(@"currentTimeString_1 = %@", currentTimeString_1);
    NSLog(@"_nowTimeSp = %ld", _nowTimeSp);
    NSLog(@"_endTimeSp = %ld", _endTimeSp);
    
}
///此方法用两个时间戳做参数进行倒计时
-(void)startLongLongStartStamp:(long)strtL longlongFinishStamp:(long) finishL {
    __weak __typeof(self) weakSelf= self;
    
    NSLog(@"second = %ld, minute = %ld", strtL, finishL);
    
    [_countdown countDownWithStratTimeStamp:strtL finishTimeStamp:finishL completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        
        [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
    }];
}

- (void)refreshUIDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
//    [self.tiemView refreshUIHour:(hour+day*24) minute:minute second:second];
    
    if (second == 0 && minute == 0) {
        
        [_countdown destoryTimer];
    }
    
}

- (void)dealloc {
    
    [_countdown destoryTimer];  //控制器释放的时候一点要停止计时器，以免再次进入发生错误
}

@end
