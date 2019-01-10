//
//  HJBaseTableVC.h
//  ISSCloudTools
//
//  Created by huangjian on 2019/1/4.
//  Copyright © 2019 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"

/// tableview状态
typedef NS_ENUM(NSInteger, HJBaseTableViewStatus) {
    /// 加载中
    HJBaseTableViewStatusLoading = 0,
    /// 网络错误
    HJBaseTableViewStatusNetError,
    /// 加载完成
    HJBaseTableViewStatusLoadFinish,
};
typedef void(^HJBaseTableVCRefreshBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HJBaseTableVC : UIViewController

@property (nonatomic, strong) HJBaseTableVCRefreshBlock refreshBlock;


/// tableview数据源
@property (nonatomic, strong) NSMutableArray *resultDataList;
@property (nonatomic, strong) NSMutableArray *tableData;

@property (nonatomic, strong) UITableView *mTableView;

/// tableview状态
@property (nonatomic, assign) HJBaseTableViewStatus tableViewStatus;

/// 是否设置空白页提示 默认YES
@property (nonatomic, assign) BOOL setEmptyDataSet;

- (instancetype)initWithStyle:(UITableViewStyle)style;

@end

NS_ASSUME_NONNULL_END
