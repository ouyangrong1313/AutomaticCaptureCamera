//  UIView+MJ.m
//  Created by 刘辉 on 2018/2/1.
//  Copyright © 2018年 私塾家. All rights reserved.

#import "UIView+SSView.h"
#import <objc/runtime.h>
#import "UIColor+SSStringToColor.h"
#import "_XYColor_PrivateView.h"

@implementation UIView (SSView)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}
-(CGFloat)top{
    return self.frame.origin.y;
}

-(CGFloat)bottom{
    return self.frame.size.height + self.frame.origin.y;
}

-(CGFloat)left{
    return self.frame.origin.x;
}

-(CGFloat)right{
    return self.frame.size.width + self.frame.origin.x;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setTop:(CGFloat)top{
    self.frame = CGRectMake(self.frame.origin.x, top, self.frame.size.width, self.frame.size.height);
}

-(void)setLeft:(CGFloat)left{
    self.frame = CGRectMake(left, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

-(void)setBottom:(CGFloat)bottom{
    self.frame = CGRectMake(self.frame.origin.x, bottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

-(void)setRight:(CGFloat)right{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, right - self.frame.size.width, self.frame.size.height);
}

-(void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

-(void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

/**
 *  系统的设置圆角方法
 *
 *  @param corneradius 圆角半径
 *  @param borderColor 边框颜色
 *  @param borderWidth 边框宽度
 */
- (void)setSystemCorneradius:(CGFloat)corneradius withColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth {
    self.layer.cornerRadius = corneradius;
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    }
    if (borderWidth) {
        self.layer.borderWidth = borderWidth;
    }
    self.layer.masksToBounds = YES;
}


/*
 设置圆角
 corneradius 圆角半径
 borderColor 边界颜色
 borderWidth 边界宽度
 */
- (void)setCorneradius:(CGFloat)corneradius withColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth {
    [self setupCorneradius:corneradius];
    [self setupborderWidth:borderWidth borderColor:borderColor];
}
/**
 *  设置圆角
 */
- (void)setupCorneradius:(CGFloat)corneradius {
    self.layer.cornerRadius = corneradius;
    self.layer.masksToBounds = YES;
}

//上部分切圆角
- (void)setUpAbovePartCorneradius:(CGSize)size {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:size].CGPath;
    self.layer.masksToBounds = YES;
    self.layer.mask = maskLayer;
}
//下部分切圆角
- (void)setUpBelowPartCorneradius:(CGSize)size {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:size].CGPath;
    self.layer.masksToBounds = YES;
    self.layer.mask = maskLayer;
}

/**
 *  设置圆角  用UIBezierPath 画的
 */
- (void)setupBezierCorneradius:(CGFloat)corneradius
{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:corneradius];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
}

/**
 * 设置部分圆角(绝对布局)
 * @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 * @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}
/**
  * 设置部分圆角(相对布局)
 * @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 * @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 * @param rect 需要设置的圆角view的rect */
- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii viewRect:(CGRect)rect {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

/**
 *  设置边框
 */
- (void)setupborderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    self.layer.borderWidth = borderWidth;
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    }
}

/**
 *  创建导航栏的状态栏
 */
+ (UIView *)setupBarStatueView
{
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ([UIScreen mainScreen].bounds.size.width), 20)];
    statusBarView.backgroundColor = UIColorFromHex(COLOR_FAFAFA);
    return statusBarView;
}

/**
 *  设置自身背景渐变色
 *
 *  @param colors       渐变色的数组，包含的元素为CGColor，数组包含的是对象要转化为id类型。（(id)[[[UIColor blackColor] colorWithAlphaComponent:1]CGColor]）
 *  @param locations    位置数组，各渐变色的位置，［0-1］
 *  @param beginPoint   起始点
 *  @param endPoint     结束点
 */
