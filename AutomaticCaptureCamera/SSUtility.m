//
//  SSUtility.m
//  私塾家
//
//  Created by liew on 2018/2/11.
//  Copyright © 2018年 Liew. All rights reserved.

#import "SSUtility.h"
#include <sys/xattr.h>
#import "CommonCrypto/CommonDigest.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>
#import <Photos/Photos.h>
#import <sys/utsname.h>

#define kQuestionMark                             @"?"                        // ？

@implementation SSUtility


/**
 *  判断该路径下是否有文件
 *
 *  @param path
 *
 *  @return 返回布尔值
 */
+(BOOL)isExistFileForPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

+(CGFloat)transformedValue:(id)value{

   double convertedValue = [value doubleValue];
   int multiplyFactor = 0;

   NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil];

   while (convertedValue > 1024) {

       convertedValue /= 1024;

       multiplyFactor++;

   }

    return convertedValue;
   //return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];

}

/**
 *  得到系统的缓存路径
 *
 *  @return 缓存路径
 */
+ (NSString *)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}
/**
 *  得到根目录
 *
 *  @return
 */
+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  获取Caches文件夹
 *
 *  @return <#return value description#>
 */
+ (NSString *)getCachePath{
    NSString *deletedDirectory = [NSString stringWithFormat:@"%@/Library/Caches", NSHomeDirectory()];
    return deletedDirectory;
}
/**
 *  删除缓存文件夹
 *
 *  @return
 */
+ (void)deleteFilesInCacheDirectory{    //删除缓存文件夹的可删除文件夹
    [[NSFileManager defaultManager] removeItemAtPath:[self getCachePath] error:nil];
}
/**
 *  清除文件夹下所有的文件及文件夹
 *
 *  @param directory 所要删除的文件夹目录
 */
+(void)deleteFilesInDirectory:(NSString *)directory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:directory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[directory stringByAppendingPathComponent:filename] error:NULL];
    }
}
/**
 *  防止上传到icloud
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL bundleIdentifier:(NSString *)bundleIdentifier
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = [bundleIdentifier UTF8String];
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}
/**
 *  获取启动图路径
 *
 *  @return
 */
+(NSString *)getLaunchImagePath{
    NSString *launchImageDirectoryPath = [NSString stringWithFormat:@"%@/launchImagePath", [self getDocumentBaseDirectory]];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:launchImageDirectoryPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        existed = [fileManager createDirectoryAtPath:launchImageDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        return [launchImageDirectoryPath stringByAppendingString:@"/launchImage"];
    }
    else{
        return nil;
    }
}

/**
 *  删除启动图文件夹
 *
 *  @return
 */
+(BOOL)deleteLaunchImageDirectoryPath{
    return [[NSFileManager defaultManager] removeItemAtPath:[self getLaunchImagePath] error:nil];
}
/**
 *  获取旧的数据库路径
 *
 *  @return
 */
+(NSString *)getDataBaseOldPath{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path ;
    if (array.count != 0) {
        path = array [0];
    }
    NSString *dbFilePath ;
    if (path.length != 0 ) {
        dbFilePath = [path stringByAppendingPathComponent:@"dataBase.db"] ;
    }
    return dbFilePath ;
}
/**
 *  创建document文件夹下的不删除的base文件夹
 *
 *  @return
 */
+(NSString *)getDocumentBaseDirectory{
    NSString *documentBaseDirectory = [NSString stringWithFormat:@"%@/Documents/CloudCityBase", NSHomeDirectory()];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:documentBaseDirectory isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:documentBaseDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentBaseDirectory;
}
/**
 *  创建文件夹
 *
 *  @param rootPath      路径，必须是文件夹路径
 *  @param directoryName 路径下面的文件夹名字
 *
 *  @return 返回整个文件夹的路径
 */
