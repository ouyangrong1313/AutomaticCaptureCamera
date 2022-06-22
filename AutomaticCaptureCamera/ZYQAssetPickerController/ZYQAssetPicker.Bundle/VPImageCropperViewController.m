//
//  VPImageCropperViewController.m
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import "VPImageCropperViewController.h"
#import "TTPhotoMaskView.h"

#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f

@interface VPImageCropperViewController (){
    CGFloat _imageRatio; //图片的高宽比
    CGFloat _screenRatio; //屏幕的高宽比
}

@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *editedImage;

@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) TTPhotoMaskView *overlayView;      //蒙层
@property (nonatomic, retain) UIView *ratioView;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGRect minFrame;  //最小的frame
@property (nonatomic, assign) CGFloat limitRatio;

@property (nonatomic, assign) CGRect latestFrame;


@end

@implementation VPImageCropperViewController

- (void)dealloc {
    self.originalImage = nil;
    self.showImgView = nil;
    self.editedImage = nil;
    self.overlayView = nil;
    self.ratioView = nil;
}

/**
 *  1，初始化方法，传入参数
 *
 *  @param originalImage 原始图片
 *  @param cropFrame     圆形框的frame
 *  @param limitRatio    放大的比例
 *
 *  @return
 */
- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio {
    self = [super init];
    if (self) {
        self.cropFrame = cropFrame;
        self.limitRatio = limitRatio;
        self.originalImage = originalImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self initView];
    [self initControlBtn];
}

//是否跟随屏幕旋转
-(BOOL)shouldAutorotate{
    return NO;
}

//支持旋转的方向有哪些
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (void)initView {
    self.showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.showImgView setMultipleTouchEnabled:YES];
    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setImage:self.originalImage];
    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setMultipleTouchEnabled:YES];
    
    // scale to fit the screen
    CGFloat oriWidth = self.cropFrame.size.width;
    CGFloat oriHeight = self.originalImage.size.height * (oriWidth / self.originalImage.size.width);
    CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
    self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    self.latestFrame = self.oldFrame;



    CGFloat imageWidthMax = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageHeightMax = [UIScreen mainScreen].bounds.size.height - (NaviHeight);
    CGFloat imageWidth = imageWidthMax;
    CGFloat imageHeight = imageHeightMax;
    _imageRatio = (self.originalImage.size.height / self.originalImage.size.width); //高宽比
    _screenRatio = ([UIScreen mainScreen].bounds.size.height - (NaviHeight)) / [UIScreen mainScreen].bounds.size.width; //屏幕高宽比
    CGRect imageViewFrame = CGRectZero;
    if (_imageRatio > _screenRatio) { //如果图片高宽比更大,以图片高度登录屏幕高度－64
        imageHeight = imageHeightMax;
        imageWidth = imageHeightMax / _imageRatio;
        if (imageWidth < self.cropFrame.size.width) { //当高宽比过大时，宽度小于的剪切圆形的直径，图片宽度就等于剪切圆形直径
            imageWidth = self.cropFrame.size.width;
            imageHeight = imageWidth * _imageRatio;
        }
        imageViewFrame = CGRectMake((imageWidthMax - imageWidth) / 2, 0, imageWidth, imageHeight);
    }
    else{
        imageHeight = imageWidth * _imageRatio;
        if (imageHeight < self.cropFrame.size.height) { //高宽比过小，屏幕宽度为图片宽度时，图片
            imageHeight = self.cropFrame.size.height;
            imageWidth = imageHeight / _imageRatio;
        }
        imageViewFrame = CGRectMake(0,self.cropFrame.origin.y - (imageHeight - self.cropFrame.size.height) / 2, imageWidth, imageHeight);
    }

    self.oldFrame = imageViewFrame;
    self.latestFrame = imageViewFrame;



    self.showImgView.frame = self.oldFrame;
    self.showImgView.backgroundColor = [UIColor clearColor];
    
    self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);
    
    [self addGestureRecognizers];
    [self.view addSubview:self.showImgView];
    
    self.overlayView = [[TTPhotoMaskView alloc] initWithFrame:self.view.bounds];
    self.overlayView.backgroundColor = [UIColor clearColor];
    self.overlayView.pickingFieldRect = self.cropFrame;
//    self.overlayView.alpha = 0.5f;
//    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.userInteractionEnabled = NO;
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.overlayView];

    self.ratioView = [[UIView alloc] initWithFrame:self.cropFrame];
    self.ratioView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ratioView.layer.borderWidth = 1.0f;
    self.ratioView.layer.cornerRadius = self.cropFrame.size.width / 2;
    self.ratioView.layer.masksToBounds = YES;
    self.ratioView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.ratioView];

}

- (void)initControlBtn {
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50.0f, 100, 50)];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cancelBtn.titleLabel setNumberOfLines:0];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, self.view.frame.size.height - 50.0f, 100, 50)];
    confirmBtn.backgroundColor = [UIColor clearColor];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn setTitle:@"使用" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [confirmBtn.titleLabel setNumberOfLines:0];
    [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (void)cancel:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropperDidCancel:self];
    }
}

- (void)confirm:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropper:self didFinished:[self getSubImage]];
    }
}


// register all gestures
- (void) addGestureRecognizers
{
    // add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    // add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showImgView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;

    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];

        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showImgView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.cropFrame.size.width) {
        newFrame = CGRectMake(self.cropFrame.origin.x, newFrame.origin.y, self.cropFrame.size.width, self.cropFrame.size.width * _imageRatio );
    }

    if (newFrame.size.height < self.cropFrame.size.height) {
        newFrame = CGRectMake(newFrame.origin.x, self.cropFrame.origin.y, self.cropFrame.size.width / _imageRatio, self.cropFrame.size.height);
    }

    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (newFrame.origin.x > self.cropFrame.origin.x){
        newFrame.origin.x = self.cropFrame.origin.x;
    }
    if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width + self.cropFrame.origin.x) {
        newFrame.origin.x = self.cropFrame.size.width + self.cropFrame.origin.x - newFrame.size.width;
    }
    // vertically
    if (newFrame.origin.y > self.cropFrame.origin.y) {
        newFrame.origin.y = self.cropFrame.origin.y;
    }
    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

-(UIImage *)getSubImage{
    CGRect squareFrame = self.cropFrame;
    CGFloat scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.width / scaleRatio;
    if (self.latestFrame.size.width < self.cropFrame.size.width) {
        CGFloat newW = self.originalImage.size.width;
        CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (self.latestFrame.size.height < self.cropFrame.size.height) {
        CGFloat newH = self.originalImage.size.height;
        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CFRelease(subImageRef);
    return smallImage;
}
 
@end
