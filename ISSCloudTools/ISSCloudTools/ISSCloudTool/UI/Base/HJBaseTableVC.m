//
//  HJBaseTableVC.m
//  ISSCloudTools
//
//  Created by huangjian on 2019/1/4.
//  Copyright © 2019 huawei. All rights reserved.
//

#import "HJBaseTableVC.h"

@interface HJBaseTableVC () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    UITableViewStyle _tableViewStyle;
}

@end

@implementation HJBaseTableVC

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _tableViewStyle = style;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.setEmptyDataSet = YES;
    [self.view addSubview:self.mTableView];
    self.mTableView.contentInsetAdjustmentBehavior = NO;
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - DZNEmptyDataSetSource

- (void)setTableViewStatus:(HJBaseTableViewStatus)tableViewStatus
{
    _tableViewStatus = tableViewStatus;
    // 每次 状态被修改，就刷新空白页面。
    [self.mTableView reloadEmptyDataSet];
}

#pragma mark 设置空白页图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.setEmptyDataSet) {
        switch (self.tableViewStatus) {
            case HJBaseTableViewStatusLoading:
                // 圆形加载图片
                return [UIImage imageNamed:@"pic_netLoading"];
                break;
            case HJBaseTableViewStatusNetError:
                // 网络加载失败、超时
                return [UIImage imageNamed:@"pic_net"];
                break;
            case HJBaseTableViewStatusLoadFinish:
                // 无数据
                return [UIImage imageNamed:@"pic_nodata"];
                break;
            default:
                break;
        }
    } else {
        return nil;
    }
}

#pragma mark 图片旋转动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.setEmptyDataSet) {
        if (self.tableViewStatus == HJBaseTableViewStatusNetError) {
            NSString *text = @"网络不给力，请点击重试哦~";
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
            // 设置所有字体大小为 #15
            [attStr addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:15.0]
                           range:NSMakeRange(0, text.length)];
            // 设置所有字体颜色为浅灰色
            [attStr addAttribute:NSForegroundColorAttributeName
                           value:[UIColor lightGrayColor]
                           range:NSMakeRange(0, text.length)];
            // 设置指定4个字体为蓝色
            [attStr addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:NSMakeRange(7, 4)];
            return attStr;
        }
        if (self.tableViewStatus == HJBaseTableViewStatusLoadFinish) {
            NSString *text = @"很抱歉，暂时没有数据。";
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
            // 设置所有字体大小为 #15
            [attStr addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:15.0]
                           range:NSMakeRange(0, text.length)];
            // 设置所有字体颜色为浅灰色
            [attStr addAttribute:NSForegroundColorAttributeName
                           value:[UIColor lightGrayColor]
                           range:NSMakeRange(0, text.length)];
            return attStr;
        }
        return nil;
    } else {
        return nil;
    }
}


#pragma mark - DZNEmptyDataSetDelegate
#pragma mark 是否开启动画
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    if (self.tableViewStatus == HJBaseTableViewStatusLoading) {
        return YES;
    }
    return NO;
}

#pragma mark 空白页面被点击时刷新页面
/// 视图点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    // 空白页面被点击时开启动画，reloadEmptyDataSet
    self.tableViewStatus = HJBaseTableViewStatusLoading;
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}
/// 按钮点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    self.tableViewStatus = HJBaseTableViewStatusLoading;
    self.refreshBlock();
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    // 如果正在加载中，则不响应用户交互。
    switch (self.tableViewStatus) {
        case HJBaseTableViewStatusLoading:
            
            return NO;
            break;
        case HJBaseTableViewStatusNetError:
            
            return YES;
            break;
        case ISSBaseTableViewStatusLoadFinish:
            
            return YES;
            break;
        default:
            break;
    }
}

/// 设置空白页面的背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

- (UITableView *)mTableView
{
    if (_mTableView == nil) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight    - IPHONE_SAFEBOTTOMAREA_HEIGHT) style:_tableViewStyle];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mTableView.tag = 99;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        _mTableView.emptyDataSetSource= self;
        _mTableView.emptyDataSetDelegate= self;
        _mTableView.separatorColor = UIColorFromRGB(0xd9d9d9);
        
        [_mTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.backgroundColor = RGB(244, 243, 254);
        
        _mTableView.backgroundView = nil;
        //        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _mTableView;
}

- (NSMutableArray *)resultDataList
{
    if (!_resultDataList) {
        _resultDataList = [NSMutableArray array];
    }
    return _resultDataList;
}

@end

