//
//  SSUtility.h
///  私塾家
//
//  Created by liew on 2018/2/11.
//  Copyright © 2018年 Liew. All rights reserved.

/**
 *  主要处理公共的方法
 */
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

typedef enum {
    PriceCompareResultLess = -1,    //前面的更小
    PriceCompareResultEqual = 0,    //两者相等
    PriceCompareResultGreater = 1   //前者更大
}PriceCompareResult;    //价格比较的结果

@interface SSUtility : NSObject

// 为了每次都读取最新的启动图，所以要在有缓存的时候清除缓，
+(void)removeLaunchScreenCacheIfNeeded;


/**
 *  判断该路径下是否有文件
 *
 *  @param path 路径
 *
 *  @return 返回布尔值
 */
+(BOOL)isExistFileForPath:(NSString *)path;

+(CGFloat)transformedValue:(id)value;

/**
 *  得到系统的缓存路径
 *
 *  @return 缓存路径
 */
+ (NSString *)cachePath;
/**
 *  得到根目录
 *
 *  @return NSString
 */
+ (NSString *)documentPath;
/**
 *  自定义的缓存目录
 *
 *  @return 缓存目录
 */
+ (NSString *)getCachePath;   //获取缓存文件夹中清除缓存时要删除的文件夹路径（是文件夹哦，亲）
/**
 * 删除缓存文件夹中的文件
 */
+ (void)deleteFilesInCacheDirectory;    //删除缓存文件夹中的文件

/**
 *  获取启动图路径
 *
 *  @return NSString
 */
+(NSString *)getLaunchImagePath;

/**
 *  删除启动图文件夹
 *
 *  @return  BOOL
 */
+(BOOL)deleteLaunchImageDirectoryPath;
 
/**
 *  获取旧的数据库路径
 *
 *  @return  NSString
 */
+(NSString *)getDataBaseOldPath;

/**
 *  创建document文件夹下的不删除的base文件夹
 *
 *  @return   NSString
 */
+(NSString *)getDocumentBaseDirectory;

/**
 *  获取录音的文件夹
 *
 *  @return NSString
 */
+(NSString *)getRecordDirectory;

/**
 *  清除文件夹下所有的文件及文件夹
 *
 *  @param directory 所要删除的文件夹目录
 */
+(void)deleteFilesInDirectory:(NSString *)directory;

/**
 *  创建文件夹
 *
 *  @param rootPath      路径，必须是文件夹路径
 *  @param directoryName 路径下面的文件夹名字
 *
 *  @return 返回整个文件夹的路径
 */
+(NSString *)creatDirectoryRootPath:(NSString *)rootPath andDirectoryName:(NSString *)directoryName;

/**
 *  删除文件或文件夹
 *
 *  @param filePath 需要删除的路径
 *
 *  @return BOOL
 */
+(BOOL)deleteFile:(NSString *)filePath;
/**
 *  防止上传到icloud
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL bundleIdentifier:(NSString *)bundleIdentifier;
/**
 * 网络请求 返回是Dictionary  对象
 *
 *  @param response  response
 *
 *  @return  NSDictionary
 */
+ (NSDictionary *)requestReturnTypeOfDictionary:(id)response ;

/**
 * 网络请求 返回是Array  对象
 *
 *  @param response  response
 *
 *  @return  NSArray
 */
+ (NSArray *)requestReturnTypeOfArray:(id)response ;
/**
 * 网络请求  判断返回是否为空和是否错误的
 *
 *  @param respone    respone
 *
 *  @return  BOOL
 */
+ (BOOL)requestResponseObjectIsTrue:(id)respone ;


/**
 *  是否是第一次启动（包括更新以后第一次）
 *
 *  @param save 是否需要保存（启动的时候需要传yes,其他情况用来判断传no）
 *
 */
+(BOOL)dateUped:(BOOL)save code:(NSString *)code;

/**
 *字符串(json格式)转化成字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  强制隐藏键盘方法
 */
+ (void)hideKeyboard;

/*!
 *  判断有没开启相机权限
 *
 *  @return yes 为开启中  no 没有开启
 */
+ (BOOL)isAuthorizationStatusTypeCamera:(BOOL)isAlert;

/*!
 *  判断有没开启相册权限
 *
 *  @return yes 为开启中  no 没有开启
 */
+ (BOOL)isAuthorizationStatusTypePhotoLibrary:(BOOL)isAlert;
/**
 *  获取键盘高度
 */
+ (CGFloat)getKeyboardHeight:(NSNotification *)object;
/**
 *  增加截取小数点, 只舍不入.
 *  @price 输入数, @position 截取位数
 */
+ (NSString *)notRounding:(float)price afterPoint:(int)position ;

#pragma mark - 发现当前语言并非项目支持的语言时，统一访问指定的资源文件，返回默认的资源
/**
 *  根据key 获取不同语言对应的词语
 *
 *  @param translation_key key
 *
 *  @return  NSString
 */
+ (NSString *)CCLocalizedString:(NSString *)translation_key ;
 

/**
 *  从ABRecordRef信息中获取电话号码 ;
 *
 *  @param person  person
 *
 *  @return  NSString
 */
+ (NSString *)phoneNumFormABRecordRef:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;

/**
 *  获取info.plist的字典
 *
 *  @return 返回字典
 */
+ (NSDictionary *)dictionaryFromInfoPlist;

/**
 *  获取随机的32位
 */
+ (NSString *)obtainRandom32;

/**
 *  判断是否开启系统通知
 */
+ (BOOL)isAllowedNotification;
/**
 *  链接拼接keyValue
 */
+ (NSString *)stringUrlAppendToken:(NSString *)url key:(NSString *)key value:(NSString *)value;
/**
 *  获取时间戳  毫秒
 *
 *  @return 毫秒
 */
+ (NSString *)obtainTimeInterval;

/**
 *  链接编码 不对＃进行编码
 */
+ (NSString *)concatenatedCoding:(NSString *)urlPath;
/**
 *  对特殊编码的编码
 */
+ (NSString *)concatenatedKey:(NSString *)key;

/**
 *  获取最顶层的控制器
 */
+ (UIViewController *)obtainCurrentViewController;
/**
 * 获取缓存大小
 */
+(CGFloat) getCacheSize;
/**
 * 清除缓存
 */
+(void) cleanCache;

/**
 * 获取手机机型
 */
+(NSString*)iphoneType;

/**
 * 是否是银行卡号
 */
+(BOOL)checkCardNo:(NSString*)cardNo;

/**
 * 判断
 */
+(BOOL)getButtonEnableByCurrentTF:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string tfArr:(NSArray *)tfArr;

/**
 * 根据卡号判断银行
 */
+(NSString *)returnBankName:(NSString *)cardName;

/**
 * 是否是我们支持的银行
 */
+(BOOL)isSupportBank:(NSString *)bankName;

/**
 *  返回当前时间
 *
 *  @return 返回当前时间
 */
+(NSString *)getTimeNow;

// 判断字符串是否是url
+ (BOOL)checkUrlWithString:(NSString *)url;

// 汉字转拼音去声调
+ (NSString *)transformPinYinWithString:(NSString *)chinese;

//字符串空格分割
+ (NSArray <NSString *>*)getKeywordsWithPageStr:(NSString *)pageStr;

//随机数
+ (NSString*)getTransactionID;

@end