+(NSString *)creatDirectoryRootPath:(NSString *)rootPath andDirectoryName:(NSString *)directoryName{
    
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@", rootPath,directoryName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
       [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directoryPath;
}


/**
 *  获取录音的文件夹
 *
 *  @return 
 */
+(NSString *)getRecordDirectory{
    NSString *path = [NSString stringWithFormat:@"%@/Record",[self getCachePath]];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

/**
 *  删除文件或文件夹
 *
 *  @param filePath 需要删除的路径
 *
 *  @return
 */
+(BOOL)deleteFile:(NSString *)filePath{
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}


/**
 * 网络请求 返回是Dictionary  对象
 *
 *  @param response
 *
 *  @return
 */
+ (NSDictionary *)requestReturnTypeOfDictionary:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)response;
    }else {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        return dic ;
    }
}

/**
 * 网络请求 返回是Array  对象
 *
 *  @param response
 *
 *  @return
 */
+ (NSArray *)requestReturnTypeOfArray:(id)response {
    NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    return array ;
}
/**
 * 网络请求  判断返回是否为空和是否错误的
 *
 *  @param response
 *
 *  @return
 */
+ (BOOL)requestResponseObjectIsTrue:(id)respone{
    BOOL ret = NO ;
    if (respone && ![respone isKindOfClass:[NSError class]]) {
        ret = YES;
    }else{
        ret = NO ;
    }
    return ret ;
}

/**
 *  移除文件
 */
+(void)removeForder:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        BOOL result = [fileManager removeItemAtPath:filePath error:nil];
        if (result) {
        }
    }
}
+(BOOL)isFileExist:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}

/**
 *  判断是否是第一次运行（下载或更新）
 */
+(BOOL)dateUped:(BOOL)save code:(NSString *)code{
    NSString *verTionStr = code;
    NSString *loginedVertionStr = [NSString stringWithFormat:@"logined%@",verTionStr];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:loginedVertionStr]) {
        return NO;
    }
    else{
        if (save) {     //以版本字段为key，保存布尔值YES，标示已经更新过
            [userDefault setBool:YES forKey:loginedVertionStr];
        }
        return YES;
    }
}

// 字符串(json格式)转化成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/**
 *  强制隐藏键盘方法
 */
+ (void)hideKeyboard{
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return ;
}
/*
 *  判断有没开启相机权限
 *
 *  @return yes 为开启中  no 没有开启
 */
+ (BOOL)isAuthorizationStatusTypeCamera:(BOOL)isAlert{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
     BOOL isAuthor = YES;
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        isAuthor = NO;
    }
    if (isAlert && !isAuthor) {
        NSDictionary *dicInfo = [SSUtility dictionaryFromInfoPlist];
        NSString *name = @"";
        if ([dicInfo isKindOfClass:[NSDictionary class]]) {
            name = dicInfo[@"CFBundleDisplayName"];
        }
        if (!name) {
            name = @"";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您没开启相机功能 请在设置->隐私->相机->%@ 设置为打开状态",name] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
    }
    
    return isAuthor;
}

/*!
 *  判断有没开启相册权限
 *
 *  @return yes 为开启中  no 没有开启
 */
+ (BOOL)isAuthorizationStatusTypePhotoLibrary:(BOOL)isAlert{
    BOOL isAuthor = YES;
    
//    if (iOS8UP) {
         PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied || PHAuthorizationStatusNotDetermined) {
            // 无权限
            isAuthor = NO;
        }
