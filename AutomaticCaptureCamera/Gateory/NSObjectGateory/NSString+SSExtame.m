//
//  NSString+CCExtame.m
//  Created by 刘辉 on 2018/2/6.
//  Copyright © 2018年 私塾家. All rights reserved.

#import "NSString+SSExtame.h"

#define kXWDynamicCalculationSize_DefaultFont [UIFont systemFontOfSize:17.0f] //默认字体
#define kXWDynamicCalculationSize_DefaultHeight [UIScreen mainScreen].bounds.size.height //动态计算宽度时默认固定高度
#define kXWDynamicCalculationSize_DefaultWidth [UIScreen mainScreen].bounds.size.width  //动态计算高度时默认固定宽度

@implementation NSString (SSExtame)

/**
 *  判断是不是http字符串（在传图片时，判断是本地图片或者是网络图片）
 *  @return
 */
- (BOOL)isHttpString{
    if (self && self.length){
        //        NSString *httpStrRegex = @"^http[s]{0,1}://.+";
        NSString *httpStrRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z0-9]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z0-9]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:httpStrRegex options:0 error:nil];
        NSArray *array = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
        return array.count ;
    }
    return NO;
}

/**
 *  判断查找字符串中是否包含字符串
 *  - 解决 被查找字符串是nil的情况,range.location 会是0(NSNotFound不是0),
 *  @param searchString 查找的字符串
 *  @return NSRange
 */
- (NSRange)CC_RangeOfString:(NSString *)searchString
{
    //如果被查找的字符串是nil, 返回的range.location 会是0. 会干扰后面对于NSNotFound的判断.
    if (!self || [self length] <= 0) {
        return NSMakeRange(NSNotFound, 0);
    }
    //如果查找的字符串是nil值, 会导致程序崩溃.
    if (!searchString || [searchString length] <= 0) {
        return NSMakeRange(NSNotFound, 0);
    }
    
    return [self rangeOfString:searchString];
}

#pragma mark -
#pragma mark ----- 判断表情
/**
 *  替换掉表情
 *
 *  @param inputStr 输入的文字
 *
 *  @return 替换掉后的文字
 */
+(NSString *)disable_emoji:(NSString *)text{
    
    __block NSString *noEmoji = text;
    __block BOOL isEmoji = NO ;
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                     isEmoji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             }else if (ls >= 0xfe0f){
                 isEmoji = YES;
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""] ;
             }
             
         } else {
             // non surrogate
             
             if (hs >= 0x2500 && hs<= 0x254b) {
                 
             }else if (0x2100 <= hs && hs <= 0x27ff && hs != 0x22ef && hs != 0x263b) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0x231a ) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             }
         }
     }];
    text = noEmoji;
    return text;
}

/**
 *  判断是否是表情
 *
 *  @param inputStr 输入的文字
 *
 *  @return 是否是表情
 */
+(BOOL)disable_emoji1:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    if (![modifiedString isEqualToString:text]) {
        return YES;
    }
    return NO;
}

/**
 *  判断是否是有效的电话号码
 *
 *  @param str 输入的文字
 *
 *  @return 是否是电话号码
 */
