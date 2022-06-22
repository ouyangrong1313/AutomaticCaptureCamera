//
//  NSMutableAttributedString+XWDynamicCalculationSize.h
//  QYDAXUE
//
//  Created by wzl on 2017/5/12.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (XWDynamicCalculationSize)
#pragma mark - 高度
/**
 *  动态计算文字需要的高度
 *
 *  默认当前设备宽度
 *
 *  @return 高度
 */
- (CGFloat)xw_dynamicCalculationHeight;
/**
 *  动态计算文字需要的高度
 *
 *  @param fixWidth 固定宽度(传0为label当前设备的宽度)
 *
 *  @return 高度
 */
- (CGFloat)xw_dynamicCalculationHeightWithFixWidth:(CGFloat)fixWidth;

#pragma mark - 宽度
/**
 *  动态计算文字需要的宽度
 *
 *  默认当前设备高度
 *
 *  @return 宽度
 */
- (CGFloat)xw_dynamicCalculationWidth;
/**
 *  动态计算文字需要的宽度
 *
 *  @param fixHeight 固定高度(传0为label当前设备的高度)
 *
 *  @return 宽度
 */
- (CGFloat)xw_dynamicCalculationWidthWithFixHeight:(CGFloat)fixHeight;

/**
 *  动态计算文字需要的宽度
 *
 *  @param fixWidth 固定宽度(传0为label当前设备的高度)
 *
 *  @param mFontSize 字体大小(传0为label当前设备的高度)
 *
 *  @return 高度
 */
+(CGFloat)hideLabelLayoutHeight:(NSMutableAttributedString *)attributes withTextFont:(UIFont *)mFont fixWidth:(CGFloat)fixWidth;

@end