//    }else{
//         ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
//        {
//            // 无权限
//           isAuthor = NO;
//        }
//    }
//
    if (isAlert && !isAuthor) {
        NSDictionary *dicInfo = [SSUtility dictionaryFromInfoPlist];
        NSString *name = @"";
        if ([dicInfo isKindOfClass:[NSDictionary class]]) {
            name = dicInfo[@"CFBundleDisplayName"];
        }
        if (!name) {
            name = @"";
        }
 
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您没开启照片功能 请在设置->隐私->照片->%@ 设置为打开状态",name] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
    }
    return isAuthor;
}
//获取键盘高度
+ (CGFloat)getKeyboardHeight:(NSNotification *)object{

    NSDictionary *info = [object userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    return keyboardSize.height ;
}
/**
 *  增加截取小数点, 只舍不入.
 *  @price 输入数, @position 截取位数
 */
+ (NSString *)notRounding:(float)price afterPoint:(int)position {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:position
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


#pragma mark - 发现当前语言并非项目支持的语言时，统一访问指定的资源文件，返回默认的资源
/**
 *  根据key 获取不同语言对应的词语
 *
 *  @param translation_key key
 *
 *  @return
 */
#define CURR_LANG    ([[NSLocale preferredLanguages] objectAtIndex:0])
+ (NSString *)CCLocalizedString:(NSString *)translation_key {
    
    NSString * s = NSLocalizedString(translation_key, nil);
    // 判断当前的语言是不是项目支持的语言
    /*
     iOS9 变成了en-US 和 zh-Hans-US, 香港 zh-HK
     iOS8 及以下 还是en 和 zh-Hans
     */
    // 若不是 取值为中文简体的语言对应的文字
    if (![CURR_LANG hasPrefix:@"en"] && ![CURR_LANG hasPrefix:@"zh-Hans"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else if ([s isEqualToString:translation_key]){
        // 判断根据key 获取出来的国际化是否跟key一样
        // 是 取值为中文简体的语言对应的文字
        NSString * path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    return s;
}



/**
 *  从ABRecordRef信息中获取电话号码 ;
 *
 *  @param person
 *
 *  @return
 */
+ (NSString *)phoneNumFormABRecordRef:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    ABMultiValueRef valuesRef =ABRecordCopyValue(person, kABPersonPhoneProperty);
    //查找这条记录中的名字
    NSString *firstName =CFBridgingRelease(ABRecordCopyValue(person,kABPersonFirstNameProperty));
    firstName = firstName != nil? firstName:@"";
    //查找这条记录中的姓氏
    NSString *lastName =CFBridgingRelease(ABRecordCopyValue(person,kABPersonLastNameProperty));
    lastName = lastName != nil? lastName:@"";
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",lastName,firstName]);
    //     CFRelease(person);
    CFIndex index =ABMultiValueGetIndexForIdentifier(valuesRef,identifier);

    CFStringRef value =ABMultiValueCopyValueAtIndex(valuesRef,index);

    NSString *phoneNum=[NSString stringWithFormat:@"%@",(__bridge NSString*)value];
    if ([phoneNum isEqualToString:@"(null)"]) {
        phoneNum=@"";
    }else{
        phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    phoneNum = [self retentionIntString:phoneNum];
    return phoneNum;
}

/**
 *  保留数字  剔除所有非数字的字符串
 */
+ (NSString *)retentionIntString:(NSString *)number{
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                   invertedSet];
    NSString *newString = [[number componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    return newString;
}

/**
 *  获取info.plist的字典
 *
 *  @return 返回字典
 */
+ (NSDictionary *)dictionaryFromInfoPlist {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent: @"Info.plist"];
    NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    return infoDic;
}
/**
 *  获取随机的32位
 */
+ (NSString *)obtainRandom32 {
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < 4; i++){
        [str appendString:[NSString stringWithFormat:@"%lu", (unsigned long)(10000000 + (arc4random() % 90000000))]];
    }
    return str;
}

/**
 *  判断是否开启系统通知
 */
+ (BOOL)isAllowedNotification{
    //if (iOS8UP) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
//    } else {//iOS7
//        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        if(UIRemoteNotificationTypeNone != type)
//            return YES;
//    }
    return NO;
}
/**
 *  链接拼接keyValue
 */
+ (NSString *)stringUrlAppendToken:(NSString *)url key:(NSString *)key value:(NSString *)value {
    
    NSRange rang = [url rangeOfString:kQuestionMark];
//    if (rang.location == NSNotFound) {
//        url = [NSString stringWithFormat:@"%@%@%@=%@",url,kQuestionMark,key,value];
//    }else{
//        url = [NSString stringWithFormat:@"%@%@%@=%@",url,kJoiner,key,value];
//    }
    return url;
}
/**
 *  获取时间戳  毫秒
 *
 *  @return 毫秒
 */
+ (NSString *)obtainTimeInterval{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeInterval = [NSString stringWithFormat:@"%f",interval];
    NSInteger maxLength = 13;
    if (timeInterval.length > maxLength) {
        timeInterval = [timeInterval substringToIndex:maxLength];
    }
    return timeInterval;
}
/**
 *  链接编码 不对＃进行编码
 */
+ (NSString *)concatenatedCoding:(NSString *)urlPath
{
    NSCharacterSet *uRLCombinedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@" \"+<>[\\]^`{|}"] invertedSet];
    urlPath = [urlPath stringByAddingPercentEncodingWithAllowedCharacters:uRLCombinedCharacterSet];
    return urlPath;
}
/**
 *  对特殊编码的编码
 */
+ (NSString *)concatenatedKey:(NSString *)key{
    NSCharacterSet *uRLCombinedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@" \"+%<>[\\]^`{|}/"] invertedSet];
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


#pragma mark - /*** 顶层控制器 ***/
/**
 *  获取最顶层的控制器
 */
+ (UIViewController *)obtainCurrentViewController{
    UIViewController *viewController = [self activityViewController];
    UIViewController *lastViewController  = [self getCurrentViewController:viewController];
    return lastViewController;
}

/**
 *  获取最顶层的控制器
 */
+ (UIViewController *)getCurrentViewController:(UIViewController *)viewController
{
    UIViewController *lastViewController  = nil;
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)viewController ;
        NSInteger selectIndex = tabBarController.selectedIndex ;
        if (selectIndex < tabBarController.viewControllers.count) {
            UIViewController *tabViewController = tabBarController.viewControllers[selectIndex];
            if ([tabViewController isKindOfClass:[UINavigationController class]]) {
                lastViewController = [[(UINavigationController *)tabViewController viewControllers] lastObject];
                lastViewController = [self getPresentedViewController :lastViewController];
            }else{
                lastViewController = [self getPresentedViewController:tabViewController];
            }
        }
    }else if ([viewController isKindOfClass:[UINavigationController class]]){
        
        lastViewController = [[(UINavigationController *)viewController viewControllers] lastObject];
        lastViewController = [self getPresentedViewController:lastViewController];
    }else{
        
        lastViewController = [self getPresentedViewController:viewController];
    }
    
    return lastViewController;
}
/**
 *  获取PresentedViewController
 */
