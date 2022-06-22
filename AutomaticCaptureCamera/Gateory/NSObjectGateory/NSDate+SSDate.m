//
//  NSDate+SSDate.m
//  私塾家
//
//  Created by liew on 2018/3/12.
//  Copyright © 2018年 Liew. All rights reserved.
//

#import "NSDate+SSDate.h"
#import "NSDate+YYAdd.h"

@implementation NSDate (SSDate)

/**
 * 将某个时间Str转化成 时间戳
 */
+(NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; // 默认
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];  //（@"YYYY-MM-dd HH:mm:ss"）----------注意>hh为12小时制,HH为24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime];
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return [NSString stringWithFormat:@"%ld",timeSp];
}

/**
 * 根据时间戳转换为时间
 */
+(NSDate *)getByDateByTimeInterval:(NSString *)timeInterval {
    NSTimeInterval time = [[timeInterval substringToIndex:10] doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    return date;
}

/**
 *  根据时间戳转换为时间 yyyy-MM-dd
 */
+(NSString *)getDateStringByTimeInterVal:(NSString *)timeInterval {
    NSTimeInterval time = [[timeInterval substringToIndex:10] doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startStr = [dateformatter stringFromDate:date];
    return startStr;
}

/**
 * 根据日期获取Date 如2018.03.08
 */
+(NSString *)getDateStringByDate:(NSDate *)date {
    return [NSString stringWithFormat:@"%@.%@.%@",[self getYearStringByDate:date],[self getMonthStringByDate:date],[self getDayStringByDate:date]];
}

/**
 * 根据日期获取Date 如2018.03.08 16:59:28
 */
+(NSString *)getFullDateStringByDate:(NSDate *)date {
    NSString *startStr = [self getDateAndTimeFullStringByDate:date];
    return [NSString stringWithFormat:@"%@.%@.%@ %@",[self getYearStringByDate:date],[self getMonthStringByDate:date],[self getDayStringByDate:date],[startStr substringFromIndex:10]];
}

/**
 * 根据日期获取完整的日期 如2018-03-11 16:59:28
 */
+(NSString *)getDateAndTimeFullStringByDate:(NSDate *)date {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startStr=[dateformatter stringFromDate:date];
    return startStr;
}

/**
 * 根据日期获取NSDateString 如2018-03-11 16:59
 */
+(NSString *)getDateAndTimeStringByDate:(NSDate *)date {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startStr=[dateformatter stringFromDate:date];
    return startStr;
}

/**
 * 根据日期获取NSDateString 如2018-03-11 16:59
 */
+(NSDate *)getDateByDateString:(NSString *)dateString {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateformatter dateFromString:dateString];
    return date;
}

+(NSDate *)getYMDDateByDateString:(NSString *)dateString {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateformatter dateFromString:dateString];
    return date;
}

+(NSDate *)getYMDateByDateString:(NSString *)dateString {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateformatter dateFromString:dateString];
    return date;
}


/**
 * 根据日期字符串获取全日期 如2018-03-11 16:59:32
 */
+(NSDate *)getFullDateByDateString:(NSString *)dateString {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateformatter dateFromString:dateString];
    return date;
}

/**
 * 根据日期获取NSDateString 如2018-03-11
 */
+(NSString *)getDateStringWithDate:(NSDate *)date {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startStr=[dateformatter stringFromDate:date];
    return startStr ? startStr : @"";
}

/**
 * 根据日期获取当前的年月
 */
+(NSString *)getYearAndMonthStringByDate:(NSDate *)date{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM"];
    NSString *startStr=[dateformatter stringFromDate:date];
    return startStr;
}

/**
 * 根据日期获取年份 如2018
 */

+(NSString *)getYearStringByDate:(NSDate *)date {
    NSString *dateString = [self getDateAndTimeStringByDate:date];
    return [dateString substringWithRange:NSMakeRange(0, 4)];
}

/**
 * 根据日期获取年份缩写 如18(2018)
 */

+(NSString *)getShortYearStringByDate:(NSDate *)date {
    NSString *dateString = [self getDateAndTimeStringByDate:date];
    return [dateString substringWithRange:NSMakeRange(2,2)];
}

/**
 * 根据日期获取月份 如03月
 */

+(NSString *)getMonthStringByDate:(NSDate *)date {
    NSString *startStr = [self getDateAndTimeStringByDate:date];
    return [startStr substringWithRange:NSMakeRange(5,2)];
}

/**
 * 根据日期获取日期 如12日
 */

+(NSString *)getDayStringByDate:(NSDate *)date {
    NSString *startStr = [self getDateAndTimeStringByDate:date];
    return [startStr substringWithRange:NSMakeRange(8,2)];
}

/**
 * 根据日期获取完整的时间 如16:59:28
 */

+(NSString *)getTimeWithSecondStringByDate:(NSDate *)date {
    NSString *startStr = [self getDateAndTimeFullStringByDate:date];
    return [startStr substringFromIndex:10];
}

/**
 * 根据日期获取时间 如16:59
 */

