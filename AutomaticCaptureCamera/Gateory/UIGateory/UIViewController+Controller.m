//
//  UIViewController+Controller.m
//  Created by 刘辉 on 2018/2/6.
//  Copyright © 2018年 私塾家. All rights reserved.

#import "UIViewController+Controller.h"
#import "ClassActions.h"

NSString *const kNeedToLoginNotifiction = @"needToLoginNotifiction";                   /**< 需要去登录的通知*/

@implementation UIViewController (Controller)


- (void)customPresentViewController:(UIViewController *)vc animated:(BOOL)animation completion:(void(^)(void))complete {
    if (![vc isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    if (animation) {    //有动画
        vc.view.frame = [UIScreen mainScreen].bounds;
        vc.view.y = [UIScreen mainScreen].bounds.size.height;
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];   //添加控制器到父控件
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            vc.view.y = 0;
        } completion:^(BOOL finished) {
            if (complete) {
                complete();
            }
        }];
    }
    else {  //没有动画
        vc.view.frame = [UIScreen mainScreen].bounds;
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];   //添加控制器到父控件
        if (complete) {
            complete();
        }
    }
}
/**
 *  隐藏控制器
 *
 *  @param animation 是否有动画
 *  @param complete  完成后的回调
 */
- (void)customDismissFromSuperViewControllerAnimated:(BOOL)animation completion:(void(^)(void))complete {
    if (animation) {    //有动画
        [UIView animateWithDuration:0.2 animations:^{
            self.view.y = [UIScreen mainScreen].bounds.size.height;
        } completion:^(BOOL finished) {
            if (complete) { //先执行回调，再执行移除控制器的方法，防止有些版本不能执行回调
                complete();
            }
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
    else{   //没有动画
        if (complete) {
            complete();
        }
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

/**
 *  是否需要弹出登录框  alert 是否弹出 logined 是否登录的状态 completeBlock 点击位置的处理 返回bool 是否需要继续下一步呢  Yes 需要下一步  No 不需要执行下一步
 */
- (BOOL)needToLoginWithAlert:(BOOL)alert logined:(BOOL)logined complete:(BOOL (^)(NSString *))completeBlock{
    if (!logined) {
        if (alert) {
            // 处理弹出信息
            NSString *buttonTitle = @"";
            BOOL needToNext = completeBlock ? completeBlock(buttonTitle) : YES;
            if (needToNext) {
                if ([buttonTitle isEqualToString:@"确定"]) {
                    
                   
                }
            }
              [self postLoginNotification];
        }else{
            [self postLoginNotification];
        }
        return YES;
    }
    return NO;
}
/**
 * 需要跳到登录的通知
 */
- (void)postLoginNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNeedToLoginNotifiction object:nil];
}

/**
 *  根据指定的storyboard文件，创建指定的storyboardID的控制器
 *
 *  @param storyboardID 控制器在storyboard中的storyboardID
 *  @param storyboardName storyboard文件名
 *
 *  @return
 */
+ (UIViewController *)getViewControllerWithStoryboardID:(NSString *)storyboardID inStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *VC = [storyboard instantiateViewControllerWithIdentifier:storyboardID];
    
    return VC;
}

/**
 *  获取 当前的控制器 或addChildViewController 的parentViewController 主要处理viewController的navigationItem
 */
+ (UIViewController *)obtainViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [self equalIsNarBarVC:viewController];
    }else{
        UIViewController *parentViewController = viewController.parentViewController;
        if (parentViewController && [parentViewController isKindOfClass:[UINavigationController class]]) {
            viewController = [self equalIsNarBarVC:parentViewController];
        }else if (parentViewController){
            parentViewController = parentViewController.parentViewController;
            if (parentViewController && [parentViewController isKindOfClass:[UINavigationController class]]) {
                viewController = [self equalIsNarBarVC:parentViewController];
            }else{
                viewController = parentViewController;
            }
            
        }
    }
    return viewController;
}
/**
 *  判断是否 UINavigationController
 */
+ (UIViewController *)equalIsNarBarVC:(UIViewController *)viewController{
    UIViewController *viewController1 = [(UINavigationController *)viewController topViewController];
    viewController = viewController1 ? viewController1 : viewController;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [self obtainViewController:viewController];
    }
    return viewController;
}

/**
 *   判断当前控制器是否显示
 */
+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}
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
/**
 *  判断在导航栏控制器中有没存在该类
 *
 *  @param className 类名
 *
 *  @return 返回存在的控制器  没有存在则为nil
 */
- (UIViewController *)isExistClassInNav:(NSString *)className{
    return [[self class]isExistClassInNav:className viewController:self];
}

+(BOOL)whetherIdIsClass:(id)objc className:(NSString *)name
{
    BOOL ret = NO;
    if (name.length) {
        Class myClass = NSClassFromString(name);
        if (!myClass) {
            ret = NO;
        }else{
            ret = [objc isKindOfClass:myClass] ? YES : NO;
        }
    }else{
        ret = NO;
    }
    return ret;
}

/**
 *  判断在导航栏控制器中有没存在该类
 *
 *  @param className 类名
 *  @param viewController 控制器
 *  @return 返回存在的控制器  没有存在则为nil
 */
+ (UIViewController *)isExistClassInNav:(NSString *)className viewController:(UIViewController *)viewController{
    UIViewController *vController = nil;
    for (UIViewController *tempVC in viewController.navigationController.viewControllers) {
        if ([self whetherIdIsClass:tempVC className:className]) {
            vController = tempVC;
            break;
        }
    }
    return vController;
}

/**
 *  判断在导航栏控制器中有没存在该类 并且跳转
 *
 *  @param className 类名
 *
 *  @return 返回存在的控制器  没有存在则为nil
 */
- (UIViewController *)isExistClassInNavAndPop:(NSString *)className{
    return [[self class] isExistClassInNavAndPop:className viewController:self];
}
/**
 *   判断在导航栏控制器中有没存在该类 并且跳转
 *
 *  @param className 类名
 *  @param viewController 控制器
 *  @return 返回存在的控制器  没有存在则为nil
 */
+ (UIViewController *)isExistClassInNavAndPop:(NSString *)className viewController:(UIViewController *)viewController{
    UIViewController *vController = [self isExistClassInNav:className viewController:viewController];
    if (vController) {
        [viewController.navigationController popToViewController:vController animated:YES];
    }
    return vController;
}
/**
 * 类之中的跳转 selector  跳转的方法 objc 该类需要的参数 有两个的参数  第一个参数为当前控制器  第二个参数为改需要的参数
 */
- (void)pushClassVC:(Class)pushClass selector:(SEL)selector withObjc:(id)objc{
    @try {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (isExistClassMethodInClass(pushClass, selector)) {
             [pushClass performSelector:selector withObject:self withObject:objc];
        }
#pragma clang diagnostic pop
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    
}
/**
 * 调用类的方法 并且返回值  performClass 调用的类的class  selector 调用的方法 objc 参数
 */
- (id)performClassMenthodInClass:(Class)performClass selectore:(SEL)selector withObjc:(id)objc{
    return classMethodPerformInClss(performClass, selector, objc);
}
@end
