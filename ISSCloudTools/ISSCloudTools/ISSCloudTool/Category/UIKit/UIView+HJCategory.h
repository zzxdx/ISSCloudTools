//
//  UIView+HJCategory.h
//  Lamp
//
//  Created by huangjian on 2018/11/15.
//  Copyright © 2018 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (HJCategory)
/// 把View加在Window上
- (void) addToWindow;
/// 裁剪view
- (void) cutViewRoundStylebyRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end


typedef void (^JKGestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (JKBlockGesture)
/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)jk_addTapActionWithBlock:(JKGestureActionBlock)block;
/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)jk_addLongPressActionWithBlock:(JKGestureActionBlock)block;
@end



typedef NS_OPTIONS(NSUInteger, JKExcludePoint) {
    JKExcludeStartPoint = 1 << 0,
    JKExcludeEndPoint = 1 << 1,
    JKExcludeAllPoint = ~0UL
};

@interface UIView (JKCustomBorder)

- (void)jk_addTopBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth;
- (void)jk_addLeftBorderWithColor: (UIColor *) color width:(CGFloat) borderWidth;
- (void)jk_addBottomBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth;
- (void)jk_addRightBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth;

- (void)jk_removeTopBorder;
- (void)jk_removeLeftBorder;
- (void)jk_removeBottomBorder;
- (void)jk_removeRightBorder;


- (void)jk_addTopBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(JKExcludePoint)edge;
- (void)jk_addLeftBorderWithColor: (UIColor *) color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(JKExcludePoint)edge;
- (void)jk_addBottomBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(JKExcludePoint)edge;
- (void)jk_addRightBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(JKExcludePoint)edge;
@end


@interface UIView (Frame)

//view.frame=CGRectMake(x,y,z,o)
- (CGFloat)left;
- (CGFloat)right;
- (CGSize)size;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGFloat)maxX;
- (CGFloat)maxY;

- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setSize:(CGSize)size;
- (void)setTop:(CGFloat)top;
- (void)setBottom:(CGFloat)bottom;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setOrigin:(CGPoint)point;
- (void)setAddTop:(CGFloat)top;
- (void)setAddLeft:(CGFloat)left;

@end


@interface UIView (Screenshot)

/// View截图
- (UIImage*) screenshot;

/// ScrollView截图 contentOffset
- (UIImage*) screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

/// View按Rect截图
- (UIImage*) screenshotInFrame:(CGRect)frame;

/**
 针对有用过OpenGL渲染过的视图截图
 
 @return 截取的图片
 */
- (UIImage *)openglSnapshotImage;

@end

@interface UIView (Animation)

//左右抖动动画
- (void) shakeAnimation;

//旋转180度
- (void) trans180DegreeAnimation;

@end

@interface UIView (XWAddForRoundedCorner)


/**
 设置一个四角圆角
 
 @param radius 圆角半径
 @param color  圆角背景色
 */
- (void)xw_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color;

/**
 设置一个普通圆角
 
 @param radius  圆角半径
 @param color   圆角背景色
 @param corners 圆角位置
 */
- (void)xw_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners;

/**
 设置一个带边框的圆角
 
 @param cornerRadii 圆角半径cornerRadii
 @param color       圆角背景色
 @param corners     圆角位置
 @param borderColor 边框颜色
 @param borderWidth 边框线宽
 */
- (void)xw_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
@end

@interface CALayer (XWAddForRoundedCorner)

@property (nonatomic, strong) UIImage *contentImage;//contents的便捷设置

/**如下分别对应UIView的相应API*/

- (void)xw_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color;

- (void)xw_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners;

- (void)xw_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end