- (BOOL)isValidatePhoneNumber{
    if (self.length != 11){
            return NO;
    }else{
        /**
        * 移动号段正则表达式
        */
        NSString *CM_NUM = @"^((13[4-9])|(14[7,8])|(15[0-2,7-9])|(165)|(17[2,8])|(18[2-4,7-8])|(19[5,8]))\\d{8}|(1705)\\d{7}$";
       /**
        * 联通号段正则表达式
        */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(166)|(17[1,5,6])|(18[5,6]))\\d{8}|(1709)\\d{7}$";
       /**
        * 电信号段正则表达式
        */
        NSString *CT_NUM = @"^((133)|(149)|(153)|(17[0,3,4,7])|(18[0,1,9])|(19[1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
              
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

/**
 *  是否是数字格式的日期,如2016-02-03
 *
 *  @return
 */
- (BOOL)isNumDate {
    NSString *pattern = @"([1-2]{1})[0-9]{3}-[0-9]{2}-[0-9]{2}$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [codeTest evaluateWithObject:self];
}

/**
 *  判断是否是有效的验证码
 *
 *  @param str 输入的文字
 *
 *  @return 是否是验证码
 */
- (BOOL)isValidateCode {
    NSString *codeRegex = @"^[0-9]{6}$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:self];
}

/**
 计算高度或宽度   返回 大小
 @parm font  字体
 @parm size  限制的宽度或高度
 */
- (CGSize )calculateheight:(UIFont *)font andcontSize:(CGSize )size{
    if (self.length == 0 || !font) {
        return CGSizeMake(0, 0);
    }
    CGSize contSize ;
    
    CGRect oldframe = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    contSize = oldframe.size;
    
    return contSize ;
}

/**
 *  根据字体大小 计算
 */
- (CGSize)calculateheight:(UIFont *)font
{
    CGSize contSize = CGSizeZero;
    if (!font ) {
        return contSize;
    }else if (self.length ==0 ){
        return contSize;
    }
//    if (iOS7UP) {
        contSize = [self sizeWithAttributes:@{NSFontAttributeName:font}];
//    }else{
//        contSize = [self sizeWithFont:font];
//    }
    return contSize;
}

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
 *  @return
 */
- (NSAttributedString *)setVariedWidthColor:(UIColor *)color font:(UIFont *)font defaultColor:(UIColor *)defaulColor defaultFont:(UIFont *)defaultFont equalString:(NSString *)equalString attributedText:(NSAttributedString *)attributedText isalignmentRight:(BOOL )isright{
    if (self.length > 0 ) {
        NSMutableAttributedString *mutabPriceName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self]];
        if (attributedText.length != 0) {
            [mutabPriceName deleteCharactersInRange:NSMakeRange(0, self.length)];
            [mutabPriceName appendAttributedString:attributedText];
        }
      
        NSRange rang = [self rangeOfString:equalString];
        if (rang.location != NSNotFound) {
            if (isright) {
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                paragraph.alignment = NSTextAlignmentRight;//设置对齐方式
                
                [mutabPriceName setAttributes:@{NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:defaulColor} range:NSMakeRange(0, self.length)];
            }
            if (font) {
                [mutabPriceName setAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font} range:NSMakeRange(rang.location, equalString.length)];
            }else{
                [mutabPriceName setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(rang.location,equalString.length)];
            }
        }
        return mutabPriceName ;
    }else{
        return nil;
    }
}

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
- (NSAttributedString *)setVariedColor:(UIColor *)color font:(UIFont *)font defaultColor:(UIColor *)defaulColor defaultFont:(UIFont *)defaultFont equalString:(NSString *)equalString attributedText:(NSAttributedString *)attributedText isalignmentRight:(BOOL )isright{
    NSRange rang = [self rangeOfString:equalString];
    if (rang.location != NSNotFound) {
        equalString = [self substringWithRange:NSMakeRange(rang.location, self.length - rang.location)] ;
    }
    return [self setVariedWidthColor:color font:font defaultColor:defaulColor defaultFont:font equalString:equalString attributedText:attributedText isalignmentRight:isright] ; 
}

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
 *  @return <#return value description#>
 */
- (NSAttributedString *)setVariedColorArray:(NSArray *)colorArray fontArray:(NSArray *)fontArray string:(NSArray *)stringArray defaultColor:(UIColor *)defaulColor defaultFont:(UIFont *)defaultFont attributedText:(NSAttributedString *)attributedText isAll:(BOOL)isAll{
    if (self.length > 0 ) {
        // 去掉 stringArray  空字符串
        NSMutableArray *tempStringArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempColorArray = [[NSMutableArray alloc] init] ;
        NSMutableArray *tempFontArray = [[NSMutableArray alloc] init];
        for (NSInteger  i = 0 ; i < stringArray.count; i ++ ) {
            NSString *tempstr = [stringArray objectAtIndex:i] ;
            if (tempstr.length != 0 ) {
                // 字符串不为空  存放到临时的数组
                [tempStringArray addObject:tempstr];
                UIColor *tempColor = defaulColor ;  // 默认的字体颜色为self 的字体颜色
                UIFont *tempFont = defaultFont ;         // 默认的字体大小为self 的字体大小
                if (i < colorArray.count) {
                    tempColor = colorArray[i];
                }
                [tempColorArray addObject:tempColor];
                if (i < fontArray.count) {
                    tempFont = fontArray[i];
                }
                [tempFontArray addObject:tempFont];
            }
        }
        stringArray = [tempStringArray copy];
        colorArray  = [tempColorArray copy] ;
        fontArray   = [tempFontArray copy] ;
        // 是否大于0
        if(stringArray.count > 0 ){
            // 将label上的字存放到临时的变量中
            NSString *tempString = self ;
            // 取出 stringArray 数组第一个字符串
            NSString *muArrayStr = stringArray[0] ;
            // 匹配到的字符串的下表位置 数组
            NSMutableArray *locationMArray = [[NSMutableArray alloc] init];
            // 匹配是否存在
            NSRange range = [tempString rangeOfString:muArrayStr];
            int count = 0 ;  // 循环的次数
            NSInteger strLength = 0 ;  // 上一个 muArrayStr 的长度
            
            if(range.length>0)
            {
                while (range.length > 0 ) {
                    // 匹配到字符串的开始位置
                    NSInteger startIndex = range.location + range.length;
                    // 取出数组最后一个值
                    NSInteger lastCount = [[locationMArray lastObject] integerValue];
                    lastCount = lastCount + strLength;

                    // 加到字符串中
                    [locationMArray  addObject:[NSString stringWithFormat:@"%lu",(range.location  + lastCount)]] ;
                    NSMutableAttributedString *mutableString;
                    if (attributedText.length != 0 ) {
                        mutableString =  [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
                    }else{
                        mutableString = [[NSMutableAttributedString alloc] initWithString:self];
                    }
                    UIColor *color = defaulColor ;
                    UIFont *font = defaultFont ;
                    if (count < colorArray.count) {
                        color = (UIColor *)[colorArray objectAtIndex:count];
                    }else{
                        if (isAll) {
                            color = (UIColor *)[colorArray firstObject] ;
                        }
                    }
                    if (count < fontArray.count) {
                        font = [fontArray objectAtIndex:count] ;
                    }else{
                        if (isAll) {
                            font = (UIFont *)[fontArray firstObject];
                        }
                    }
                    NSRange tempRang = NSMakeRange([[locationMArray lastObject] integerValue],muArrayStr.length) ;
                    [mutableString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} range:tempRang];
                    
                    attributedText = mutableString ;
                    count ++ ;
                    strLength = muArrayStr.length ;
                    // 取出下个要匹配的字符串
                    if (count < stringArray.count) {
                        muArrayStr = stringArray[count] ;
                    }
                    // 除掉上个匹配到的字符串的剩下的长度
                    NSInteger endIndex = tempString.length -startIndex;
                    // 取出 剩下的字符串
                    tempString= [tempString substringWithRange:NSMakeRange(startIndex, endIndex)];
                    
                    range = [tempString rangeOfString:muArrayStr];
                    
                }
            }
            
        }
        
        return attributedText ;
        
    }else{
        return nil;
    }
}


