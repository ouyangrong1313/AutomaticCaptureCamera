//  UIColor+CCStringToColor.h
//  Created by 刘辉 on 18/2/5.
//  Copyright (c) 2018年 私塾家. All rights reserved.


/**
 *  颜色
 */
#import <UIKit/UIKit.h>

@interface UIColor (SSStringToColor)
//十六进制颜色  转换uicolor
+ (UIColor *)stringToColor:(NSString *)str;
+ (UIColor *)stringToColor:(NSString *)str alpha:(CGFloat)f;  //颜色透明度
+(UIColor *)generateDynamicColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;
@end
