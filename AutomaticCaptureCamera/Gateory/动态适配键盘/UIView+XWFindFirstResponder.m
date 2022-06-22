//
//  UIView+FindFirstResponder.m
//  CELSP
//
//  Created by wzl on 16/1/8.
//  Copyright © 2016年 hq88. All rights reserved.
//

#import "UIView+XWFindFirstResponder.h"

@implementation UIView (XWFindFirstResponder)
- (UIView *)xw_findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView xw_findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}
@end
