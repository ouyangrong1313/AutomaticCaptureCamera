//
//  NSDate+SSDate.h
//  私塾家
//
//  Created by liew on 2018/3/12.
//  Copyright © 2018年 Liew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SSDate)

/**
 * 将某个时间Str转化成 时间戳
 */
+(NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

/**
 * 根据时间戳转换为时间
 */
+(NSDate *)getByDateByTimeInterval:(NSString *)timeInterval;

/**
 *  根据时间戳转换为时间 yyyy-MM-dd
 */
+(NSString *)getDateStringByTimeInterVal:(NSString *)timeInterval;

/**
 * 根据日期获取NSDateString 如2018-03-11 16:59
 */
+(NSString *)getDateAndTimeStringByDate:(NSDate *)date;

/**
 * 根据日期获取完整的日期 如2018-03-11 16:59:28
 */
+(NSString *)getDateAndTimeFullStringByDate:(NSDate *)date;

/**
 * 根据日期获取Date 如2018.03.08 16:59:28
 */
+(NSString *)getFullDateStringByDate:(NSDate *)date;

/**
 * 根据日期获取NSDateString 如2018-03-11
 */

+(NSDate *)getYMDDateByDateString:(NSString *)dateString;

/**
 * 根据日期获取NSDateString 如2018-03
 */
+(NSDate *)getYMDateByDateString:(NSString *)dateString;

/**
 * 根据日期获取年份 如2018
 */

+(NSString *)getYearStringByDate:(NSDate *)date;

/**
 * 根据日期获取月份 如03月
 */

+(NSString *)getMonthStringByDate:(NSDate *)date;

/**
 * 根据日期获取日期 如12日
 */

+(NSString *)getDayStringByDate:(NSDate *)date;

/**
* 根据日期获取NSDateString 如2018-03-11 16:59
*/

+(NSDate *)getDateByDateString:(NSString *)dateString;

/**
 * 根据日期字符串获取全日期 如2018-03-11 16:59:32
 */
+(NSDate *)getFullDateByDateString:(NSString *)dateString;

/**
 * 根据日期获取NSDateString 如2018-03-11
 */
+(NSString *)getDateStringWithDate:(NSDate *)date;

/**
 * 根据日期获取当前的年月
 */
+(NSString *)getYearAndMonthStringByDate:(NSDate *)date;

/**
 * 根据日期获取Date 如2018.03.08
 */
+(NSString *)getDateStringByDate:(NSDate *)date;

/**
 * 根据日期获取完整的时间 如16:59:28
 */

+(NSString *)getTimeWithSecondStringByDate:(NSDate *)date;

/**
 * 根据日期获取Time 如16:59
 */
+(NSString *)getTimeStringByDate:(NSDate *)date;

/**
 * 转换成xx天xx时xx分xx秒
 */
+(NSString *)tranlateDistanceTimeStringByDistanceSecond:(NSInteger)distanceTime;

/**
 *  获取某年某月的天数
 */
+(NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month;


//比较两个日期的大小  日期格式为2016-08-14
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;


/**
 * 判断是否大于当前时间
 */
+ (int)compareDay:(NSDate *)day;
    
/**
 * 判断与当前时间相隔多少天
 */
+(NSInteger)componentsDaysFormNowWithDate:(NSDate *)endDate;

/**
 * 判断与当前时间是否在七天之内
 */
+(BOOL)componentsDaysFormNowInweekWithDate:(NSDate *)endDate;

/**
 * 是否过期
 */
+(BOOL)componentsDayInAvailable:(NSDate *)endDate;

/**
 * 获取当前日期的前n个月或后n个月时间
*/
+(NSString *)beforeDate:(NSInteger)n;

/**
 * 获取本周周一到周日的日期
*/
+(NSArray *)adddDataOnViewsWithDate:(NSDate *)nowDate;

/**
 * 获取上周的时间
*/
+(NSString *)getLastWeekDayTime:(NSInteger)weekDay;


/**
 * 获取上个月的年份
*/
+ (NSString *)getLastMonthOfYearWithDate:(NSDate *)nowDate;

/**
 * 获取上个月的月份
*/
+(NSString *)getLastMonthOfMonthWithDate:(NSDate *)nowDate;

/**
 * 获取本周的日期
*/
+(NSString *)currentScopeWeek:(NSUInteger)firstWeekday dateFormat:(NSString *)dateFormat withDate:(NSDate *)nowDate;

/**
 * 根据日期获取是几号
*/
+(NSString *)getTadayWithDate:(NSDate*)nowDate;

/**
 * 获取今天日期的前几天 days(前几天)
 */
+(NSDate *)getDateBeforeTodayWithDayas:(NSInteger)days;

/**
 * 根据日期获取日期缩写形式如:21.11.7
 */
+(NSString *)getShortDateStringWithDate:(NSDate *)date;

/**
 * 获取当前年
 */
+ (NSInteger)getCurrentYear;

/**
 * 获取当前月
 */
+ (NSInteger)getCurrentMonth;

@end
