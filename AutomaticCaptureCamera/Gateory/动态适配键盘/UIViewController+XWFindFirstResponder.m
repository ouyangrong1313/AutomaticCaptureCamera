//
//  UIViewController+XWFindFirstResponder.m
//  CELSP
//
//  Created by wzl on 16/1/8.
//  Copyright © 2016年 hq88. All rights reserved.
//

#import "UIViewController+XWFindFirstResponder.h"

@implementation UIViewController (XWFindFirstResponder)

- (id)xw_findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    id firstResponder = [self.view xw_findFirstResponder];
    if (firstResponder != nil) {
        return firstResponder;
    }
    
    for (UIViewController *childViewController in self.childViewControllers) {
        firstResponder = [childViewController xw_findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}
@end
