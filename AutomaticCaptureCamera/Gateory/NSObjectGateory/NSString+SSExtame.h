//
//  NSString+SSExtame.h
//  Created by 刘辉 on 2018/2/6.
//  Copyright © 2018年 私塾家. All rights reserved.

#import <Foundation/Foundation.h>

#define kTimeHour                       @"hour"
#define kTimeMinute                     @"minute"
#define kTimeSecond                     @"second"
#define kTimeShowHourMinuteSecond       @"ShowHourMinuteSecond"
#define kTimeShowMinuteSecond           @"ShowMinuteSecond"
 

@interface NSString (SSExtame)

/**
 *  判断是不是http字符串（在传图片时，判断是本地图片或者是网络图片）
 */
- (BOOL)isHttpString ;

/**
 *  判断查找字符串中是否包含字符串 
 *  - 解决 被查找字符串是nil的情况,range.location 会是0(NSNotFound不是0),
 *  @param searchString 查找的字符串
 *  @return NSRange
 */
- (NSRange)CC_RangeOfString:(NSString *)searchString;

#pragma mark -
#pragma mark ----- 判断表情
/**
 *  替换掉表情
 *
 *  @param inputStr 输入的文字
 *
 *  @return 替换掉后的文字
 */
+(NSString *)disable_emoji:(NSString *)inputStr;
/**
 *  判断是否是表情
 *
 *  @param inputStr 输入的文字
 *
 *  @return 是否是表情
 */
+(BOOL)disable_emoji1:(NSString *)inputStr;

/**
 *  判断是否是有效的电话号码，不做提示和长处的判断。只是判断是否正确
 *  @return 是否是电话号码
 */
- (BOOL)isValidatePhoneNumber;

/**
 *  是否是数字格式的日期,如2016-02-03
 */
- (BOOL)isNumDate;


/**
 *  判断是否是有效的验证码
 *  @return 是否是验证码
 */
- (BOOL)isValidateCode;

#pragma mark -
#pragma mark ----- 计算字的大小
/**
 计算高度或宽度   返回 大小
 @parm font  字体
 @parm size  限制的宽度或高度
 */
- (CGSize )calculateheight:(UIFont *)font andcontSize:(CGSize )size;
/**
 *  根据字体大小 计算
 */
- (CGSize)calculateheight:(UIFont *)font;

/**
 *  根据传进来的字符串 设置为特定的颜色和字体
 *
 *  @param color          特定的颜色
 *  @param font           特定的字体
 *  @param defaulColor    默认颜色
 *  @param defaultFont    默认字体
 *  @param equalString    匹配的文字
 *  @param attributedText 当前字符的attributedString
 *  @param isright        是否靠右
 *
 *  @return  NSAttributedString
 */
- (NSAttributedString *)setVariedWidthColor:(UIColor *)color font:(UIFont *)font defaultColor:(UIColor *)defaulColor defaultFont:(UIFont *)defaultFont equalString:(NSString *)equalString attributedText:(NSAttributedString *)attributedText isalignmentRight:(BOOL )isright;

/**
 *  从equalString 这个字符串开始 往后设置特定的颜色、字体
 *
 *  @param color          特定的颜色
 *  @param font           特定的字体
 *  @param defaulColor    默认颜色
 *  @param defaultFont    默认字体
 *  @param equalString    匹配的文字
 *  @param attributedText 当前字符的attributedString
 *  @param isright        是否靠右
 */
- (NSAttributedString *)setVariedColor:(UIColor *)color font:(UIFont *)font defaultColor:(UIColor *)defaulColor defaultFont:(UIFont *)defaultFont equalString:(NSString *)equalString attributedText:(NSAttributedString *)attributedText isalignmentRight:(BOOL )isright;

/**
 *  设置相同的字或多个字符串设定特定的颜色和字体  isAll 是 stringArray 查找到对应的字会替换成一样的字体大小和字体颜色  否 不会把所有相同的字替换成相同的颜色和字体大小
 *
 *  @param colorArray     颜色数组
 *  @param fontArray      字体数组
 *  @param stringArray    字数组
 *  @param defaulColor    默认颜色
 *  @param defaultFont    默认字体
 *  @param attributedText 当前字符的attributedString
 *  @param isAll          相同的字是否全部设置为一样的颜色和字体
 *
 *  @return NSAttributedString
 */