+ (UIViewController *)getPresentedViewController:(UIViewController *)viewController
{
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;                // 1. ViewController 下
        
        if ([viewController isKindOfClass:[UINavigationController class]]) {                // 2. NavigationController 下
            viewController =  [self getCurrentViewController:viewController];
        }
        
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = [self getCurrentViewController:viewController];     // 3. UITabBarController 下
        }
    }
    return viewController;
}
/**
 *  获取当前处于activity状态的view controller
 */
+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

// // 获取缓存大小
+(CGFloat) getCacheSize {
//    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] totalDiskSize];
//    //获取自定义缓存大小
//    //用枚举器遍历 一个文件夹的内容
//    //1.获取 文件夹枚举器
//    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
//    NSDirectoryEnumerator*enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
//    __block NSUInteger count = 0;
//
//    //2.遍历
//    for(NSString*fileName in enumerator) {
//        NSString*path = [myCachePath stringByAppendingPathComponent:fileName];
//        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
//        count += fileDict.fileSize;//自定义所有缓存大小
//    }
//    // 得到是字节  转化为M
//    CGFloat totalSize = ((CGFloat)imageCacheSize+count)/1024/1024;
//    return totalSize;
    return 0;
}


//清除缓存
+(void) cleanCache {
//    //删除两部分
//    //1.删除 sd 图片缓存
//    //先清除内存中的图片缓存
//    [[SDImageCache sharedImageCache] clearMemory];
//    //清除磁盘的缓存
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
//
//    }];
//
//    //2.删除自己缓存
//    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
//
//    [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
}

/**
 * 获取手机机型
 */
