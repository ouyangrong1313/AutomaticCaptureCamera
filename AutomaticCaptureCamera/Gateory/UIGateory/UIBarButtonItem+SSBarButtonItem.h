//
//  UIBarButtonItem+SSBarButtonItem.h
//  Created by 刘辉 on 2018/2/6.
//  Copyright © 2018年 私塾家. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SSBarButtonItem)
/**
 *  创建一个BarButtonItem按照图片本身的大小
 *
 *  @param image     正常下的图片
 *  @param highImage 高亮下的图片
 *  @param target    target
 *  @param action    回调
 *
 */
+ (instancetype)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
/**
 *  创建一个BarButtonItem按照指定的大小
 *
 *  @param image     正常下的图片
 *  @param highImage 高亮下的图片
 *  @param target    target
 *  @param action    回调
 *
 */
+ (instancetype)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage size:(CGSize)size target:(id)target action:(SEL)action;

/**
 *  创建一个BarButtonItem按照指定的大小  用setImage 加载图片的
 *
 *  @param image     正常的图片
 *  @param highImage 高亮的图片
 *  @param size      按钮大小
 *  @param imageSize 图片大小  暂时没有用到
 *  @param target    target
 *  @param action    回调
 *
 *  @return instancetype
 */
+ (instancetype)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage size:(CGSize)size imageSize:(CGSize)imageSize target:(id)target action:(SEL)action ;

/**
 *  创建一个BarButtonItem 白色边框 白色图片 圆角
 *
 */
+ (instancetype)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  创建一个BarButtonItem 白色字体 无边框
 *
 */
+ (instancetype)barButtonItemNoBordWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  创建一个BarButtonItem 按钮size为 25*25 实际图片大小为17.5*17.5 UI要求
 *
 */
+ (instancetype)barButtonMustItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
/**
 *   解决导航栏 ios7.0 加上UIBarButtonItem 会左右之间有很大的间距 所有往导航栏加 UIBarButtonItem 全部调用这个方法  itemArray 元素为 UIBarButtonItem width 为距左或右的间距 必须为负的  return UIBarButtonItem组成后的数组  调用需是viewController.navigationItem.leftBarButtonItems、viewController.navigationItem.rightBarButtonItems
 */
+ (NSArray *)barButtonItems:(NSArray *)itemArray width:(CGFloat)width;
/**
 *  在导航栏右边增加控件
 */
+ (void)addBarButtonToRight:(UIBarButtonItem *)rightItem viewController:(UIViewController *)viewController width:(CGFloat)width ;
/**
 *  在导航栏右边增加多控件
 */
+ (void)addBarButtonToRights:(NSArray *)rightItems viewController:(UIViewController *)viewController width:(CGFloat)width ;

/**
 *  在导航栏左边增加控件
 */
+ (void)addBarButtonToLeft:(UIBarButtonItem *)leftItem viewController:(UIViewController *)viewController width:(CGFloat)width;
/**
 *  在导航栏左边增加多控件
 */
+ (void)addBarButtonToLefts:(NSArray *)leftItems viewController:(UIViewController *)viewController width:(CGFloat)width;

/**
 *  创建一个BarButtonItem  无边框
 *
 */
+ (instancetype)barButtonItemNoBordWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

/**
 *  创建一个BarButtonItem 白色字体 无边框
 *
 */
+ (instancetype)barButtonItemNoBordWithTitle:(NSString *)title titleColor:(UIColor *)titleColor withLableFont:(UIFont *)font target:(id)target action:(SEL)action;

@end
