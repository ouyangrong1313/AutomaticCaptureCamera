//
//  TTPhotoMaskView.m
//  蒙板
//
//  Created by 雷祥 on 15/6/16.
//  Copyright (c) 2015年 聚光. All rights reserved.
//

#import "TTPhotoMaskView.h"

#define kWidthGap 50
#define kHeightGap 50

@implementation TTPhotoMaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setPickingFieldRect:(CGRect)pickingFieldRect{
    _pickingFieldRect = pickingFieldRect;
    [self layoutIfNeeded];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.35);
    CGContextSetLineWidth(contextRef, 3);
    //创建圆形框UIBezierPath:
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithOvalInRect:self.pickingFieldRect];
    //创建外围大方框UIBezierPath:
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    //将圆形框path添加到大方框path上去，以便下面用奇偶填充法则进行区域填充：
    [bezierPathRect appendPath:pickingFieldPath];
    //填充使用奇偶法则
    bezierPathRect.usesEvenOddFillRule = YES;
    [bezierPathRect fill];
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetRGBStrokeColor(contextRef, 255, 255, 255, 1);
    [pickingFieldPath stroke];
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
}


@end