- (NSAttributedString *)setVariedColorArray:(NSArray *)colorArray fontArray:(NSArray *)fontArray string:(NSArray *)stringArray defaultColor:(UIColor *)defaulColor defaultFont:(UIFont *)defaultFont attributedText:(NSAttributedString *)attributedText isAll:(BOOL)isAll ;
/**
 判断是否数字
 */
+ (BOOL) isValidateNum:(NSString *)phoneCode ;
/**
 *  判断是否为邮箱
 */
+ (BOOL)isValidateEmail:(NSString *)Email;
/**
 *  判断密码
 *  @return BOOL
 */
+ (BOOL)isvalidatePassword:(NSString *)passWord ;
/*!
 *  判断是否为字母
 *  @return BOOL
 */
+ (BOOL)isValidateLetter:(NSString *)Letter;
/*!
 *  判断是否为密码
 */
+ (BOOL)isValidatePayPassword:(NSString *)payPassWord ;

/**
 *  保留数字和字母
 */
+ (NSString *)retentionIntAndLetter:(NSString *)str;
/**
 *  保留数字
 */
+ (NSString *)retentionInt:(NSString *)str;

/**
 *  是汉语
 *  @return BOOL
 */
+ (BOOL)isChanese:(NSString *)str;
/**
 *  去掉中文
 */
+ (NSString *)deleteChinese:(NSString *)str;

/**
 *  链接编码 不对＃进行编码
 */
+ (NSString *)concatenatedCoding:(NSString *)urlPath;
/**
 *  对特殊编码的编码
 */
+ (NSString *)concatenatedKey:(NSString *)key;

/**
 *  过滤空格 和换行符
 */
+ (NSString *)removeairAndWrap:(NSString *)string;

/**
 *  判断是否身份证号码
 *
 */
+ (BOOL)isvalidateIdentityCard: (NSString *)identityCard ;
/**
 *  判断是否为姓名   真实姓名可以是汉字，也可以是字母，但是不能两者都有，也不能包含任何符号和数字
 */
+ (BOOL)isValidateName:(NSString *)name ;
/**
 *  判断是否是中文和英文
 */
+ (BOOL)isValidateEnAndZHName:(NSString *)name;
/**
 *
 *
 *  金额  只能输入数字和.
 *
 *  @param oldString         原来的值
 *  @param replacementString 替换的值
 *  @param rang              替换的位置
 *  @param isTwo             是否小数后两位
 *  @param isInt             是否整型
 *
 *  @return NSString
 */
+ (NSString *)isValidatePrice:(NSString *)oldString replacementString:(NSString *)replacementString rang:(NSRange )rang  isTwo:(BOOL)isTwo isInt:(BOOL)isInt ;
/**
 *  判断价格是否超过最大的限制  price 判断价格  maxInteger 最大的整形（111111） maxDecimal 最大的小数（99）
 *  maxInteger 若有输入小数 只会取小数钱的 小数后不取   maxDecimal 只会取前两位 有小数也不会取小数 不够两位在后面补0
 */
+ (BOOL)exceedsTheMaximum:(NSString *)price maxInteger:(NSString *)maxInteger maxDecimal:(NSString *)maxDecimal;
/**
 *  随机产生 32 位
 */
+(NSString *)ret32bitString;
/**
 *  得到百倍于当前数字值的字符串
 */
+ (NSString *)getNoPointStr:(NSString *)str;
/**
 *  将价格变成小数后两位的价格字符串  只适用 加 减的  
 */
+ (NSString *)obtainTotalPrice:(NSInteger)totalPrice;
 

/**
 *  根据单价和数量的字符串获取总价的字符串
 */
+ (NSString *)getTotalPriceStringWithPrice:(NSString *)price withNum:(NSString *)numStr;

/**
 *  图文混排 设置图片的大小 imageArray 对象为UIimage 属性
 */
+ (NSAttributedString *)obtainImageAndTextAtImageSize:(CGSize )imageSize imageArray:(NSArray *)imageArray textArray:(NSArray *)textArray;
/**
 *  转换后的手机号码  convertedString  替换成数据  例如 (****)
 */
+ (NSString *)convertedPhone:(NSString *)convertedString phone:(NSString *)phone;
/**
 *  将秒装换成时分秒
 */