/**
 * 判断是否数字
 */
+ (BOOL) isValidateNum:(NSString *)phoneCode {
    NSScanner* scan = [NSScanner scannerWithString:phoneCode];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  判断是否为邮箱
 */
+ (BOOL)isValidateEmail:(NSString *)Email {
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

/**
 *  判断密码
 */
+ (BOOL)isvalidatePassword:(NSString *)passWord {
    NSString *passWordRegex = @"^[a-zA-Z0-9]{8,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    if ([self isValidateLetter:passWord]) {
       
    }
    return [passWordPredicate evaluateWithObject:passWord];
}

/*!
 *  判断是否为字母
 */
+ (BOOL)isValidateLetter:(NSString *)Letter {
    NSString *passWordRegex = @"^[a-zA-Z]+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:Letter];
}

/*!
 *  判断是否为密码
 */
+ (BOOL)isValidatePayPassword:(NSString *)payPassWord {
    // 密码只能是数字和字母的组合
    if ([self isValidateNum:payPassWord] || [self isValidateLetter:payPassWord] || ![self isvalidatePassword:payPassWord]) {
        return NO ;
    }
    return  YES;
}
/**
 *  保留数字和字母
 */
+ (NSString *)retentionIntAndLetter:(NSString *)str
{
    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (NSInteger i = 0 ; i < str.length; i ++ ) {
        NSString *subString = [str substringWithRange:NSMakeRange(i, 1)];
        if (subString.length > 0 ) {
            if ([self isValidateNum:subString] || [self isValidateLetter:subString]) {
                [tempString appendString:subString];
            }
        }
    }
    
    return tempString;
}
/**
 *  保留数字
 */
+ (NSString *)retentionInt:(NSString *)str{
    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (NSInteger  i = 0 ; i <str.length; i ++ ) {
        NSString *subString = [str substringWithRange:NSMakeRange(i, 1)];
        if (subString.length > 0 ) {
            if ([self isValidateNum:subString]) {
                [tempString appendString:subString];
            }
        }
    }
    return tempString;
}
/**
 *  是汉语
 *
 *  @param str
 *
 *  @return
 */
+ (BOOL)isChanese:(NSString *)str{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:str];
}
/**
 *  去掉中文
 */
+ (NSString *)deleteChinese:(NSString *)str{
    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (NSInteger i = 0 ; i < str.length; i ++ ) {
        NSString *subString = [str substringWithRange:NSMakeRange(i, 1)];
        if (subString.length > 0 ) {
            if (![self isChanese:subString]) {
                [tempString appendString:subString];
            }
        }
    }
    return tempString;
}

/**
 *  链接编码 不对＃进行编码
 */
