//
//  UIViewController+XWKeyboardHeightAdaptive.m
//  SocialContact
//  Created by wzl on 15/10/14.
//  Copyright © 2015年 wzl. All rights reserved.

#import "UIViewController+XWKeyboardHeightAdaptive.h"
#import <objc/runtime.h>

@implementation UIViewController (XWKeyboardHeightAdaptive)
CGRect gxw_KeyboardRect ;//键盘高度
- (void)xw_startObservingKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(keyboardWillHide:)
               name:UIKeyboardWillHideNotification
             object:nil];
    
    self.view.userInteractionEnabled = YES;
}

- (void)xw_stopObservingKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
      name:UIKeyboardWillShowNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    
    for (UIGestureRecognizer*gesture in [self.view gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:gesture];
        }
    }
}

- (CGFloat)xw_compareWithKeyboardOriginRectToView:(UIView *)view{
    
    if (!view) {
        
        return  0;
    }
    
    if(gxw_KeyboardRect.size.height <= 0){
        //键盘未弹出
        return 0;
    }
    else{
        CGRect tempRect=[view convertRect: view.bounds toView:nil];
        CGFloat coverHeight = gxw_KeyboardRect.origin.y - CGRectGetMaxY(tempRect);
        
        return coverHeight;
    }
}

- (void)xw_keyboardHeightValueChanged:(CGFloat)heightValue
{
    //override me if need
}

- (void)xw_keyboardHeightValueChanged:(CGFloat)kbdHeightValue CoverControlHeight:(CGFloat)ccHeightValue{
    //override me if need
}

#pragma mark - private


- (void)keyboardWillShow:(NSNotification *)notification {
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapSelfView:)];
    [self.view addGestureRecognizer:tapGes];
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view.superview convertRect:keyboardRect fromView:nil];
    gxw_KeyboardRect = keyboardRect;

    // 键盘的动画时间，设定与其完全保持一致
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 键盘的动画是变速的，设定与其完全保持一致
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    // 开始及执行动画
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    //计算遮挡高度
    [self xw_keyboardHeightValueChanged:keyboardRect.size.height];
    UIView *textField = (UIView*)[self xw_findFirstResponder];
//    CGRect textFieldRect=[textField convertRect: textField.bounds toView:nil];
//    CGFloat coverHeight = (textFieldRect.origin.y+textFieldRect.size.height) - keyboardRect.origin.y;
    CGFloat coverHeight = -([self xw_compareWithKeyboardOriginRectToView:textField]);//注意这里是取负值
    [self xw_keyboardHeightValueChanged:keyboardRect.size.height CoverControlHeight:coverHeight];
    
    [UIView commitAnimations];
}

//键盘消失时的处理
- (void)keyboardWillHide:(NSNotification *)notification {
    
    /*
     这里暴力移除手势是不符合通用设计 可能会影响self.view 的其他UITapGestureRecognizer手势
    思路：这里判断手势的target和action，然后做对应的移除工作
    坑：UITapGestureRecognizer不能拿到target和action，需要用到UIGestureRecognizerTarget，不幸的是这个类是私有的，卧槽~~~
    解决方案：给UITapGestureRecognizer写个拓展类 加上需要的target和action属性（注意命名冲突），可以尝试一下用钩子获取手势初始化信息
    哎，有时间再去实现吧！Mark一下~~~ wzl
     */
    
    for (UIGestureRecognizer*gesture in [self.view gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:gesture];
        }
    }
    
    NSDictionary* userInfo = [notification userInfo];
    gxw_KeyboardRect = CGRectZero;
    
    // 键盘的动画时间，设定与其完全保持一致
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 键盘的动画是变速的，设定与其完全保持一致
    NSValue *animationCurveObject =[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    [self xw_keyboardHeightValueChanged:0];
    [self xw_keyboardHeightValueChanged:0 CoverControlHeight:0];
    [UIView commitAnimations];
}

- (void)singleTapSelfView:(id)sender{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
