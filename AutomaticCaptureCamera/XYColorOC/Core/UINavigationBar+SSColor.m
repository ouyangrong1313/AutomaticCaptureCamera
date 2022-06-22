//
//  UINavigationBar+SSColor.m
//  SharingSchoolMobile-B
//
//  Created by 欧阳荣 on 2020/3/25.
//  Copyright © 2020 私塾家. All rights reserved.
//

#import "UINavigationBar+SSColor.h"
#import "_XYColor_PrivateView.h"

@implementation UINavigationBar (SSColor)


- (void)xy_setNavBarBackgroundColor:(UIColor *)color {

    if (@available(iOS 13.0, *)) {
        if (self.pv == nil) { self.pv = [_XYColor_PrivateView new]; }
        __weak UINavigationBar *weakBar = self;
        [self.pv traitCollectionChange:^{
            [self setBackgroundImage:[UIImage createImageWithColor:[color resolvedColorWithTraitCollection:weakBar.traitCollection]] forBarMetrics:UIBarMetricsDefault];
        }];
        [self setBackgroundImage:[UIImage createImageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self setBackgroundImage:[UIImage createImageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    }
    
}

@end
