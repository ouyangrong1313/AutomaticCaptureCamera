//
//  UIViewController+XWKeyboardHeightAdaptive.h
//  SocialContact
//  键盘高度监控
//  Created by wzl on 15/10/14.
//  Copyright © 2015年 wzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+XWFindFirstResponder.h"

@interface UIViewController (XWKeyboardHeightAdaptive)
/**
 *  启动键盘监控
 */
- (void)xw_startObservingKeyboardNotifications;

/**
 *  停止键盘监控
 */
- (void)xw_stopObservingKeyboardNotifications;

/**
 *  基于窗口比较视图y坐标和键盘y坐标差值
 *
 *  @param view 需要比较的视图
 *
 *  @return 差值（<0 代表视图被遮挡）
 */
- (CGFloat)xw_compareWithKeyboardOriginRectToView:(UIView*)view;

/**
 *  键盘高度值发生变化（可复写此方法）
 *
 *  @param heightValue 键盘高度值
 */
- (void)xw_keyboardHeightValueChanged:(CGFloat) heightValue;

/**
 *  键盘高度值发生变化（可复写此方法）
 *
 *  @param kbdHeightValue 键盘高度值
 *  @param ccHeightValue  键盘遮住控件的高度(<=0 未被遮挡)
 */
- (void)xw_keyboardHeightValueChanged:(CGFloat) kbdHeightValue CoverControlHeight:(CGFloat) ccHeightValue;

@end