+ (NSString *)concatenatedCoding:(NSString *)urlPath
{
    NSCharacterSet *uRLCombinedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@" \"+<>[\\]^`'{|}"] invertedSet];
    urlPath = [urlPath stringByAddingPercentEncodingWithAllowedCharacters:uRLCombinedCharacterSet];
    return urlPath;
}
/**
 *  对特殊编码的编码
 */
+ (NSString *)concatenatedKey:(NSString *)key{
    NSCharacterSet *uRLCombinedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@" \"+%<>[\\]^`'{|}/"] invertedSet];
    key = [key stringByAddingPercentEncodingWithAllowedCharacters:uRLCombinedCharacterSet];
    return key;
}
/**
 *  过滤空格 和换行符
 */
+ (NSString *)removeairAndWrap:(NSString *)string
{
    NSString *tempString = [string  stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempString = [tempString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return tempString;   
}

/**
 *  判断是否身份证号码
 *
 */
+ (BOOL)isvalidateIdentityCard: (NSString *)identityCard
{
    
    //判断位数
    
    
    if ([identityCard length] != 15 && [identityCard length] != 18) {
        return NO;
    }
    NSString *carid = identityCard;
    
    long lSumQT =0;
    
    //加权因子
    
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    
    //校验码
    
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:identityCard];
    
    if ([identityCard length] == 15) {
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++)
            
        {
            
            p += (pid[i]-48) * R[i];
            
        }
        
        int o = p%11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        
        [mString insertString:string_content atIndex:[mString length]];
        
        carid = mString;
        
    }
    
    //判断地区码
    
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![self  areaCode:sProvince]) {
        
        return NO;
        
    }
    
    //判断年月日是否有效
    
    
    
    //年份
    
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    
    //月份
    int strMonth = [[self  getStringWithRange:carid Value1:10 Value2:2] intValue];
    
    //日
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setTimeZone:localZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        
        return NO;
        
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    
    if( 18 != strlen(PaperId)) return -1;
    
    
    
    //校验数字
    
    for (int i=0; i<18; i++)
        
    {
        
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
            
        {
            
            return NO;
            
        }
    }
    //验证最末的校验码
    
    for (int i=0; i<=16; i++)
        
    {
        
        lSumQT += (PaperId[i]-48) * R[i];
        
    }
    
    
    if (PaperId[17] == 'x') {
        
    }
    
    NSString *checker = [NSString stringWithFormat:@"%c",sChecker[lSumQT%11]] ;
    NSString *paper = [NSString stringWithFormat:@"%c",PaperId[17]];
    
    if ([paper isEqualToString:@"x"] || [paper isEqualToString:@"X"]) {
        if (![checker isEqualToString:@"X"]) {
            return NO;
        }
        
    }else{
        if (sChecker[lSumQT%11] != PaperId[17] )
            
        {
            return NO;
            
        }
    }
    return YES;
    
}
/**
 
 * 功能:获取指定范围的字符串
 
 * 参数:字符串的开始小标
 
 * 参数:字符串的结束下标
 
 */
+ (NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger )value1 Value2:(NSInteger )value2;

{
    return [str substringWithRange:NSMakeRange(value1,value2)];
    
}
/**
 
 * 功能:判断是否在地区码内
 
 * 参数:地区码
 
 */

+ (BOOL)areaCode:(NSString *)code

{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init] ;
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
        
    }
    
    return YES;
    
}
/**
 *  判断是否为姓名   真实姓名可以是汉字，也可以是字母，但是不能两者都有，也不能包含任何符号和数字
 */
+ (BOOL)isValidateName:(NSString *)name{
    NSString *nicknameRegex = @"^([\u4e00-\u9fa5]+|([a-zA-Z]+\\s?)+)$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:name];
}
/**
 *  判断是否是中文和英文
 */
+ (BOOL)isValidateEnAndZHName:(NSString *)name{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5a-zA-Z]+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:name];
}
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
 *  @return
 */