+(NSString *)getTimeStringByDate:(NSDate *)date {
    NSString *startStr = [self getDateAndTimeStringByDate:date];
    return [startStr substringFromIndex:10];
}



/**
 * 转换成xx天xx时xx分xx秒
 */
+(NSString *)tranlateDistanceTimeStringByDistanceSecond:(NSInteger)distanceTime {
    NSString *timeString;
    NSInteger day =   distanceTime/(24*60*60);
    NSInteger hour  = (distanceTime%(24*60*60))/(60*60); // 小时
    NSInteger minte = (distanceTime%3600)/60; // 分钟
    NSInteger second = (distanceTime%3600)%60; //秒钟
    NSString *dayString = day>9?[NSString stringWithFormat:@"%ld",day]:[NSString stringWithFormat:@"0%ld",day];
    NSString *hourString = hour >9?[NSString stringWithFormat:@"%ld",hour]:[NSString stringWithFormat:@"0%ld",hour];
    NSString *minteString = minte>9?[NSString stringWithFormat:@"%ld",minte]:[NSString stringWithFormat:@"0%ld",minte];
    NSString *secondString = second>9?[NSString stringWithFormat:@"%ld",second]:[NSString stringWithFormat:@"0%ld",second];
    if (day > 0) {
        timeString = [NSString stringWithFormat:@"%@天%@时%@分",dayString,hourString,minteString];
    }else{
        if (hour >0) {
            timeString = [NSString stringWithFormat:@"%@时%@分%@秒",hourString,minteString,secondString];
        }else{
            timeString = [NSString stringWithFormat:@"%@:%@",minteString,secondString];
        }
    }
    return timeString;
}

/**
 *  获取某年某月的天数
 */
+(NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month {
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3)){
        return 28;
    }
    if(year % 400 == 0)
        return 29;
    if(year % 100 == 0)
        return 28;
    return 29;
}

//比较两个日期的大小  日期格式为2016-08-14
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate {
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedSame) {
        // 相等
        aa=0;
    }else if (result == NSOrderedAscending){
        //bDate比aDate大
        aa=1;
    }else{
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}

/**
 * 判断是否大于当前时间
 */
+(int)compareDay:(NSDate *)day {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *myDayStr = [dateFormatter stringFromDate:self];
    NSString *dayStr = [dateFormatter stringFromDate:day];
    NSDate *dateA = [dateFormatter dateFromString:myDayStr];
    NSDate *dateB = [dateFormatter dateFromString:dayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"DateA  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"DateA is in the past");
        return -1;
    }
        //NSLog(@"Both dates are the same");
    return 0;
    
}

/**
 * 判断与当前时间是否已经过期
 */
+(NSInteger)componentsDaysFormNowWithDate:(NSDate *)endDate{
    //创建两个日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *fromDateString1 = [dateFormatter stringFromDate:endDate];
    NSString *toDateString1 = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *fromDate1 = [dateFormatter dateFromString:fromDateString1];
    NSDate *toDate1 = [dateFormatter dateFromString:toDateString1];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    
    NSString *fromDateString2 = [dateFormatter2 stringFromDate:fromDate1];
    NSString *toDateString2 = [dateFormatter2 stringFromDate:toDate1];
    
    NSDate *fromDate = [dateFormatter2 dateFromString:fromDateString2];
    NSDate *toDate = [dateFormatter2 dateFromString:toDateString2];

    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:toDate toDate:fromDate options:0];
    //打印
    NSLog(@"%@",delta);
    //获取其中的"天"
    NSLog(@"%ld",delta.day);
    return delta.day;
}

/**
 * 判断与当前时间是否在七天之内
 */
+(BOOL)componentsDaysFormNowInweekWithDate:(NSDate *)endDate{
   //NSInteger years = [self componentsDaysFormNowWithDate:endDate];
   NSInteger days = [self componentsDaysFormNowWithDate:endDate];
   return (days>=0&&days<=6)?YES:NO;
}

/**
 * 是否过期
 */
+(BOOL)componentsDayInAvailable:(NSDate *)endDate{
    NSInteger days = [self componentsDaysFormNowWithDate:endDate];
    return (days<0)?YES:NO;
}

/**
 * 获取当前日期的前n个月或后n个月时间
*/
+(NSString *)beforeDate:(NSInteger)n {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDateStr = [formatter stringFromDate:currentDate];
    NSLog(@"当前日期：%@",nowDateStr);

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    // [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:n];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:newdate];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSLog(@"currentDate = %@ ,year = %ld ,month=%ld, day=%ld",currentDate,year,month,day);
    return [NSString stringWithFormat:@"%ld",month];
}


