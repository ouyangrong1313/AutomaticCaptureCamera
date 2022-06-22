//  NSMutableAttributedString+XWDynamicCalculationSize.m
//  QYDAXUE
//  Created by wzl on 2017/5/12.
//  Copyright © 2017年 cc. All rights reserved.

#import "NSMutableAttributedString+XWDynamicCalculationSize.h"

#define kXWDynamicCalculationSize_DefaultFont [UIFont systemFontOfSize:17.0f] //默认字体
#define kXWDynamicCalculationSize_DefaultHeight [UIScreen mainScreen].bounds.size.height //动态计算宽度时默认固定高度
#define kXWDynamicCalculationSize_DefaultWidth [UIScreen mainScreen].bounds.size.width  //动态计算高度时默认固定宽度

@implementation NSMutableAttributedString (XWDynamicCalculationSize)
#pragma mark - 高度
- (CGFloat)xw_dynamicCalculationHeight {
    CGFloat height = ceil([self boundingRectWithSize:CGSizeMake(kXWDynamicCalculationSize_DefaultWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesDeviceMetrics context:nil].size.height);
    return height;
}

- (CGFloat)xw_dynamicCalculationHeightWithFixWidth:(CGFloat)fixWidth{
    CGFloat myFixWidth = fixWidth > 0?fixWidth:kXWDynamicCalculationSize_DefaultWidth;
    CGFloat height = ceil([self boundingRectWithSize:CGSizeMake(myFixWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine context:nil].size.height);
    return height;
}

#pragma mark - 宽度
- (CGFloat)xw_dynamicCalculationWidth{
    CGFloat width = ceil([self boundingRectWithSize:CGSizeMake(kXWDynamicCalculationSize_DefaultHeight, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine context:nil].size.width);
    return width;
}

-(CGFloat)xw_dynamicCalculationWidthWithFixHeight:(CGFloat)fixHeight{
    CGFloat myFixHeight = fixHeight > 0?fixHeight:kXWDynamicCalculationSize_DefaultHeight;
    CGFloat width = ceil([self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, myFixHeight) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine context:nil].size.width);
    return width;
}

+(CGFloat)hideLabelLayoutHeight:(NSMutableAttributedString *)attributes withTextFont:(UIFont *)mFont fixWidth:(CGFloat)fixWidth{
    [attributes addAttribute:NSFontAttributeName value:mFont range:NSMakeRange(0,attributes.length)];
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(fixWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attSize.height;
}

@end