+ (NSString *)isValidatePrice:(NSString *)oldString replacementString:(NSString *)replacementString rang:(NSRange)rang isTwo:(BOOL)isTwo isInt:(BOOL)isInt{
    NSString *tempString = @"" ;
    
    if ([replacementString isEqualToString:@""]) {
        if (rang.length > 0 ) {
            if (rang.location != NSNotFound) {
                tempString = [oldString stringByReplacingCharactersInRange:rang withString:replacementString] ;
            }
        }else{
            NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@".0123456789"] invertedSet];
            NSArray *arr = [oldString componentsSeparatedByCharactersInSet:set];
            NSString *s = [arr componentsJoinedByString:@""];
            tempString = s  ;
        }
        
        
    }else{
        NSString *noEmoji = [NSString disable_emoji:replacementString] ;
        replacementString = noEmoji ;
        
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@".0123456789"] invertedSet];
        NSArray *arr = [replacementString componentsSeparatedByCharactersInSet:set];
        NSString *s = [arr componentsJoinedByString:@""];
        if ([s isEqualToString:@""] || s.length == 0 ) {
            tempString = [NSString stringWithFormat:@"%@%@",oldString,s ] ;
        }else{
            NSRange replaceRang = [replacementString rangeOfString:@"."] ;
            NSRange rang1 = [oldString rangeOfString:@"."] ;
            if (rang1.location != NSNotFound) {
                if (replaceRang.location != NSNotFound) {
                    
                    tempString = oldString ;
                }else{
                    tempString = [oldString stringByReplacingCharactersInRange:rang withString:replacementString] ;
                }
            }else{
                if (oldString.length == 0 ) {
                    if (replaceRang.location != NSNotFound) {
                        tempString = [NSString stringWithFormat:@"0%@",replacementString] ;
                        
                    }else{
                        
                        tempString = [NSString stringWithFormat:@"%@%@",oldString,replacementString];
                    }
                }else{
                    
                    tempString = [NSString stringWithFormat:@"%@%@",oldString,replacementString];
                    
                }
            }
        }
    }
    if (isInt) {
        NSRange rang2 = [tempString rangeOfString:@"."] ;
        if (rang2.location != NSNotFound) {
            tempString = [tempString stringByReplacingCharactersInRange:NSMakeRange(rang2.location, tempString.length - rang2.location) withString:@""] ;
        }
    }
    if (isTwo) {
        NSRange rang2 = [tempString rangeOfString:@"."] ;
        if (rang2.location != NSNotFound) {
            NSString *string = [tempString substringFromIndex:rang2.location] ;
            
            if (string.length > 3 ) {
                string = [string substringToIndex:3] ;
                tempString = [NSString stringWithFormat:@"%@%@",[tempString substringToIndex:rang2.location],string];
            }
        }
    }
    if (tempString.length > 1) {
        
        if ([[tempString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"0"] && ![[tempString substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]) {
            tempString = [tempString substringWithRange:NSMakeRange(1, tempString.length - 1 )];
        }
    }
    
    
    return tempString ;
}

/**
 *  判断价格是否超过最大的限制  price 判断价格  maxInteger 最大的整形（111111） maxDecimal 最大的小数（99）
 *  maxInteger 若有输入小数 只会取小数钱的 小数后不取   maxDecimal 只会取前两位 有小数也不会取小数 不够两位在后面补0
 */
+ (BOOL)exceedsTheMaximum:(NSString *)price maxInteger:(NSString *)maxInteger maxDecimal:(NSString *)maxDecimal
{
    BOOL exceed = NO;   /**< 是否超过 yes  超过 no  没有超过*/
    NSRange integerRange = [maxInteger rangeOfString:@"."];
    if (integerRange.location != NSNotFound) {
        maxInteger = [maxInteger substringToIndex:integerRange.location];
    }
    
    NSRange decimalRange = [maxDecimal rangeOfString:@"."];
    if (decimalRange.location != NSNotFound) {
        maxDecimal = [maxDecimal substringToIndex:decimalRange.location];
    }
    if (maxDecimal.length < 2 ) {
        if (maxDecimal.length == 0 ) {
            maxDecimal = @"00";
        }else if (maxDecimal.length == 1){
            maxDecimal = [NSString stringWithFormat:@"%@0",maxDecimal];
        }
    }
    
    NSString *priceString = [NSString getNoPointStr:price];
    NSRange priceRange = [price rangeOfString:@"."];
    if (priceRange.location != NSNotFound) {
        if (priceString.integerValue <= [NSString stringWithFormat:@"%@%@",maxInteger,maxDecimal].integerValue) {
            exceed = NO;
        }else{
            exceed = YES;
        }
    }else{
        if (priceString.integerValue <= [NSString stringWithFormat:@"%@00",maxInteger].integerValue) {
            exceed = NO;
        }else{
            exceed = YES;
        }
    }
    
    return exceed;
}
/**
 *  随机产生 32 位
 */
+(NSString *)ret32bitString

{
    
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('a' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}

//得到百倍于当前数字值的字符串
+ (NSString *)getNoPointStr:(NSString *)str{
    
    if (str == nil) {
        str = @"";
    }
    
    NSArray *arr = [str componentsSeparatedByString:@"."];
    NSMutableString *resultStr = [NSMutableString string];
    
    if (arr.count > 1) {
        NSString *secondStr = arr[1];
        if (secondStr.length == 1) {
            secondStr = [NSString stringWithFormat:@"%@0",secondStr];
        }
        else if (secondStr.length == 2){
            
        }
        else if (secondStr.length == 0 ){
            secondStr = @"00";
        }
        else{
            secondStr = [secondStr substringToIndex:2];
        }
        [resultStr appendString:arr[0]];
        [resultStr appendString:secondStr];
    }
    else{
        [resultStr appendString:str];
        [resultStr appendString:@"00"];
    }
    return resultStr;
}

/**
 *  将价格变成小数后两位的价格字符串  只适用 加 减的  
 */
+ (NSString *)obtainTotalPrice:(NSInteger)totalPrice
{
    NSMutableString *priceStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)totalPrice]];
    if (priceStr.length < 3) {
        if (totalPrice == 0 && priceStr.length == 1) {
            [priceStr appendString:@".00"];
        }else{
            if (priceStr.length == 1 ) {
                [priceStr insertString:@"0.0" atIndex:0];
            }else if (priceStr.length == 2){
                [priceStr insertString:@"0." atIndex:0];
            }
        }
    }else{
        [priceStr insertString:@"." atIndex:priceStr.length - 2 ];
    }
    return [priceStr copy];
}


