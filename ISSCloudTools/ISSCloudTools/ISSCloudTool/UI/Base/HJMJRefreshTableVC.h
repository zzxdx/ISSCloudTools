//
//  HJMJRefreshTableVC.h
//  ISSCloudTools
//
//  Created by huangjian on 2019/1/4.
//  Copyright © 2019 huawei. All rights reserved.
//

#import "HJBaseTableVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMJRefreshTableVC : HJBaseTableVC
- (void)addHeaderAction;
- (void)addFooterAction;
- (void)addHeaderAndFooterAction;

- (void)headerBeginRefreshing;

- (void)endRefreshing;

/// 添加数据到tableview
- (void)addResultDataToList:(NSArray *)list direction:(NSString *)direction page:(NSInteger)page;
@end

NS_ASSUME_NONNULL_END