+(NSDictionary *)timeformatFromSeconds:(NSInteger)seconds;
/**
 *  判断价格price是否小于等于 当前的价格
 */
- (BOOL)comparePrice:(NSString *)price;
/**
 *  保留数字  剔除所有非数字的字符串
 */
- (NSString *)retentionIntString;

/**
 *  根据阿拉伯数字的月份获取中文的月份
 */
+(NSString *)getMonthByString:(NSString *)month;

/**
 *  字典转字符串
 */
+(NSString *)stringFromDict:(NSDictionary *)dict;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  添加行间距并返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 *  @param lineSpaceing 行间距
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize andlineSpacing:(CGFloat) lineSpaceing;

/**
 *  自适应图片url
 */
- (NSString *)self_adaptionHost;

- (NSString *)timing;

#pragma mark - 高度
/**
 *  动态计算文字需要的高度
 *
 *  默认17号系统字体 当前设备宽度情况
 *
 *  @return 高度
 */
- (CGFloat)xw_dynamicCalculationHeight;
/**
 *  动态计算文字需要的高度
 *
 *  @param font     字体(传nil为label当前设置的字体)
 *  @param fixWidth 固定宽度(传0为label当前设备的宽度)
 *
 *  @return 高度
 */
- (CGFloat)xw_dynamicCalculationHeightWithFont:(UIFont*)font FixWidth:(CGFloat)fixWidth;

/**
 动态计算文字需要的高度

 @param attributes 文字属性
 @param fixWidth 固定宽度(传0为label当前设备的宽度)
 
 @return 高度
 */
- (CGFloat)xw_dynamicCalculationHeightWithFixWidth:(CGFloat)fixWidth Attributes:(NSDictionary<NSString *, id> *)attributes;

#pragma mark - 宽度
/**
 *  动态计算文字需要的宽度
 *
 *  默认17号系统字体 当前设备高度情况
 *
 *  @return 宽度
 */
- (CGFloat)xw_dynamicCalculationWidth;
/**
 *  动态计算文字需要的宽度
 *
 *  @param font      字体(传nil为label当前设置的字体)
 *  @param fixHeight 固定高度(传0为label当前设备的高度)
 *
 *  @return 宽度
 */
- (CGFloat)xw_dynamicCalculationWidthWithFont:(UIFont*)font FixHeight:(CGFloat)fixHeight;

/**
 动态计算文字需要的宽度

 @param attributes 文字属性
 @param fixHeight 固定高度(传0为label当前设备的高度)

 @return 宽度
 */
- (CGFloat)xw_dynamicCalculationWidthWithFixHeight:(CGFloat)fixHeight Attributes:(NSDictionary<NSString *, id> *)attributes;

//给UILabel设置行间距和字间距

-(void)xw_setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font space:(CGFloat)space;

//计算UILabel的高度(带有行间距的情况)

-(CGFloat)xw_getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width space:(CGFloat)space;

//计算UILabel的宽度(带有行间距的情况)
-(CGFloat)xw_getSpaceLabelWidth:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width space:(CGFloat)space;

#pragma mark - 字典转字符串
-(NSString *)stringFromDict:(NSDictionary *)dict;

/**
 * 带中文或者特殊符号的编码
 */
+(NSString*)encodeString:(NSString*)uncodeString;

/**
 * 带中文或者特殊符号的解码
*/
+(NSString*)decodeString:(NSString*)decodeString;

// Double 类型的字符串，取精确到多少位，并且去掉末尾的0；提供一个NSSing的扩展，传入需要保留的小数位，返回字符串。并且去掉末尾的0.
- (NSString *)eliminateZeroWithDouble:(NSInteger)integer;

/**
*  教师端 - 密码规则 - 建议密码长度不少于8位，且密码中至少包含数字、字母和符号；^(?=.*\d)(?=.*[a-zA-Z])(?=.*[~!@#$%^&*￥])[\da-zA-Z~!@#$%^&*￥]{8,}$
*/
+ (BOOL)checkIsMatchNumLetterAndSpecialCharacter:(NSString*)password;


/*!

* @brief 把格式化的JSON格式的字符串转换成字典

* @param jsonString JSON格式的字符串

* @return 返回字典

*/

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
