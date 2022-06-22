//  UIView+MJ.h
//  Created by 刘辉 on 2018/2/1.
//  Copyright © 2018年 Liew. All rights reserved.


#import <UIKit/UIKit.h>
#import "UIImage+SSImage.h"

@interface UIView (SSView)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

@property (nonatomic,assign) CGFloat bottom;  //底部
@property (nonatomic,assign) CGFloat top;     //顶部
@property (nonatomic,assign) CGFloat left;    //左边
@property (nonatomic,assign) CGFloat right;   //右边
@property (nonatomic,assign) CGFloat width;   //宽度
@property (nonatomic,assign) CGFloat height;  //高度

@property(nullable, copy) NSArray *colors;
@property(nullable, copy) NSArray<NSNumber *> *locations;
@property CGPoint startPoint;
@property CGPoint endPoint;

/**
 *  系统的设置圆角方法
 
 *  @param corneradius 圆角半径
 *  @param borderColor 边框颜色
 *  @param borderWidth 边框宽度
 */
- (void)setSystemCorneradius:(CGFloat)corneradius withColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth;

/*
 设置圆角
 corneradius 圆角半径
 borderColor 边界颜色
 borderWidth 边界宽度
 */
- (void)setCorneradius:(CGFloat)corneradius withColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth;
/**
 *  设置圆角
 */
- (void)setupCorneradius:(CGFloat)corneradius;

//上部分切圆角
- (void)setUpAbovePartCorneradius:(CGSize)size;

//下部分切圆角
- (void)setUpBelowPartCorneradius:(CGSize)size;

/** * 设置部分圆角(绝对布局)
 * @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 * @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;

/** * 设置部分圆角(相对布局)
 *
 * @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 * @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 * @param rect 需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii viewRect:(CGRect)rect;

/**
 *  设置圆角  用UIBezierPath 画的
 */
- (void)setupBezierCorneradius:(CGFloat)corneradius;

/**
 *  设置边框
 */
- (void)setupborderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  设置自身背景渐变色
 *
 *  @param frame      frame
 *  @param colors     渐变色的数组，包含的元素为CGColor，数组包含的是对象要转化为id类型。（(id)[[[UIColor blackColor] colorWithAlphaComponent:1]CGColor]）
 *  @param locations  位置数组，各渐变色的位置，［0-1］
 *  @param beginPoint 起始点
 *  @param endPoint   结束点
 *
 *  @return 返回渐变层
 */
+ (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame withColors:(NSArray<id> *)colors withLocations:(NSArray <NSNumber *>*)locations withBeginPoint:(CGPoint)beginPoint withEndPoint:(CGPoint)endPoint;

/**
 *  创建导航栏的状态栏
 */
+ (UIView *)setupBarStatueView;

/**给view设置一个圆角边框*/
- (void)setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**给view设置一个圆角边框,四个圆角弧度可以不同*/
- (void)setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;


/**给view设置一个圆角背景颜色*/
- (void)setCornerRadius:(CGFloat)radius withBackgroundColor:(UIColor *)backgroundColor;

/**给view设置一个圆角背景颜色,四个圆角弧度可以不同*/
- (void)setJMRadius:(JMRadius)radius withBackgroundColor:(UIColor *)backgroundColor;


/**给view设置一个圆角背景图*/
- (void)setCornerRadius:(CGFloat)radius withImage:(UIImage *)image;

///**给view设置一个圆角背景图,四个圆角弧度可以不同*/
- (void)setJMRadius:(JMRadius)radius withImage:(UIImage *)image;


/**给view设置一个contentMode模式的圆角背景图*/
- (void)setCornerRadius:(CGFloat)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode;

///**给view设置一个contentMode模式的圆角背景图,四个圆角弧度可以不同*/
- (void)setJMRadius:(JMRadius)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode;


/**设置所有属性配置出一个圆角背景图*/
- (void)setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode;

/**设置所有属性配置出一个圆角背景图,四个圆角弧度可以不同*/
- (void)setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode;

/**设置所有属性配置出一个圆角背景图，并多传递了一个size参数，如果JMRoundedCorner没有拿到view的size，可以调用这个方法*/
- (void)setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode size:(CGSize)size;


/**
 *  抖动
 */
-(void)shakeView;

/*
 周边加阴影，并且同时圆角
 */
- (void)addShadow:(UIColor *)color
      withOpacity:(float)shadowOpacity
     shadowRadius:(CGFloat)shadowRadius
  andCornerRadius:(CGFloat)cornerRadius;

/*
* 设置暗黑模式
*/
-(void)setBackGroundColor;

+ (UINib *)xw_nib;

+ (instancetype)xw_getInstanceFromXib;

//获取view的ViewController
- (__kindof UIViewController *)xw_getViewController;

+ (UIView *_Nullable)gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;
- (void)setBorderWithReTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;
- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right hideColor:(UIColor *)hideColor borderColor:(UIColor *)color borderWidth:(CGFloat)width applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius;
// 绘制虚线
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
