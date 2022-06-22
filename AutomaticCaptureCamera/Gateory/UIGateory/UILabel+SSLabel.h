//  UILabel+CCLabel.h
//  Created by 刘辉 on 18/2/5.
//  Copyright © 2015年 私塾家. All rights reserved.

#import <UIKit/UIKit.h>

@interface UILabel (SSLabel)


-(instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font textAligment:(NSTextAlignment)textAligment;


/**
 *  初始化
 *
 *  @param frame        frame
 *  @param textColor    字体颜色
 *  @param fontSize     字体大小
 *  @param textAligment 位置
 *
 *  @return instancetype
 */
-(instancetype)initWithFrame:(CGRect)frame textColorStr:(NSString *)textColor fontInt:(int)fontSize textAligment:(NSTextAlignment)textAligment;
/**
 *  初始化
 *
 *  @param frame        frame
 *  @param text         显示内容
 *  @param textColor    字体颜色
 *  @param fontSize     字体大小
 *  @param textAligment 位置
 *
 *  @return instancetype
 */
-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textColorStr:(NSString *)textColor fontInt:(int)fontSize textAligment:(NSTextAlignment)textAligment;
/**
    处理文字超出最大行数 会显示类似查看更多的文字   exceedsDisplayText  (类似查看更多的文字)  maxNumber 最大的行数
 */
- (void)exceedsDisplayedText:(NSString *)exceedsDisplayText exceedColor:(UIColor *)exceedColor maxNumber:(NSInteger)maxNumber text:(NSString *)text;

/**
 处理文字超出最大行数 会显示类似查看更多的文字   exceedsDisplayText  (类似查看更多的文字)  maxNumber 最大的行数
 */
- (void)exceedsDisplayedText:(NSString *)exceedsDisplayText exceedColor:(UIColor *)exceedColor maxNumber:(NSInteger)maxNumber text:(NSString *)text withSize:(CGSize)labelSize;  //在用xib时，取自身的size可能会出错
/**
 *  设置label上中间的线  lineColor 线的颜色  lineH 线的宽度 线的宽度跟Label同宽
 */
- (void)setCenterLine:(UIColor *)lineColor lineH:(CGFloat)lineH;

/**
 * 改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(CGFloat)space;

-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

/**
 * 改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(CGFloat)space;

/**
 * 改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(CGFloat)lineSpace WordSpace:(float)wordSpace;

/**
 *  动态计算label需要的高度
 *
 *  @return 高度
 */
- (CGFloat)xw_dynamicCalculationHeight;
/**
 *  动态计算label需要的高度
 *
 *  @param font     字体(传nil为label当前设置的字体)
 *  @param fixWidth 固定宽度(传0为label当前设置的宽度)
 *  @param text     内容(传nil为label当前设置的text)
 *
 *  @return 高度
 */
- (CGFloat)xw_dynamicCalculationHeightWithFont:(UIFont*)font FixWidth:(CGFloat)fixWidth Text:(NSString*)text;
/**
 *  动态计算label需要的宽度
 *
 *  @return 宽度
 */
- (CGFloat)xw_dynamicCalculationWidth;
/**
 *  动态计算label需要的宽度
 *
 *  @param font      字体(传nil为label当前设置的字体)
 *  @param fixHeight 固定高度(传0为label当前设置的高度)
 *  @param text      内容(传nil为label当前设置的text)
 *
 *  @return 宽度
 */
- (CGFloat)xw_dynamicCalculationWidthWithFont:(UIFont*)font FixHeight:(CGFloat)fixHeight Text:(NSString*)text;

// 文字顶部对齐
- (void)textAlignmentTop;

// 文字底部对齐
- (void)textAlignmentBottom;

@end
