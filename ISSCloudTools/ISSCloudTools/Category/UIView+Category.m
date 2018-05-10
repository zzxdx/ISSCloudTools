
#import "UIView+Category.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@implementation UIView (Category)

-(void) addToWindow
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(window)])
    {
        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
        [window addSubview:self];
    }
}

- (void) cutViewRoundStylebyRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end


@implementation UIView (Screenshot)

- (UIImage*) screenshot {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (UIImage *) screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset {
    UIGraphicsBeginImageContext(self.bounds.size);
    //need to translate the context down to the current visible portion of the scrollview
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, -contentOffset.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.55);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (UIImage*) screenshotInFrame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), frame.origin.x, frame.origin.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

/**
 针对有用过OpenGL渲染过的视图截图
 
 @return 截取的图片
 */
- (UIImage *)openglSnapshotImage
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = self.frame;
    [self drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

@end

@implementation UIView (Animation)

- (void) shakeAnimation {
    
    CALayer* layer = [self layer];
    CGPoint position = [layer position];
    CGPoint y = CGPointMake(position.x - 8.0f, position.y);
    CGPoint x = CGPointMake(position.x + 8.0f, position.y);
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08f];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}

- (void) trans180DegreeAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    }];
}
@end


@implementation NSObject (_XWAdd)

+ (void)xw_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)xw_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)xw_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)xw_removeAssociateWithKey:(void *)key {
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIImage (XWAddForRoundedCorner)

+ (UIImage *)xw_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock {
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)xw_maskRoundCornerRadiusImageWithColor:(UIColor *)color cornerRadii:(CGSize)cornerRadii size:(CGSize)size corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    return [UIImage xw_imageWithSize:size drawBlock:^(CGContextRef  _Nonnull context) {
        CGContextSetLineWidth(context, 0);
        [color set];
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectInset(rect, -0.3, -0.3)];
        UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 0.3, 0.3) byRoundingCorners:corners cornerRadii:cornerRadii];
        [rectPath appendPath:roundPath];
        CGContextAddPath(context, rectPath.CGPath);
        CGContextEOFillPath(context);
        if (!borderColor || !borderWidth) return;
        [borderColor set];
        UIBezierPath *borderOutterPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
        UIBezierPath *borderInnerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:cornerRadii];
        [borderOutterPath appendPath:borderInnerPath];
        CGContextAddPath(context, borderOutterPath.CGPath);
        CGContextEOFillPath(context);
    }];
}

@end



static void *const _XWMaskCornerRadiusLayerKey = "_XWMaskCornerRadiusLayerKey";
static NSMutableSet<UIImage *> *maskCornerRaidusImageSet;

@implementation CALayer (XWAddForRoundedCorner)

+ (void)load{
    [CALayer xw_swizzleInstanceMethod:@selector(layoutSublayers) with:@selector(_xw_layoutSublayers)];
}

- (UIImage *)contentImage{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)self.contents];
}

- (void)setContentImage:(UIImage *)contentImage{
    self.contents = (__bridge id)contentImage.CGImage;
}

- (void)xw_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color{
    [self xw_roundedCornerWithRadius:radius cornerColor:color corners:UIRectCornerAllCorners];
}

- (void)xw_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners{
    [self xw_roundedCornerWithCornerRadii:CGSizeMake(radius, radius) cornerColor:color corners:corners borderColor:nil borderWidth:0];
}

- (void)xw_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    if (!color) return;
    CALayer *cornerRadiusLayer = [self xw_getAssociatedValueForKey:_XWMaskCornerRadiusLayerKey];
    if (!cornerRadiusLayer) {
        cornerRadiusLayer = [CALayer new];
        cornerRadiusLayer.opaque = YES;
        [self xw_setAssociateValue:cornerRadiusLayer withKey:_XWMaskCornerRadiusLayerKey];
    }
    if (color) {
        [cornerRadiusLayer xw_setAssociateValue:color withKey:"_xw_cornerRadiusImageColor"];
    }else{
        [cornerRadiusLayer xw_removeAssociateWithKey:"_xw_cornerRadiusImageColor"];
    }
    [cornerRadiusLayer xw_setAssociateValue:[NSValue valueWithCGSize:cornerRadii] withKey:"_xw_cornerRadiusImageRadius"];
    [cornerRadiusLayer xw_setAssociateValue:@(corners) withKey:"_xw_cornerRadiusImageCorners"];
    if (borderColor) {
        [cornerRadiusLayer xw_setAssociateValue:borderColor withKey:"_xw_cornerRadiusImageBorderColor"];
    }else{
        [cornerRadiusLayer xw_removeAssociateWithKey:"_xw_cornerRadiusImageBorderColor"];
    }
    [cornerRadiusLayer xw_setAssociateValue:@(borderWidth) withKey:"_xw_cornerRadiusImageBorderWidth"];
    UIImage *image = [self _xw_getCornerRadiusImageFromSet];
    if (image) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = image;
        [CATransaction commit];
    }
    
}

