//  SSPublicHeader.h
//  小蚁学堂
//  Created by liew on 2018/2/6.
//  Copyright © 2018年 Liew. All rights reserved.

#ifndef SSPublicHeader_h
#define SSPublicHeader_h
#define kFullScreenWidth    ([UIScreen mainScreen].bounds.size.width)  // 全屏的高度
#define kFullScreenHeight   ([UIScreen mainScreen].bounds.size.height) // 全屏的高度

#define kNavigationBarHeight        44.00f           // 导航栏的高度
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define is_iPhoneXSerious @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0

#define Is_Iphone_X (Is_Iphone && kFullScreenHeight >= 812.0)

#define kMiddleViewHeight kFullScreenWidth/0.75

#define kTopViewHeight (kFullScreenHeight - kMiddleViewHeight-40)/2

#define kBottomViewHeight kFullScreenHeight-kMiddleViewHeight-kTopViewHeight

#define kStatusBarHeight ((Is_Iphone_X ? 44.f : 20.f))

#define kStatusBarAndNavigationBarHeight ((Is_Iphone_X) ? 88 : 64)

#define kTabbarHeight ((Is_Iphone_X) ? 83 : 49)

#define BottomHeight ((Is_Iphone_X) ? 34 : 0)

#define kExceptStatusBarHeight  (kFullScreenHeight -kStatusBarHeight)  // 除了状态栏的高度

#define kNormalProportion 0.76
#define kiPhoneNormalProportion 0.92
#define kNormalCorneradius 15

/**
 *  定义弱引用
 *
 *  @param weakSelf
 *
 *  @return
 */
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define STRONGSELF(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;
// 是否支持手势右滑返回
#define PopGestureRecognizerenabled(ret)   (self.navigationController.interactivePopGestureRecognizer.enabled = ret)

/**
 *  自定义打印，在debug时打印，发布时不打印
 */
#ifdef DEBUG
#define SSLog(fmt, ...) NSLog((@"[函数名:%s] " " [行号:%d] " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define SSLog(fmt, ...)
#endif

/** 判断版本号 */
#define iOS7UP  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS8UP  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS9UP  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS10UP ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOS11UP ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
#define iOS13UP ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13.0)

#define kDefaultAlertTime 2.0
#define kRequestOutTime 10

/**
 *  获取 appdelegate
 */
#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define UIAPPLICATION [UIApplication sharedApplication]

// 屏幕的倍数
#define kAppScale      ([UIScreen mainScreen].scale > 0 ? [UIScreen mainScreen].scale : 1)

#define StringGetLength(string)     ([SSUtility stringToGetLength:string])  // 获取字符串的长度

#define ArrayGetValueIsClass(array,index,name) ([SSUtility arrayToGetValue:array indexInt:index isClass:name]) // 从数组获取对象  并且对象是否属于某个对象

#define kDocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define kMaxShareLength 10485760

#define KIPHONE_6Scale kFullScreenWidth/375.0

#ifdef DEBUG
#define checkURL @"https://sandbox.itunes.apple.com/verifyReceipt"
#define kSandbox @"0"
#else
#define checkURL @"https://buy.itunes.apple.com/verifyReceipt"
#define kSandbox @"1"
#endif

#endif /* SSPublicHeader_h */