+ (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame withColors:(NSArray<id> *)colors withLocations:(NSArray <NSNumber *>*)locations withBeginPoint:(CGPoint)beginPoint withEndPoint:(CGPoint)endPoint {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    CGRect newGradientLayerFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    gradientLayer.frame = newGradientLayerFrame;
    //添加渐变的颜色组合
    if (colors.count) { //有颜色才设置，否则结束
        gradientLayer.colors = colors;
    }
    else {
        return nil;
    }

    if (locations.count) {
        gradientLayer.locations = locations;
    }
    gradientLayer.startPoint = beginPoint;
    gradientLayer.endPoint = endPoint;
    //例如
//    gradientLayer.startPoint = CGPointMake(0,0);
//    gradientLayer.endPoint = CGPointMake(1,1);
    return gradientLayer;
}

#pragma mark - *** 离屏渲染处理 by chenzl copy from github  ***
- (void)setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    
    [self setCornerRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
}

- (void)setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    
    [self setJMRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
}

- (void)setCornerRadius:(CGFloat)radius withBackgroundColor:(UIColor *)backgroundColor {
    
    [self setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
}

- (void)setJMRadius:(JMRadius)radius withBackgroundColor:(UIColor *)backgroundColor {
    
    [self setJMRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
}

- (void)setCornerRadius:(CGFloat)radius withImage:(UIImage *)image {
    
    [self setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}

- (void)setJMRadius:(JMRadius)radius withImage:(UIImage *)image {
    
    [self setJMRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}

- (void)setCornerRadius:(CGFloat)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    
    [self setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];
}

- (void)setJMRadius:(JMRadius)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    
    [self setJMRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];
}

- (void)setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode {
    
    [self setJMRadius:JMRadiusMake(radius, radius, radius, radius) withBorderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:contentMode];
}

- (void)setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode {
    
    [self setNeedsLayout];
    NSValue *radiusValue = [NSValue valueWithBytes:&radius objCType:@encode(JMRadius)];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"radius"] = radiusValue;
    
    if (borderColor)
        dic[@"borderColor"] = borderColor;
    else
        dic[@"borderColor"] = NSNull.null;
    
    dic[@"borderWidth"] = [NSNumber numberWithFloat:borderWidth];
    
    if (backgroundColor)
        dic[@"backgroundColor"] = backgroundColor;
    else
        dic[@"backgroundColor"] = NSNull.null;

    if (backgroundImage)
        dic[@"backgroundImage"] = backgroundImage;
    else
        dic[@"backgroundImage"] = NSNull.null;
    
    dic[@"contentMode"] = [NSNumber numberWithFloat:contentMode];
    
    [self performSelector:@selector(setRadius:) withObject:dic afterDelay:0 inModes:@[NSRunLoopCommonModes]];
}

- (void)setRadius:(NSMutableDictionary *)dic {
    
    JMRadius radius;
    [dic[@"radius"] getValue:&radius];
    UIColor *borderColor;
    UIColor *backgroundColor;
    UIImage *backgroundImage;
    
    if (dic[@"borderColor"] == NSNull.null)
        borderColor = nil;
    else
        borderColor = dic[@"borderColor"];
    
    if (dic[@"backgroundColor"] == NSNull.null)
        backgroundColor = nil;
    else
        backgroundColor = dic[@"backgroundColor"];
    
    if (dic[@"backgroundImage"] == NSNull.null)
        backgroundImage = nil;
    else
        backgroundImage = dic[@"backgroundImage"];
    
    [self setJMRadius:radius withBorderColor:borderColor borderWidth:[dic[@"borderWidth"] floatValue] backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:[dic[@"contentMode"] integerValue] size:self.bounds.size];
}

- (void)setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode size:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
       
        return;
    }
    size = CGSizeMake(pixel(size.width), pixel(size.height));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage jm_imageWithRoundedCornersAndSize:size JMRadius:radius borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage withContentMode:contentMode];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.frame = CGRectMake(pixel(self.frame.origin.x), pixel(self.frame.origin.y), size.width, size.height);
            if ([self isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)self).image = image;
            } else if ([self isKindOfClass:[UIButton class]] && backgroundImage) {
                [((UIButton *)self) setBackgroundImage:image forState:UIControlStateNormal];
            } else if ([self isKindOfClass:[UILabel class]]) {
                self.layer.backgroundColor = [UIColor colorWithPatternImage:image].CGColor;
            } else {
                self.layer.contents = (__bridge id _Nullable)(image.CGImage);
            }
        });
    });
}

extern float pixel(float num) {
    
    float unit = 1.0 / [UIScreen mainScreen].scale;
    double remain = fmod(num, unit);
    return num - remain + (remain >= unit / 2.0? unit: 0);
}


/**
 *  抖动
 *
 *  @param viewToShake
 */
-(void)shakeView
{
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    self.transform = translateLeft;

    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        self.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.04 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

/*
 周边加阴影，并且同时圆角
 */
- (void)addShadow:(UIColor *)color
      withOpacity:(float)shadowOpacity
     shadowRadius:(CGFloat)shadowRadius
  andCornerRadius:(CGFloat)cornerRadius
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = self.layer.frame;
    
    shadowLayer.shadowColor = color.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [self.superview.layer insertSublayer:shadowLayer below:self.layer];
}