+(NSString*)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
  
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return @"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return @"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return @"iPhone 5";
     
    if([platform isEqualToString:@"iPhone5,3"])  return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return @"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return @"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return @"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    if([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    
    if([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";

    if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";

    if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";

    if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    
    if ([platform isEqualToString:@"iPhone14,4"])   return @"iPhone 13 mini";
    
    if ([platform isEqualToString:@"iPhone14,5"])   return @"iPhone 13";
    
    if ([platform isEqualToString:@"iPhone14,2"])   return @"iPhone 13 Pro";
    
    if ([platform isEqualToString:@"iPhone14,3"])   return @"iPhone 13 Pro Max";
    
    if([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if([platform isEqualToString:@"iPad6,11"])  return @"iPad 5";
    
    if([platform isEqualToString:@"iPad6,12"])  return @"iPad 5";
    
    if([platform isEqualToString:@"iPad7,5"])  return @"iPad 6";

    if([platform isEqualToString:@"iPad7,11"])  return @"iPad 7";

    if([platform isEqualToString:@"iPad7,12"])  return @"iPad 7";
    
    if([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return @"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
    
    return platform;
}

/**
 * 是否是银行卡号
 */
+(BOOL)checkCardNo:(NSString*)cardNo{
    
    if (cardNo.length < 15) {
        
        return NO;
        
    }
    
    int oddsum = 0;     //奇数求和
    
    int evensum = 0;    //偶数求和
    
    int allsum = 0;
    
    int cardNoLength = (int)[cardNo length];
    
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    
    for (int i = cardNoLength -1 ; i>=1;i--) {
        
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        
        int tmpVal = [tmpString intValue];
        
        if (cardNoLength % 2 ==1 ) {
            
            if((i % 2) == 0){
                
                tmpVal *= 2;
                
                if(tmpVal>=10)
                    
                    tmpVal -= 9;
                
                evensum += tmpVal;
                
            }else{
                
                oddsum += tmpVal;
                
            }
            
        }else{
            
            if((i % 2) == 1){
                
                tmpVal *= 2;
                
                if(tmpVal>=10)
                    
                    tmpVal -= 9;
                
                evensum += tmpVal;
                
            }else{
                
                oddsum += tmpVal;
                
            }
            
        }
        
    }
    
    allsum = oddsum + evensum;
    
    allsum += lastNum;
    
    if((allsum % 10) == 0)
        
        return YES;
    
    else
        
        return NO;
}

+(BOOL)getButtonEnableByCurrentTF:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string tfArr:(NSArray *)tfArr{
    if (string.length) {
        // 文本增加
        NSMutableArray *newTFs = [NSMutableArray arrayWithArray:tfArr];
        [newTFs removeObject:textField];
        for (UITextField *tempTF in newTFs) {
            if (tempTF.text.length==0)
                return NO;
        }
    }else{
        // 文本删除
        if (textField.text.length-range.length==0) {
            // 当前TF文本被删完
            return NO;
        }else{
            NSMutableArray *newTFs = [NSMutableArray arrayWithArray:tfArr];
            [newTFs removeObject:textField];
            for (UITextField *tempTF in newTFs) {
                if (tempTF.text.length==0) return NO;
            }
        }
    }
    return YES;
    
}

//根据卡号判断银行
+(NSString *)returnBankName:(NSString *)cardName {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"bank" ofType:@"plist"];
    NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *bankBin = resultDic.allKeys;
    if (cardName.length < 6) {
        return @"";
    }
    NSString *cardbin_6 ;
    if (cardName.length >= 6) {
        cardbin_6 = [cardName substringWithRange:NSMakeRange(0, 6)];
    }
    NSString *cardbin_8 = nil;
    if (cardName.length >= 8) {
        //8位
        cardbin_8 = [cardName substringWithRange:NSMakeRange(0, 8)];
    }
    if ([bankBin containsObject:cardbin_6]) {
        return [resultDic objectForKey:cardbin_6];
    } else if ([bankBin containsObject:cardbin_8]){
        return [resultDic objectForKey:cardbin_8];
    } else {
        return @"";
    }
    return @"";
}

/**
 * 是否是我们支持的银行
 */
+(BOOL)isSupportBank:(NSString *)bankName {
    if ([bankName isEqualToString:@"北京银行"] || [bankName isEqualToString:@"工商银行"] ||
        [bankName isEqualToString:@"光大银行"] || [bankName isEqualToString:@"华夏银行"] ||
        [bankName isEqualToString:@"华夏银行"] || [bankName isEqualToString:@"建设银行"] ||
        [bankName isEqualToString:@"交通银行"] || [bankName isEqualToString:@"民生银行"] ||
        [bankName isEqualToString:@"农业银行"] || [bankName isEqualToString:@"浦发银行"] ||
        [bankName isEqualToString:@"上海银行"] || [bankName isEqualToString:@"兴业银行"] ||
        [bankName isEqualToString:@"邮政储蓄银行"] || [bankName isEqualToString:@"招商银行"] ||
        [bankName isEqualToString:@"中国银行"] || [bankName isEqualToString:@"中信银行"] ) {
        return YES;
    }
    return NO;
}

/**
 *  返回当前时间
 *
 *  @return 返回当前时间
 */
+(NSString *)getTimeNow {
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    NSLog(@"%@", timeNow);
    return timeNow;
}

// 为了每次都读取最新的启动图，所以要在有缓存的时候清除缓，
+(void)removeLaunchScreenCacheIfNeeded {
   NSString *filePath = [NSString stringWithFormat:@"%@/Library/SplashBoard", NSHomeDirectory()];
   
   if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (error) {
         NSLog(@"清除LaunchScreen缓存失败");
       } else {
         NSLog(@"清除LaunchScreen缓存成功");
       }
    }
}

+ (BOOL)checkUrlWithString:(NSString *)url {
//    if(url.length < 1)
//        return NO;
//    if (url.length>4 && [[url substringToIndex:4] isEqualToString:@"www."]) {
//        url = [NSString stringWithFormat:@"http://%@",url];
//    } else {
//        url = url;
//    }
//    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
//
//    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
//    return [urlTest evaluateWithObject:url];
    
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}

+ (NSString *)transformPinYinWithString:(NSString *)chinese
{
     NSString  *pinYinStr = [NSString string];
    if (chinese.length){
        NSMutableString *pinYin = [[NSMutableString alloc]initWithString:chinese];
        //1.先转换为带声调的拼音
        if(CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"带声调的pinyin: %@", pinYin);
        }
        //2.再转换为不带声调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"不带声调的pinyin: %@", pinYin);
        }
        //3.去除掉首尾的空白字符和换行字符
        pinYinStr = [pinYin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //4.去除掉其它位置的空白字符和换行字符
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"去掉空白字符和换行字符的pinyin: %@", pinYinStr);
        [pinYinStr capitalizedString];
    }
    return pinYinStr;
}

//获取输入框，字符串空格分隔后的数组；
+ (NSArray <NSString *>*)getKeywordsWithPageStr:(NSString *)pageStr {
    //初始化一个mutable集合用作接受每一个关键词
    NSMutableArray <NSString *>*arrM = NSMutableArray.array;
    //判断字符串内是否含有空格符
    if ([pageStr containsString:@" "]) {
        //初始化一个可变字符串用于拼接单个字符
        NSMutableString *cm = NSMutableString.string;
        //遍历字符串内每一个字符
        for (NSInteger i = 0; i < pageStr.length; i++) {
            //当前字符
            NSString *c = [pageStr substringWithRange:NSMakeRange(i, 1)];
            //如果不是空格
            if (![c isEqualToString:@" "]) {
                //则拼接起来
                [cm appendString:c];
            } else {
                //如果下一个是空格并且可变字符串有值，添加元素
                if (![cm containsString:@" "] && cm.length) [arrM addObject:cm];
                //重新初始化可变字符串
                cm = NSMutableString.string;
            }
        }
        //遍历结束，可变字符串可能还包含分割的最后一段关键词，执行同样操作
        if (![cm containsString:@" "] && cm.length) [arrM addObject:cm];
    } else {
        //字符串不包含空格符，直接返回包含一个自身为元素的字符串数组
        arrM = [NSMutableArray arrayWithArray:@[pageStr]];
    }
    //return
    return arrM.copy;
}

//随机数
+ (NSString*)getTransactionID
{
    NSDate* date = [NSDate date];
    NSMutableString* strDate = [NSMutableString stringWithFormat:@"%@", date];
    NSString *s1=[strDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *s2= [s1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *s3= [s2 stringByReplacingOccurrencesOfString:@":" withString:@""];
    int n = (arc4random() % 9000) + 1000;
    NSMutableString* transactionID = [NSMutableString stringWithString:[s3 substringToIndex:14]];
    [transactionID appendString:[NSString stringWithFormat:@"%d", n]];
    [transactionID stringByReplacingOccurrencesOfString:@" " withString:@""];
    return transactionID;
}

@end
