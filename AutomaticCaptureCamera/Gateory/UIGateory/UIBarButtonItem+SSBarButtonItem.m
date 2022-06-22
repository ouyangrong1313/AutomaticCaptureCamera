//  UIBarButtonItem+SSBarButtonItem.m
//  Created by 刘辉 on 2018/2/6.
//  Copyright © 2018年 私塾家. All rights reserved.

#import "UIBarButtonItem+SSBarButtonItem.h"
#import "UIColor+SSStringToColor.h"
#import "UIButton+SSExtension.h"
#import "UIViewController+Controller.h"
#import "UIButton+SSExtension.h"

@implementation UIBarButtonItem (CCBarButtonItem)

+ (instancetype)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage size:(CGSize)size target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highImage forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, size};// 图片
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
/**
 *  创建一个BarButtonItem按照指定的大小  用setImage 加载图片的
 *  @param image     正常的图片
 *  @param highImage 高亮的图片
 *  @param size      按钮大小
 *  @param imageSize 图片大小  暂时没有用到
 *  @param target
 *  @param action    回调
 *  @return
 */
+ (instancetype)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage size:(CGSize)size imageSize:(CGSize)imageSize target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, size} ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highImage forState:UIControlStateHighlighted];
    
    button.frame = (CGRect){CGPointZero, {button.currentBackgroundImage.size.width,button.currentBackgroundImage.size.height}};// 按钮的背景图片，按钮的图片button.currentImage
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
+ (instancetype)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = FONTDEFAULT(14);
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = UIColorFromHex(COLOR_E2E2E2).CGColor;
    CGFloat width = [title calculateheight:button.titleLabel.font ].width + 8;
    button.frame = CGRectMake(0, 0, width, 25);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
/**
 *  创建一个BarButtonItem 白色字体 无边框
 *
 */
+ (instancetype)barButtonItemNoBordWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    
    UIButton *button = [UIButton buttonTitle:title target:target action:action];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/**
 *  创建一个BarButtonItem 按钮size为 25*25 实际图片大小为17.5*17.5 UI要求
 *
 */
+ (instancetype)barButtonMustItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonMustItemWithImage:image highImage:highImage target:target action:action];
 
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
/**
 *   解决导航栏 ios7.0 加上UIBarButtonItem 会左右之间有很大的间距 所有往导航栏加 UIBarButtonItem 全部调用这个方法  itemArray 元素为 UIBarButtonItem width 为距左或右的间距 必须为负的  return UIBarButtonItem组成后的数组  调用需是viewController.navigationItem.leftBarButtonItems、viewController.navigationItem.rightBarButtonItems
 */
+ (NSArray *)barButtonItems:(NSArray *)itemArray width:(CGFloat)width
{
    NSMutableArray *tempItemArray = [[NSMutableArray alloc] init];
    [tempItemArray addObjectsFromArray:itemArray];
    if (iOS7UP) {
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = width;
        [tempItemArray insertObject:spaceItem atIndex:0];
    }
    return [tempItemArray copy];
}

/**
 *  在导航栏右边增加控件
 */
+ (void)addBarButtonToRight:(UIBarButtonItem *)rightItem viewController:(UIViewController *)viewController width:(CGFloat)width
{
    viewController = [UIViewController obtainViewController:viewController];
    if (rightItem) {
        if (iOS7UP) {
            viewController.navigationItem.rightBarButtonItems = nil;
            viewController.navigationItem.rightBarButtonItems = [self barButtonItems:@[rightItem] width:width];
        }else{
            viewController.navigationItem.rightBarButtonItem = nil; 
            viewController.navigationItem.rightBarButtonItem = rightItem;
        }
    }else{
        if (iOS7UP) {
            viewController.navigationItem.rightBarButtonItems = nil;
        }else{
            viewController.navigationItem.rightBarButtonItem = nil;
        }
    }
   
}

/**
 *  在导航栏右边增加多控件
 */
+ (void)addBarButtonToRights:(NSArray *)rightItems viewController:(UIViewController *)viewController width:(CGFloat)width
{
    viewController = [UIViewController obtainViewController:viewController];
    if (rightItems) {
        if (iOS7UP) {
            viewController.navigationItem.rightBarButtonItems = nil;
            viewController.navigationItem.rightBarButtonItems = [self barButtonItems:rightItems width:width];
        }else{
            viewController.navigationItem.rightBarButtonItems = nil;
            viewController.navigationItem.rightBarButtonItems = rightItems;
        }
    }else{
        if (iOS7UP) {
            viewController.navigationItem.rightBarButtonItems = nil;
        }else{
            viewController.navigationItem.rightBarButtonItem = nil;
        }
    }
}

/**
 *  在导航栏左边增加控件
 */
+ (void)addBarButtonToLeft:(UIBarButtonItem *)leftItem viewController:(UIViewController *)viewController width:(CGFloat)width
{
    viewController = [UIViewController obtainViewController:viewController];
    if (leftItem) {
        if (iOS7UP) {
            viewController.navigationItem.leftBarButtonItems = nil;
            viewController.navigationItem.leftBarButtonItems = [self barButtonItems:@[leftItem] width:width];
        }else{
            viewController.navigationItem.leftBarButtonItem = nil;
            viewController.navigationItem.leftBarButtonItem = leftItem;
        }
    }else{
        if (iOS7UP) {
            viewController.navigationItem.leftBarButtonItems = nil;
        }else{
            viewController.navigationItem.leftBarButtonItem = nil;
        }
    }
    
}

/**
 *  在导航栏左边增加多控件
 */
+ (void)addBarButtonToLefts:(NSArray *)leftItems viewController:(UIViewController *)viewController width:(CGFloat)width
{
    viewController = [UIViewController obtainViewController:viewController];
    if (leftItems && leftItems.count) {
        if (iOS7UP) {
            viewController.navigationItem.leftBarButtonItems = nil;
            viewController.navigationItem.leftBarButtonItems = [self barButtonItems:leftItems width:width];
        }else{
            viewController.navigationItem.leftBarButtonItem = nil;
            viewController.navigationItem.leftBarButtonItems = leftItems;
        }
    }else{
        [viewController.navigationItem setHidesBackButton:YES];
        if (iOS7UP) {
            viewController.navigationItem.leftBarButtonItems = nil;
        }else{
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
        }
    
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    }
}
/**
 *  创建一个BarButtonItem 白色字体 无边框
 *
 */
+ (instancetype)barButtonItemNoBordWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = FONTDEFAULT(14);
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width + 8;
    button.frame = CGRectMake(0, 0, width, 25);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/**
 *  创建一个BarButtonItem 白色字体 无边框
 *
 */
+ (instancetype)barButtonItemNoBordWithTitle:(NSString *)title titleColor:(UIColor *)titleColor withLableFont:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width + 8;
    button.frame = CGRectMake(0, 0, width, 25);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