//根据单价和数量的字符串获取总价的字符串
+ (NSString *)getTotalPriceStringWithPrice:(NSString *)price withNum:(NSString *)numStr{
    NSInteger hundredTotalValue = [[NSString getNoPointStr:price] integerValue];
    NSInteger num = [numStr integerValue];    //数量是控制器传入，不是请求的
    NSInteger total = hundredTotalValue * num;
    if (total == 0) {
        return @"0.00";
    }
    
    NSString *totalStr = [NSString stringWithFormat:@"%ld",(long)total];
    if (totalStr.length == 1) {
        totalStr = [NSString stringWithFormat:@"0.0%@",totalStr];
    }
    else if (totalStr.length == 2){
        totalStr = [NSString stringWithFormat:@"0.%@",totalStr];
    }
    else{
        totalStr = [NSString stringWithFormat:@"%@.%@",[totalStr substringToIndex:totalStr.length - 2],[totalStr substringFromIndex:totalStr.length - 2]];
    }
    return totalStr;    //总价
}

/**
 *  图文混排 设置图片的大小  imageArray 对象为UIimage 属性
 */
+ (NSAttributedString *)obtainImageAndTextAtImageSize:(CGSize )imageSize imageArray:(NSArray *)imageArray textArray:(NSArray *)textArray
{
    NSMutableAttributedString *mutableAttributeString =  [[NSMutableAttributedString alloc] init];
    
    for (NSInteger i = 0 ; i < imageArray.count; i ++ ) {
        UIImage *imageName = imageArray[i];
        NSString *title = @"";
        if (i < textArray.count) {
            title = textArray[i];
        }
        if (title.length > 0 ) {
            if ([imageName isKindOfClass:[UIImage class]]) {
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = imageName;
                textAttachment.bounds = CGRectMake(0, -3 , imageSize.width, imageSize.height);
                if (mutableAttributeString.length > 0) {
                    [mutableAttributeString insertAttributedString:[[NSAttributedString alloc] initWithString:@"   "] atIndex:mutableAttributeString.length];
                }
                NSAttributedString *imageAttributedString  = [NSAttributedString  attributedStringWithAttachment:textAttachment];
                 [mutableAttributeString insertAttributedString:imageAttributedString atIndex:[mutableAttributeString length]];
            }
            
            NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title]];
            [mutableAttributeString insertAttributedString:titleAttributedString atIndex:[mutableAttributeString length]];
        }
    }
    
    return mutableAttributeString;
}

/**
 *  转换后的手机号码  convertedString  替换成数据  例如 (****)
 */
+ (NSString *)convertedPhone:(NSString *)convertedString phone:(NSString *)phone
{
    NSMutableString *tempPhone = [[NSMutableString alloc] init];
    [tempPhone appendString:phone];
    if (tempPhone.length > 3 ) {
        NSInteger length = phone.length - 3;
        [tempPhone replaceCharactersInRange:NSMakeRange(3, (convertedString.length > length ? length : convertedString.length)) withString:convertedString];
    }
    return tempPhone;
}
/**
 *  将秒装换成时分秒
 */
+(NSDictionary *)timeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    NSMutableDictionary *timeDic = [[NSMutableDictionary alloc] init];
    [timeDic setObject:str_hour forKey:kTimeHour];
    [timeDic setObject:str_minute forKey:kTimeMinute];
    [timeDic setObject:str_second forKey:kTimeSecond];
    [timeDic setObject:format_time forKey:kTimeShowHourMinuteSecond];
    [timeDic setObject:[NSString stringWithFormat:@"%@:%@",str_minute,str_second] forKey:kTimeShowMinuteSecond];
    
    return timeDic;
}
/**
 *  判断价格price是否小于等于 当前的价格
 */
