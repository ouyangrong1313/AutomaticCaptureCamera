//
//  UIButton+CCExtension.h
//  Created by 刘辉 on 2018/2/6.
//  Copyright © 2018年 私塾家. All rights reserved.

#import <UIKit/UIKit.h>

typedef void (^TouchedBlock)(UIButton *btn);

typedef NS_ENUM(NSUInteger, SSButtonEdgeInsetsStyle) {
    SSButtonEdgeInsetsStyleTop, // image在上，label在下
    SSButtonEdgeInsetsStyleLeft, // image在左，label在右
    SSButtonEdgeInsetsStyleBottom, // image在下，label在上
    SSButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (SSExtension)


-(void)addTouchUpInsideHandler:(TouchedBlock)handler;

//button不同状态的背景颜色（代替图片）
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/**
 *  设置属性文字
 *
 *  @param textArr   需要显示的文字数组,如果有换行请在文字中添加 "\n"换行符
 *  @param fontArr   字体数组, 如果fontArr与textArr个数不相同则获取字体数组中最后一个字体
 *  @param colorArr  颜色数组, 如果colorArr与textArr个数不相同则获取字体数组中最后一个颜色
 *  @param spacing   换行的行间距
 *  @param alignment 换行的文字对齐方式
 */
- (void)setAttriStrWithTextArray:(NSArray *)textArr fontArr:(NSArray *)fontArr colorArr:(NSArray *)colorArr lineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment;


/**
 *  初始化一个按钮 没有边框的 背景颜色是蓝色的  椭圆
 */
+ (UIButton *)buttonTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  创建一个button 按钮size为 25*25 实际图片大小为17.5*17.5 UI要求
 *
 */
+ (UIButton *)buttonMustItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(SSButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

- (void)xy_setLayerBackgroundColor:(UIColor *)color forState:(UIControlState)state;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;


@end
