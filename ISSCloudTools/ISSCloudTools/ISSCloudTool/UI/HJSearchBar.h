//
//  HJSearchBar.h
//  ISSCloudTools
//
//  Created by huangjian on 2019/1/4.
//  Copyright © 2019 huawei. All rights reserved.
//

/*
 //文字在中间的searchBar
 - (HsusueSearchBar *)customSearchBar
 {
 if (!_customSearchBar) {
 _customSearchBar = [[HsusueSearchBar alloc] initWithFrame:CGRectMake(10, 5, kMainScreenWidth-20, 44.0f)];
 _customSearchBar.delegate = self;
 _customSearchBar.showsCancelButton = NO;
 _customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
 _customSearchBar.placeholder = @"搜索订单";
 // 设置占位文字字体
 [_customSearchBar cleanOtherSubViews];
 }
 return _customSearchBar;
 }
 
 /// 系统searchbar
 - (UISearchBar *)searchBar
 {
 if (!_searchBar) {
 _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth - 20, 44.0f)];
 _searchBar.delegate = self;
 [_searchBar setTintColor:[UIColor whiteColor]];
 _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
 _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
 [_searchBar setPlaceholder:@"请输入试卷名称模糊搜索"];
 UIImage* searchBarBg = [UIImage GetImageWithColor:[UIColor clearColor] andHeight:44.0f];
 [_searchBar setBackgroundImage:searchBarBg];
 _searchBar.layer.borderWidth = 0.5;
 _searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
 _searchBar.layer.cornerRadius = 5;
 }
 return _searchBar;
 }*/

// 默认白色背景 5.0f无边框圆角  占位符字体大小15.0f
#import <UIKit/UIKit.h>

@interface HJSearchBar : UISearchBar
// searchBar的textField
@property (nonatomic, weak) UITextField *textField;

/**
 清除搜索条以外的控件
 */
- (void)cleanOtherSubViews;
@end


