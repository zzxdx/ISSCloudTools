//
//  HJMJRefreshTableVC.m
//  ISSCloudTools
//
//  Created by huangjian on 2019/1/4.
//  Copyright © 2019 huawei. All rights reserved.
//

#import "HJMJRefreshTableVC.h"

@interface HJMJRefreshTableVC () <UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HJMJRefreshTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mTableView];
    self.tableViewStatus = ISSBaseTableViewStatusLoading;
    self.resultDataList = [NSMutableArray new];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.mTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    if ([self.mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark -  user method
- (void)addHeaderAction
{
    self.mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
}

- (void)headerRereshing {
    [self performSelector:@selector(requestDataReresh:) withObject:@"down"];
}

- (void)addFooterAction
{
    self.mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)footerRereshing {
    [self performSelector:@selector(requestDataReresh:) withObject:@"up"];
}

- (void)addHeaderAndFooterAction
{
    [self addHeaderAction];
    [self addFooterAction];
}

- (void)requestDataReresh:(NSString *)direction {
    
}

- (void)headerBeginRefreshing {
    [self.mTableView.mj_header beginRefreshing];
}

- (void)endRefreshing
{
    if (self.mTableView.mj_header.isRefreshing) {
        [self.mTableView.mj_header endRefreshing];
    }
    if (self.mTableView.mj_footer.isRefreshing) {
        [self.mTableView.mj_footer endRefreshing];
    }
}

- (void)addResultDataToList:(NSArray *)list direction:(NSString *)direction page:(NSInteger)page
{
    if ([@"down" isEqualToString:direction])
    {
        [self.mTableView.mj_footer resetNoMoreData];
        
        [self.resultDataList removeAllObjects];
    }
    
    [self.resultDataList addObjectsFromArray:list];
    [self.mTableView reloadData];
    [self endRefreshing];
    
    if (list.count == 0 && page == 1)
    {
        [self.mTableView.mj_footer setHidden:YES];
    } else {
        [self.mTableView.mj_footer setHidden:NO];
    }
    
    if (list.count < PageSize)
    {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
        
    }
    
    self.tableViewStatus = ISSBaseTableViewStatusLoadFinish;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