+(NSArray *)adddDataOnViewsWithDate:(NSDate *)nowDate{
       NSCalendar *calendar = [NSCalendar currentCalendar];
       NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
       // 获取今天是周几
       NSInteger weekDay = [comp weekday];
       // 获取几天是几号
       NSInteger day = [comp day];
       // 计算当前日期和本周的星期一和星期天相差天数
       long firstDiff,lastDiff;
       // weekDay = 1;
       if (weekDay == 1)
       {
           firstDiff = -6;
           lastDiff = 0;
       }
       else
       {
           firstDiff = [calendar firstWeekday] - weekDay + 1;
           lastDiff = 8 - weekDay;
       }
       // NSLog(@"firstDiff: %ld lastDiff: %ld",firstDiff,lastDiff);
       // 在当前日期(去掉时分秒)基础上加上差的天
       NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:nowDate];
       [firstDayComp setDay:day + firstDiff];
       NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
       NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:nowDate];
       [lastDayComp setDay:day + lastDiff];
       NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"dd"];
       NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
       NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
        NSLog(@"%@=======%@",firstDay,lastDay);
       
       int firstValue = firstDay.intValue;
       int lastValue = lastDay.intValue;
       
       NSMutableArray *dateArr = [[NSMutableArray alloc]init];
       if (firstValue < lastValue) {
           
           for (int j = 0; j<7; j++) {
               NSString *obj = [NSString stringWithFormat:@"%d",firstValue+j];
               [dateArr addObject:obj];
           }
       }
       else if (firstValue > lastValue)
       {
           for (int j = 0; j < 7-lastValue; j++) {
               NSString *obj = [NSString stringWithFormat:@"%d",firstValue+j];
               [dateArr addObject:obj];
           }
           for (int z = 0; z<lastValue; z++) {
               NSString *obj = [NSString stringWithFormat:@"%d",z+1];
               [dateArr addObject:obj];
           }
       }
    return dateArr;
}

+(NSString *)getLastWeekDayTime:(NSInteger)weekDay {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //在当前日期基础上加上时间差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfYear fromDate:nowDate];
    [firstDayComp setDay:weekDay-7];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    NSString *dateStr = [NSDate getDateStringByDate:firstDayOfWeek];
    return dateStr;
}

/**
 * 获取上个月的年份
*/

+(NSString *)getLastMonthOfYearWithDate:(NSDate *)nowDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //[lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:nowDate options:0];
    return [NSString stringWithFormat:@"%zd",newdate.year];
}

/**
 * 获取上个月的月份
*/
+(NSString *)getLastMonthOfMonthWithDate:(NSDate *)nowDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //[lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:-1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:nowDate options:0];
    return [NSString stringWithFormat:@"%zd",newdate.month];
}

+(NSString *)currentScopeWeek:(NSUInteger)firstWeekday dateFormat:(NSString *)dateFormat withDate:(NSDate *)nowDate{
    //nowDate  = [NSDate dateWithString:@"2020.01.02" format:@"yyyy.MM.dd"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    // 1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
    calendar.firstWeekday = firstWeekday;
    
    // 日历单元
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    unsigned unitNewFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowComponents = [calendar components:unitFlag fromDate:nowDate];
    // 获取今天是周几，需要用来计算
    NSInteger weekDay = [nowComponents weekday];
    // 获取今天是几号，需要用来计算
    NSInteger day = [nowComponents day];
    // 计算今天与本周第一天的间隔天数
    NSInteger countDays = 0;
    // 特殊情况，本周第一天firstWeekday比当前星期weekDay小的，要回退7天
    if (calendar.firstWeekday > weekDay) {
        countDays = 7 + (weekDay - calendar.firstWeekday)+7;
    }else{
        countDays = weekDay - calendar.firstWeekday+7;
    }
    // 获取这周的第一天日期
    NSDateComponents *firstComponents = [calendar components:unitNewFlag fromDate:nowDate];
    [firstComponents setDay:day - countDays];
    NSDate *firstDate = [calendar dateFromComponents:firstComponents];
    
    // 获取这周的最后一天日期
    NSDateComponents *lastComponents = firstComponents;
    [lastComponents setDay:firstComponents.day + 6];
    NSDate *lastDate = [calendar dateFromComponents:lastComponents];
    
    // 输出
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *firstDay = [formatter stringFromDate:firstDate];
    NSString *lastDay = [formatter stringFromDate:lastDate];
    
    return [NSString stringWithFormat:@"%@-%@",firstDay,lastDay];
}

+(NSString *)getTadayWithDate:(NSDate*)nowDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    return [NSString stringWithFormat:@"%zd",day];
}

+(NSDate *)getDateBeforeTodayWithDayas:(NSInteger)days{
    NSDate *currentDate = [NSDate date];
    NSDate *appointDate; // 指定日期声明
    NSTimeInterval oneDay = 24 * 60 * 60; // 一天一共有多少秒
    appointDate = [currentDate initWithTimeIntervalSinceNow: -(oneDay * days)];
    return appointDate;
}

+ (NSInteger)getCurrentYear {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
//    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:0];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:newdate];
    NSInteger year = [components year];
    return year;
}

+ (NSInteger)getCurrentMonth {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
//    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:0];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:newdate];
    NSInteger month = [components month];
    return month;
}


/**
 * 根据日期获取日期缩写形式如:21.11.7
 */
+(NSString *)getShortDateStringWithDate:(NSDate *)date{
    return [NSString stringWithFormat:@"%@.%@.%@",[self getShortYearStringByDate:date],[self getMonthStringByDate:date],[self getDayStringByDate:date]];
}

@end