- (UIImage *)_xw_getCornerRadiusImageFromSet{
    if (!self.bounds.size.width || !self.bounds.size.height) return nil;
    CALayer *cornerRadiusLayer = [self xw_getAssociatedValueForKey:_XWMaskCornerRadiusLayerKey];
    UIColor *color = [cornerRadiusLayer xw_getAssociatedValueForKey:"_xw_cornerRadiusImageColor"];
    if (!color) return nil;
    CGSize radius = [[cornerRadiusLayer xw_getAssociatedValueForKey:"_xw_cornerRadiusImageRadius"] CGSizeValue];
    NSUInteger corners = [[cornerRadiusLayer xw_getAssociatedValueForKey:"_xw_cornerRadiusImageCorners"] unsignedIntegerValue];
    CGFloat borderWidth = [[cornerRadiusLayer xw_getAssociatedValueForKey:"_xw_cornerRadiusImageBorderWidth"] floatValue];
    UIColor *borderColor = [cornerRadiusLayer xw_getAssociatedValueForKey:"_xw_cornerRadiusImageBorderColor"];
    if (!maskCornerRaidusImageSet) {
        maskCornerRaidusImageSet = [NSMutableSet new];
    }
    __block UIImage *image = nil;
    [maskCornerRaidusImageSet enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
        CGSize imageSize = [[obj xw_getAssociatedValueForKey:"_xw_cornerRadiusImageSize"] CGSizeValue];
        UIColor *imageColor = [obj xw_getAssociatedValueForKey:"_xw_cornerRadiusImageColor"];
        CGSize imageRadius = [[obj xw_getAssociatedValueForKey:"_xw_cornerRadiusImageRadius"] CGSizeValue];
        NSUInteger imageCorners = [[obj xw_getAssociatedValueForKey:"_xw_cornerRadiusImageCorners"] unsignedIntegerValue];
        CGFloat imageBorderWidth = [[obj xw_getAssociatedValueForKey:"_xw_cornerRadiusImageBorderWidth"] floatValue];
        UIColor *imageBorderColor = [obj xw_getAssociatedValueForKey:"_xw_cornerRadiusImageBorderColor"];
        BOOL isBorderSame = (CGColorEqualToColor(borderColor.CGColor, imageBorderColor.CGColor) && borderWidth == imageBorderWidth) || (!borderColor && !imageBorderColor) || (!borderWidth && !imageBorderWidth);
        BOOL canReuse = CGSizeEqualToSize(self.bounds.size, imageSize) && CGColorEqualToColor(imageColor.CGColor, color.CGColor) && imageCorners == corners && CGSizeEqualToSize(radius, imageRadius) && isBorderSame;
        if (canReuse) {
            image = obj;
            *stop = YES;
        }
    }];
    if (!image) {
        image = [UIImage xw_maskRoundCornerRadiusImageWithColor:color cornerRadii:radius size:self.bounds.size corners:corners borderColor:borderColor borderWidth:borderWidth];
        [image xw_setAssociateValue:[NSValue valueWithCGSize:self.bounds.size] withKey:"_xw_cornerRadiusImageSize"];
        [image xw_setAssociateValue:color withKey:"_xw_cornerRadiusImageColor"];
        [image xw_setAssociateValue:[NSValue valueWithCGSize:radius] withKey:"_xw_cornerRadiusImageRadius"];
        [image xw_setAssociateValue:@(corners) withKey:"_xw_cornerRadiusImageCorners"];
        if (borderColor) {
            [image xw_setAssociateValue:color withKey:"_xw_cornerRadiusImageBorderColor"];
        }
        [image xw_setAssociateValue:@(borderWidth) withKey:"_xw_cornerRadiusImageBorderWidth"];
        [maskCornerRaidusImageSet addObject:image];
    }
    return image;
}

#pragma mark - exchage Methods

- (void)_xw_layoutSublayers{
    [self _xw_layoutSublayers];
    CALayer *cornerRadiusLayer = [self xw_getAssociatedValueForKey:_XWMaskCornerRadiusLayerKey];
    if (cornerRadiusLayer) {
        UIImage *aImage = [self _xw_getCornerRadiusImageFromSet];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = aImage;
        cornerRadiusLayer.frame = self.bounds;
        [CATransaction commit];
        [self addSublayer:cornerRadiusLayer];
    }
}

@end

@implementation UIView (XWAddForRoundedCorner)

- (void)xw_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color{
    [self.layer xw_roundedCornerWithRadius:radius cornerColor:color];
}

- (void)xw_roundedCornerWithRadius:(CGFloat)radius cornerColor:(UIColor *)color corners:(UIRectCorner)corners{
    [self.layer xw_roundedCornerWithRadius:radius cornerColor:color corners:corners];
}

- (void)xw_roundedCornerWithCornerRadii:(CGSize)cornerRadii cornerColor:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    [self.layer xw_roundedCornerWithCornerRadii:cornerRadii cornerColor:color corners:corners borderColor:borderColor borderWidth:borderWidth];
}

@end

