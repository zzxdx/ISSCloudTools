//
//  UIButton+HJCategory.h
//  Lamp
//
//  Created by huangjian on 2018/11/15.
//  Copyright © 2018 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JKTouchedButtonBlock)(NSInteger tag);

@interface UIButton (HJCategory)

#pragma mark - 点击事件
-(void)jk_addActionHandler:(JKTouchedButtonBlock)touchHandler;

#pragma mark - 倒计时
-(void)jk_startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;

#pragma mark - 设置按钮额外热区
@property (nonatomic, assign) UIEdgeInsets jk_touchAreaInsets;

@end


typedef NS_ENUM(NSInteger, JKImagePosition) {
    LXMImagePositionLeft = 0,              //图片在左，文字在右，默认
    LXMImagePositionRight = 1,             //图片在右，文字在左
    LXMImagePositionTop = 2,               //图片在上，文字在下
    LXMImagePositionBottom = 3,            //图片在下，文字在上
};
@interface UIButton (JKImagePosition)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)jk_setImagePosition:(JKImagePosition)postion spacing:(CGFloat)spacing;

@end



@interface UIButton (JKIndicator)

/**
 This method will show the activity indicator in place of the button text.
 */
- (void)jk_showIndicator;

/**
 This method will remove the indicator and put thebutton text back in place.
 */
- (void)jk_hideIndicator;

@end