- (BOOL)comparePrice:(NSString *)price{
    BOOL check = NO;
    if ([[NSString getNoPointStr:price] integerValue] <= [[NSString getNoPointStr:self] integerValue]) {
        check = YES;
    }
    return check;
}
/**
 *  保留数字  剔除所有非数字的字符串
 */
- (NSString *)retentionIntString{
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
     invertedSet];
    NSString *newString = [[self componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    return newString;
}

/**
 *  根据阿拉伯数字的月份获取中文的月份
 */
+(NSString *)getMonthByString:(NSString *)month {
    if ([month isEqualToString:@"1"]) {
        return @"一月";
    }else if ([month isEqualToString:@"2"]) {
        return @"二月";
    }else if ([month isEqualToString:@"3"]) {
        return @"三月";
    }else if ([month isEqualToString:@"4"]) {
        return @"四月";
    }else if ([month isEqualToString:@"5"]) {
        return @"五月";
    }else if ([month isEqualToString:@"6"]) {
        return @"六月";
    }else if ([month isEqualToString:@"7"]) {
        return @"七月";
    }else if ([month isEqualToString:@"8"]) {
        return @"八月";
    }else if ([month isEqualToString:@"9"]) {
        return @"九月";
    }else if ([month isEqualToString:@"10"]) {
        return @"十月";
    }else if ([month isEqualToString:@"11"]) {
        return @"十一月";
    }else{
        return @"十二月";
    }
}

#pragma mark - 字典转字符串
+(NSString *)stringFromDict:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //    NSRange range = {0,jsonString.length};
    //    //去掉字符串中的空格
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

- (NSString *)self_adaptionHost
{
    
    NSString * imgUrlStr = @"";
    if ([self containsString:@"http://"]) {
        imgUrlStr = self;
    }else if([self containsString:@"https://"]){
        imgUrlStr = self;
    }
    
    return imgUrlStr;
}

- (NSString *)timing{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    //    if (self.length <= 0) {
    //        CGSize sizee = CGSizeMake(0.01f, 0.01f);
    //        return sizee;
    //    }else{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    //    }
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize andlineSpacing:(CGFloat) lineSpaceing {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineSpacing = lineSpaceing;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    NSDictionary *dict = @{NSFontAttributeName : font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize originSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    NSString *test = @"我们";
    CGSize wordSize = [test sizeWithFont:font maxSize:maxSize];
    
    CGFloat selfHeight = [self sizeWithFont:font maxSize:maxSize].height;
    
    if (selfHeight <= wordSize.height) {
        
        CGSize newSize = CGSizeMake(originSize.width, font.pointSize);
        
        if (selfHeight == 0) {
            
            newSize = CGSizeMake(originSize.width, 0);
        }
        
        originSize = newSize;
    }
    
    return originSize;
}

#pragma mark - 高度
- (CGFloat)xw_dynamicCalculationHeight{
    
    CGFloat height = [self boundingRectWithSize:CGSizeMake(kXWDynamicCalculationSize_DefaultWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:kXWDynamicCalculationSize_DefaultFont} context:nil].size.height;
    return height;
}

- (CGFloat)xw_dynamicCalculationHeightWithFont:(UIFont *)font FixWidth:(CGFloat)fixWidth{
    CGFloat myFixWidth = fixWidth > 0?fixWidth:kXWDynamicCalculationSize_DefaultWidth;
    UIFont*myFont = (font != nil)?font:kXWDynamicCalculationSize_DefaultFont;
    
    CGFloat height = [self boundingRectWithSize:CGSizeMake(myFixWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:myFont} context:nil].size.height;
    
    return height;
}

-(CGFloat)xw_dynamicCalculationHeightWithFixWidth:(CGFloat)fixWidth Attributes:(NSDictionary<NSString *,id> *)attributes{
    CGFloat myFixWidth = fixWidth > 0?fixWidth:kXWDynamicCalculationSize_DefaultWidth;
    
    CGFloat height = [self boundingRectWithSize:CGSizeMake(myFixWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size.height;
    
    return height;
}
#pragma mark - 宽度
- (CGFloat)xw_dynamicCalculationWidth{
    CGFloat width = [self boundingRectWithSize:CGSizeMake(kXWDynamicCalculationSize_DefaultHeight, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:kXWDynamicCalculationSize_DefaultFont} context:nil].size.width;
    return width;
}

-(CGFloat)xw_dynamicCalculationWidthWithFont:(UIFont *)font FixHeight:(CGFloat)fixHeight{
    CGFloat myFixHeight = fixHeight > 0?fixHeight:kXWDynamicCalculationSize_DefaultHeight;
    UIFont*myFont = (font != nil)?font:kXWDynamicCalculationSize_DefaultFont;
    
    CGFloat width = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, myFixHeight) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:myFont} context:nil].size.width;
    
    return width;
}

- (CGFloat)xw_dynamicCalculationWidthWithFixHeight:(CGFloat)fixHeight Attributes:(NSDictionary<NSString *,id> *)attributes{
    CGFloat myFixHeight = fixHeight > 0?fixHeight:kXWDynamicCalculationSize_DefaultHeight;
    
    CGFloat width = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, myFixHeight) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size.width;
    
    return width;
}

//给UILabel设置行间距和字间距

-(void)xw_setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font space:(CGFloat)space{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = space; //设置行间距
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
    
}

//计算UILabel的高度(带有行间距的情况)

-(CGFloat)xw_getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width space:(CGFloat)space {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = space;
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
//    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
//    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil].size;
//    NSLog(@" size =  %@", NSStringFromCGSize(size));
    // 并不是高度计算不对，我估计是计算出来的数据是 小数，在应用到布局的时候稍微差一点点就不能保证按照计算时那样排列，所以为了确保布局按照我们计算的数据来，就在原来计算的基础上 取ceil值，再加1；
    CGFloat height = ceil(size.height) + 1;
//    NSLog(@" 文字：%@ -------- 的高度：%f",str,height);
    return height;
        
}

//计算UILabel的宽度(带有行间距的情况)

-(CGFloat)xw_getSpaceLabelWidth:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width space:(CGFloat)space {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = space;
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.width;
    
}

/**
 * 带中文或者特殊符号的编码
 */
+(NSString*)encodeString:(NSString*)uncodeString {
//    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) uncodeString,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return (NSString *)CFBridgingRelease((__bridge CFTypeRef _Nullable)([[uncodeString description] stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"] invertedSet]]));
}
/**
 * 带中文或者特殊符号的解码
*/
+(NSString*)decodeString:(NSString*)decodeString{
    //return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)decodeString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)decodeString, CFSTR("")));
}

- (NSString *)eliminateZeroWithDouble:(NSInteger)integer{
    
    NSString *str = [self copy];
    double fdouble = [str doubleValue];
    NSString *ftotal;
    switch (integer) {
        case 1:
            ftotal = [NSString stringWithFormat:@"%.1f", fdouble];
            break;
        case 2:
            ftotal = [NSString stringWithFormat:@"%.2f", fdouble];
            break;
        case 3:
            ftotal = [NSString stringWithFormat:@"%.3f", fdouble];
            break;
        case 4:
            ftotal = [NSString stringWithFormat:@"%.4f", fdouble];
            break;
        case 5:
            ftotal = [NSString stringWithFormat:@"%.5f", fdouble];
            break;
        case 6:
            ftotal = [NSString stringWithFormat:@"%.6f", fdouble];
            break;
        default:
            break;
    }
    while ([ftotal hasSuffix:@"0"]) {
        ftotal = [ftotal substringToIndex:[ftotal length]-1];
    }
    while ([ftotal hasSuffix:@"."]) {
        ftotal = [ftotal substringToIndex:[ftotal length]-1];
    }
    return ftotal;
}

/**
*  教师端 - 密码规则 - 建议密码长度不少于8位，且密码中至少包含数字、字母和符号；^(?=.*\d)(?=.*[a-zA-Z])(?=.*[~!@#$%^&*￥])[\da-zA-Z~!@#$%^&*￥]{8,}$
*/
+ (BOOL)checkIsMatchNumLetterAndSpecialCharacter:(NSString*)password {
    //NSString *newPattern = @"^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[~!@#$%^&*￥_+-=()])[[0-9]a-zA-Z~!@#$%^&*￥_+-=()]{8,}$";
    NSString *newPattern = @"^(?=.*)(?=.*[a-zA-Z])(?=.*[~!@#$%^&*:;,.=?$\x22]).{8,14}$"; //密码至少包含一个数字，一个字母，一个特殊字符。
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", newPattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

/*!

* @brief 把格式化的JSON格式的字符串转换成字典

* @param jsonString JSON格式的字符串

* @return 返回字典

*/

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;{
    
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    NSError *err;

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData

    options:NSJSONReadingMutableContainers

    error:&err];

    if(err) {

    NSLog(@"json解析失败：%@",err);

    return nil;

    }

    return dic;

}


@end
