//
//  UIViewController+Controller.h
//  Created by 刘辉 on 2018/2/6.
//  Copyright © 2018年 私塾家. All rights reserved.

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kNeedToLoginNotifiction ;      /**< 需要去登录的通知*/

@interface UIViewController (Controller)

/**
 *  显示控制器
 *
 *  @param vc        要显示的子类控制器
 *  @param animation 是否有动画
 *  @param complete  完成后的回调
 */
- (void)customPresentViewController:(UIViewController *)vc animated:(BOOL)animation completion:(void(^)(void))complete;

/**
 *  隐藏控制器
 *
 *  @param animation 是否有动画
 *  @param complete  完成后的回调
 */
- (void)customDismissFromSuperViewControllerAnimated:(BOOL)animation completion:(void(^)(void))complete;
/**
 *  是否需要弹出登录框  alert 是否弹出 logined 是否登录的状态 completeBlock 点击位置的处理 返回bool 是否需要继续下一步呢  Yes 需要下一步  No 不需要执行下一步
 */
- (BOOL)needToLoginWithAlert:(BOOL)alert logined:(BOOL)logined complete:(BOOL(^)(NSString *title))completeBlock;



/**
 *  根据指定的storyboard文件，创建指定的storyboardID的控制器
 *
 *  @param storyboardID 控制器在storyboard中的storyboardID
 *  @param storyboardName storyboard文件名
 *
 *  @return  UIViewController
 */
+ (UIViewController *)getViewControllerWithStoryboardID:(NSString *)storyboardID inStoryboard:(NSString *)storyboardName;

/**
 *  获取 当前的控制器 或addChildViewController 的parentViewController 主要处理viewController的navigationItem
 */
+ (UIViewController *)obtainViewController:(UIViewController *)viewController;
/**
 *   判断当前控制器是否显示
 */
+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;
/**
 *  获取最顶层的控制器
 */
+ (UIViewController *)obtainCurrentViewController;

/**
 *  判断在导航栏控制器中有没存在该类  取最顶层的控制器
 *
 *  @param className 类名
 *
 *  @return 返回存在的控制器  没有存在则为nil
 */
- (UIViewController *)isExistClassInNav:(NSString *)className;
/**
 *  判断在导航栏控制器中有没存在该类
 *
 *  @param className 类名
 *  @param viewController 控制器
 *  @return 返回存在的控制器  没有存在则为nil
 */
+ (UIViewController *)isExistClassInNav:(NSString *)className viewController:(UIViewController *)viewController;

/**
 *   判断在导航栏控制器中有没存在该类 并且跳转 取最顶层的控制器
 *
 *  @param className 类名
 *
 *  @return 返回存在的控制器  没有存在则为nil
 */
- (UIViewController *)isExistClassInNavAndPop:(NSString *)className;
/**
 *   判断在导航栏控制器中有没存在该类 并且跳转
 *
 *  @param className 类名
 *  @param viewController 控制器
 *  @return 返回存在的控制器  没有存在则为nil
 */
+ (UIViewController *)isExistClassInNavAndPop:(NSString *)className viewController:(UIViewController *)viewController;
/**
 * 类之中的跳转 selector  跳转的方法 objc 该类需要的参数 有两个的参数  第一个参数为当前控制器  第二个参数为改需要的参数
 */
- (void)pushClassVC:(Class)pushClass selector:(SEL)selector withObjc:(id)objc;
/**
 * 调用类的方法 并且返回值  performClass 调用的类的class  selector 调用的方法 objc 参数
 */
- (id)performClassMenthodInClass:(Class)performClass selectore:(SEL)selector withObjc:(id)objc;


@end
