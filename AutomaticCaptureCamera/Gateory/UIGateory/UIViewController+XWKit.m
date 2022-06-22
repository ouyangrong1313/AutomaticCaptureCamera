//
//  UIViewController+XWKit.m
//  CELSP
//
//  Created by wzl on 16/8/8.
//  Copyright © 2016年 hq88. All rights reserved.
//

#import "UIViewController+XWKit.h"

@implementation UIViewController (XWKit)
-(UINavigationController *)xw_getNavigationController{
    if (self.navigationController) {
        return self.navigationController;
    }
    
    for (UIView *next = [self.view superview]; next; next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return [((UIViewController *)nextResponder) navigationController];
        }
        
    }
    
    return nil;
}
@end
