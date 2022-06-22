//
//  SSCustomNarBarButton.m
//  私塾家
//  Created by liew on 2018/2/15.
//  Copyright © 2018年 Liew. All rights reserved.

#import "SSCustomNarBarButton.h"
#import "NSString+SSExtame.h"

@implementation SSCustomNarBarButton {
    CGFloat widths ;
}


+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    SSCustomNarBarButton *button = [super buttonWithType:buttonType];
    button.imageWidth = 15;
    button.imageHeight = 15;
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        widths = 0 ;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state] ;
    CGSize size = [title calculateheight:self.titleLabel.font andcontSize:CGSizeMake(200, self.frame.size.height)] ;
    widths = size.width ;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(_imageWidth + 5, 0,contentRect.size.width, contentRect.size.height);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    CGFloat imageY = (contentRect.size.height - _imageHeight ) /2.0;
    
    return CGRectMake( 5 , imageY, _imageWidth, _imageHeight);
}

- (void)setHighlighted:(BOOL)highlighted {};


@end
