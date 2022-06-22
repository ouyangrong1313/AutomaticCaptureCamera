//  UIButton+CCExtension.m
//  Created by 刘辉 on 2018/2/6.
//  Copyright © 2018年 私塾家. All rights reserved.


#import "UIButton+SSExtension.h"
#import <objc/runtime.h>
#import "_XYColor_PrivateView.h"

static const void *UIButtonBlockKey = &UIButtonBlockKey;

static char topNameKey;

static char rightNameKey;

static char bottomNameKey;

static char leftNameKey;

@implementation UIButton (SSExtension)

#pragma mark - ============ 给按钮点击事件 ============

-(void)addTouchUpInsideHandler:(TouchedBlock)handler
{
    objc_setAssociatedObject(self, UIButtonBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(cc_touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)cc_touchUpInsideAction:(UIButton *)btn{
    TouchedBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block(btn);
    }
}

#pragma mark - ============ 给按钮设置状态颜色 ============

/**
 *  设置按钮背景颜色
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

- (void)setLayerBorderColor:(UIColor *)borderColor forState:(UIControlState)state
{
    
    [self.layer setBorderColor:borderColor.CGColor];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - ============ 设置按钮的属性文字 ============

/**
 *  设置属性文字
 *
 *  @param textArr   需要显示的文字数组,如果有换行请在文字中添加 "\n"换行符
 *  @param fontArr   字体数组, 如果fontArr与textArr个数不相同则获取字体数组中最后一个字体
 *  @param colorArr  颜色数组, 如果colorArr与textArr个数不相同则获取字体数组中最后一个颜色
 *  @param spacing   换行的行间距
 *  @param alignment 换行的文字对齐方式
 */
- (void)setAttriStrWithTextArray:(NSArray *)textArr fontArr:(NSArray *)fontArr colorArr:(NSArray *)colorArr lineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment
{
    if (textArr.count >0 && fontArr.count >0 && colorArr.count > 0) {
        
        NSMutableString *allString = [NSMutableString string];
        for (NSString *tempText in textArr) {
            [allString appendFormat:@"%@",tempText];
        }
        
        NSRange lastTextRange = NSMakeRange(0, 0);
        NSMutableArray *rangeArr = [NSMutableArray array];
        
        for (NSString *tempText in textArr) {
            NSRange range = [allString rangeOfString:tempText];
            //如果存在相同字符,则换一种查找的方法
            if ([allString componentsSeparatedByString:tempText].count>2) { //存在多个相同字符
                range = NSMakeRange(lastTextRange.location+lastTextRange.length, tempText.length);
            }
            [rangeArr addObject:NSStringFromRange(range)];
            lastTextRange = range;
        }
        
        //设置属性文字
        NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:allString];
        for (int i=0; i<textArr.count; i++) {
            NSRange range = NSRangeFromString(rangeArr[i]);
            
            UIFont *font = (i > fontArr.count-1) ? [fontArr lastObject] : fontArr[i];
            [textAttr addAttribute:NSFontAttributeName value:font range:range];
            
            UIColor *color = (i > colorArr.count-1) ? [colorArr lastObject] : colorArr[i];
            [textAttr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        
        //如果需要换行
        if ([allString rangeOfString:@"\n"].location != NSNotFound) {
            self.titleLabel.numberOfLines = 0;
        }
        
        [self setAttributedTitle:textAttr forState:0];
        
        //段落 <如果有换行 或者 字体宽度超过一行就设置行间距>
        if (self.width > kFullScreenWidth || [allString rangeOfString:@"\n"].location != NSNotFound) {
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = spacing;
            paragraphStyle.alignment = alignment;
            self.titleLabel.numberOfLines = 0;
            [textAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,allString.length)];
            [self setAttributedTitle:textAttr forState:0];
        }
        
    } else {
        [self setTitle:@"文字,颜色,字体 每个数组至少有一个" forState:0];
    }
}

/**
 *  初始化一个按钮 没有边框的 背景颜色是蓝色的  椭圆
 */
+ (UIButton *)buttonTitle:(NSString *)title target:(id)target action:(SEL)action
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromHex(0x666666) forState:UIControlStateNormal];
        // button.titleLabel.font = FONTDEFAULT(14);
    CGFloat width = [title calculateheight:button.titleLabel.font ].width + 8;
    button.frame = CGRectMake(0, 0, width + 16, 30);
    if (title.length == 0 ) {
        button.backgroundColor = [UIColor clearColor];
    }else{
        // button.backgroundColor = UIColorFromHex(COLOR_8CC63F);
    }
    button.layer.cornerRadius = button.height / 2 ;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/**
 *  创建一个button 按钮size为 25*25 实际图片大小为17.5*17.5 UI要求
 *
 */
+ (UIButton *)buttonMustItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, CGSizeMake(40,40)};// 图片
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,-20,0,0)];
    [button setEnlargeEdgeWithTop:0 right:50 bottom:0 left:50];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)layoutButtonWithEdgeInsetsStyle:(SSButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
        if (labelWidth == 0 || labelHeight == 0) {
            labelWidth = self.titleLabel.intrinsicContentSize.width;
            labelHeight = self.titleLabel.intrinsicContentSize.height;
        }
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case SSButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case SSButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case SSButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case SSButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0); //文字往左边移；
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0); //图片往右移；
        }
            break;
        default:
            break;
    }

    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
//    NSLog(@" === layoutButtonWithEdgeInsetsStyle === self.titleLabel - %@ - imageWith: %f - imageHeight: %f - labelWidth: %f - labelHeight: %f", self.titleLabel.text, imageWith, imageHeight, labelWidth, labelHeight);
//    NSLog(@" --- imageEdgeInsets: %@ --- labelEdgeInsets: %@",NSStringFromUIEdgeInsets(imageEdgeInsets),NSStringFromUIEdgeInsets(labelEdgeInsets));
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

- (void)xy_setLayerBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    if (@available(iOS 13.0, *)) {
        if (self.pv == nil) { self.pv = [_XYColor_PrivateView new]; }
        __weak UIButton *weakView = self;
        [self.pv traitCollectionChange:^{
            [weakView setBackgroundColor:[color resolvedColorWithTraitCollection:weakView.traitCollection] forState:state];
            //weakView.layer.backgroundColor = [color resolvedColorWithTraitCollection:weakView.traitCollection].CGColor;
        }];
        [self setBackgroundColor:[color resolvedColorWithTraitCollection:self.traitCollection] forState:state];
    } else {
        [self setBackgroundColor:color forState:state];
    }
}

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}


@end