-(void)setBackGroundColor {
    self.backgroundColor = [UIColor generateDynamicColor:UIColorFromHex(COLOR_FFFFFF) darkColor:UIColorFromHex(COLOR_000000)];
}

+ (UINib *)xw_nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+(instancetype)xw_getInstanceFromXib{
    UINib *nib = [self xw_nib];
    
    id myObject = [[nib instantiateWithOwner:nil options:nil] lastObject];
    if ([myObject isKindOfClass:[[self class] class]])
        return myObject;
    
    NSArray *nibLets = [nib instantiateWithOwner:nil options:nil];
    for (myObject in nibLets)
    {
        if ([myObject isKindOfClass:[[self class] class]])
            return myObject;
    }
    
    return nil;
}

- (__kindof UIViewController *)xw_getViewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
    
}
+ (UIView *)gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint]; return view;
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.colors = [colorsM copy];
    self.locations = locations;
    self.startPoint = startPoint;
    self.endPoint = endPoint;
}

//相对布局；
- (void)setBorderWithReTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width {
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, self.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }

}

- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, width);
        //layer.backgroundColor = color.CGColor;
        [layer xy_setLayerBackgroundColor:color with:self];
        [self.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, self.frame.size.height);
        //layer.backgroundColor = color.CGColor;
        [layer xy_setLayerBackgroundColor:color with:self];
        [self.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
        //layer.backgroundColor = color.CGColor;
        [layer xy_setLayerBackgroundColor:color with:self];
        [self.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height);
        //layer.backgroundColor = color.CGColor;
        [layer xy_setLayerBackgroundColor:color with:self];
        [self.layer addSublayer:layer];
    }
}
//top YES 表示顶部边框变白
- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right hideColor:(UIColor *)hideColor borderColor:(UIColor *)color borderWidth:(CGFloat)width applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *temp = [CAShapeLayer layer];
    temp.lineWidth = width * 2;
    temp.fillColor = [UIColor clearColor].CGColor;
    if (@available(iOS 13.0, *)) {
        if (self.pv == nil) { self.pv = [_XYColor_PrivateView new]; }
        __weak CAShapeLayer *weakLayer = temp;
        [self.pv traitCollectionChange:^{
            weakLayer.strokeColor = [color resolvedColorWithTraitCollection:self.traitCollection].CGColor;
        }];
        temp.strokeColor = [color resolvedColorWithTraitCollection:self.traitCollection].CGColor;
    } else {
        temp.strokeColor = color.CGColor;
    }
    temp.frame = self.bounds;
    temp.path = path.CGPath;
    [self.layer addSublayer:temp];
    
    CAShapeLayer *mask = [[CAShapeLayer alloc]initWithLayer:temp];
    mask.path = path.CGPath;
    self.layer.mask = mask;
    
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(width, -5, self.frame.size.width - 2 * width, width + 6);
        //layer.backgroundColor = hideColor.CGColor;
        [layer xy_setLayerBackgroundColor:hideColor with:self];
        [self.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, width, width + 2, self.frame.size.height - 2 * width);
        //layer.backgroundColor = hideColor.CGColor;
        [layer xy_setLayerBackgroundColor:hideColor with:self];
        [self.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(width, self.frame.size.height - width - 4, self.frame.size.width - 2 * width, width + 8);
        //layer.backgroundColor = hideColor.CGColor;
        [layer xy_setLayerBackgroundColor:hideColor with:self];
        [self.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.frame.size.width - width, width, width + 2, self.frame.size.height - 2 * width);
        //layer.backgroundColor = hideColor.CGColor;
        [layer xy_setLayerBackgroundColor:hideColor with:self];
        [self.layer addSublayer:layer];
    }
    
}

/**
  ** lineView:       需要绘制成虚线的view
  ** lineLength:     虚线的宽度
  ** lineSpacing:    虚线的间距
  ** lineColor:      虚线的颜色
  **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
      CAShapeLayer *shapeLayer = [CAShapeLayer layer];
      [shapeLayer setBounds:lineView.bounds];
      [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
      [shapeLayer setFillColor:[UIColor clearColor].CGColor];
      //  设置虚线颜色为blackColor
      [shapeLayer setStrokeColor:lineColor.CGColor];
      //  设置虚线宽度
      [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
      [shapeLayer setLineJoin:kCALineJoinRound];
      //  设置线宽，线间距
      [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
      //  设置路径
      CGMutablePathRef path = CGPathCreateMutable();
      CGPathMoveToPoint(path, NULL, 0, 0);
      CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
      [shapeLayer setPath:path];
      CGPathRelease(path);
      //  把绘制好的虚线添加上来
      [lineView.layer addSublayer:shapeLayer];
}

@end
