//
//  UIPrintPageRenderer+PDF.h
//  私塾家
//
//  Created by 刘辉 on 2020/4/24.
//  Copyright © 2020 Liew. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPrintPageRenderer (PDF)

- (NSData*) printToPDF;

@end

NS_ASSUME_NONNULL_END
