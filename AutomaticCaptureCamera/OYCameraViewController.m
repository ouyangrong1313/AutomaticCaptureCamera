//
//  OYCameraViewController.m
//  AutomaticCaptureCamera
//
//  Created by 欧阳荣 on 2022/6/16.
//

#import "OYCameraViewController.h"
#import "ZYQAssetPickerController.h"
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <GLKit/GLKit.h>

#define kTopViewHeight (kFullScreenHeight - kMiddleViewHeight-40)/2

#define kSubjectWidth 75
#define kSubjectHeight 26
#define kSampleImageViewWidth (kFullScreenWidth-64)
#define kSampleImageViewHeight kSampleImageViewWidth/0.75

static NSString *autoPhotoTipString = @"支持横竖屏拍照\n请尽量拍摄完整页面，以提高识别率噢";
static NSString *manualPhotoTipString = @"捕获中....请保持稳定";

@interface IPDFRectangleFeature : NSObject

@property (nonatomic) CGPoint topLeft;
@property (nonatomic) CGPoint topRight;
@property (nonatomic) CGPoint bottomRight;
@property (nonatomic) CGPoint bottomLeft;

@end

@implementation IPDFRectangleFeature

@end

@interface OYCameraViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate>{
    
    UIView *_photoButotn;
    UIButton *_takePhotoButton;
    UIView   *_downView;
    UIView   *_middleView;
    UIImage * _photopImage;
    NSInteger selectedFirstTag;
    NSInteger selectedSecondTag;
    UIImageView *_focusView;
    UITapGestureRecognizer *_tapGesture;
    UIButton *_backBtn;
    UIButton *_flashBtn;
    int _photoCount;
    dispatch_queue_t _captureQueue;
    CIContext *_coreImageContext;
    //GLuint _renderBuffer;
    GLKView *_glkView; // 'GLKView' is deprecated: first deprecated in iOS 12.0 - OpenGLES API deprecated. (Define GLES_SILENCE_DEPRECATION to silence these warnings)
    BOOL _isStopped;
    
    CGFloat _imageDedectionConfidence;
    NSTimer *_borderDetectTimeKeeper;
    BOOL _borderDetectFrame;
    CIRectangleFeature *_borderDetectLastRectangleFeature;
    
    BOOL _isCapturing;
}

@property (nonatomic,strong) UILabel *topLable;

@property (nonatomic,strong) UILabel *midLable;

@property (nonatomic,strong) UIScrollView *mainScroolView;

@property (nonatomic,strong) UIView *cameraContentView;

@property (nonatomic,assign) BOOL isGoCorrect;

@property (nonatomic,strong) UIButton *btnCheckHomeworkDetail;

@property (nonatomic, assign) BOOL forceStop;

@property (nonatomic,assign,getter=isBorderDetectionEnabled) BOOL enableBorderDetection;

@property (nonatomic, assign) CGSize intrinsicContentSize;

@property (atomic) CGRect cachedBounds; // self.bounds can only be accessed on main thread

@property (nonatomic,strong) EAGLContext *context;

@property (nonatomic, assign) CGFloat scanCount;

@property (nonatomic,strong) UIImageView *tipSwitchImage;

@property (nonatomic,strong) UIView *viewb;

@end

@implementation OYCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            SSLog(@"允许了");
            dispatch_async(dispatch_get_main_queue(), ^{
                //[[self xw_getViewController].navigationController pushViewController:customCameraVC animated:YES];
            });
        }else{
            SSLog(@"拒绝了");
            dispatch_async(dispatch_get_main_queue(), ^{
//                [customCameraVC.navigationController popViewControllerAnimated:YES];
            });
        }
    }];

    _captureQueue = dispatch_queue_create("com.instapdf.AVCameraCaptureQueue", DISPATCH_QUEUE_SERIAL);

    // 1.添加滚动视图
    [self setUpSubViews];
    // 2.自定义相机
    [self makeMyCapture];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//刚开始默认是拍照的状态，用白色状态栏；
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = YES; // 隐藏导航栏；
    [self start];
    if (self.mainScroolView.contentOffset.x == kFullScreenWidth) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//刚开始默认是拍照的状态，用白色状态栏；
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//刚开始默认是拍照的状态，用白色状态栏；
    }
    //开始生成 设备旋转 通知
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //添加 设备旋转 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    //销毁 设备旋转 通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil
     ];
    //结束 设备旋转通知
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self stop];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//刚开始默认是拍照的状态，用黑色状态栏；
}

-(void)dealloc{
    SSLog(@"拍照页面释放");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (self.forceStop) return;
    if (_isStopped || _isCapturing || !CMSampleBufferIsValid(sampleBuffer)) return;
    
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *image = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    image = [self filteredImageUsingContrastFilterOnImage:image];
    if (self.isBorderDetectionEnabled) // 可以自动捕获拍照
    {
        if (_borderDetectFrame)
        {
            // CIRectangleFeature
            _borderDetectLastRectangleFeature = [self biggestRectangleInRectangles:[[self highAccuracyRectangleDetector] featuresInImage:image]];
            _borderDetectFrame = NO;
        }
        
        if (_borderDetectLastRectangleFeature)
        {
            _imageDedectionConfidence += 0.5;
            image = [self drawHighlightOverlayForPoints:image topLeft:_borderDetectLastRectangleFeature.topLeft topRight:_borderDetectLastRectangleFeature.topRight bottomLeft:_borderDetectLastRectangleFeature.bottomLeft bottomRight:_borderDetectLastRectangleFeature.bottomRight];
            //SSLog(@"%f----",_imageDedectionConfidence);
            
            if (self.isBorderDetectionEnabled && rectangleDetectionConfidenceHighEnough(_imageDedectionConfidence) ) {
                //SSLog(@"当前线程---%@",[NSThread currentThread]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_takePhotoButton.enabled = NO;
                    [self captureImageWithCompletionHander];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_takePhotoButton.enabled = YES;
                });
            }
        }else{
            _imageDedectionConfidence = 0.0f;
        }
    }
    
    if (self.context && _coreImageContext){
        if(_context != [EAGLContext currentContext]){
            [EAGLContext setCurrentContext:_context];
        }
        [_glkView bindDrawable];
        [_coreImageContext drawImage:image inRect:self.cachedBounds fromRect:[self cropRectForPreviewImage:image]];
        [_glkView display];
        if(_intrinsicContentSize.width != image.extent.size.width) {
            self.intrinsicContentSize = image.extent.size;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cameraContentView invalidateIntrinsicContentSize];
            });
        }
        image = nil;
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    if (!error) {
        NSData *data = [photo fileDataRepresentation];
        UIImage *oringImage = [UIImage imageWithData:data]; // 使用该方式获取图片，可能图片会存在旋转问题，在使用的时候调整图片即可
        // 裁剪成4:3的比例
        self->_photopImage = [self clipImageWithRectangle:oringImage];
        [self doPhoto];
        self->_takePhotoButton.enabled = YES;
    }
}

#pragma mark - NSTimer Method

- (void)enableBorderDetectFrame {
    self.scanCount += 0.5;
    if (self.isBorderDetectionEnabled && self.scanCount == 5) {
        [self showTipSwitchImage];
        //[[SSCustomAlertView alloc] setAlertViewTitle:@"" andMessage:@"拍摄遇到问题试试手动拍摄" andhideAlertViewTimeOut:kDefaultAlertTime];
    }
    SSLog(@"扫描时长 --- %f",self.scanCount);
    _borderDetectFrame = YES;
}

#pragma mark - NetWork
// 上传作业图片
- (void)uploadHomeworkPicture {
    NSLog(@" --- 上传作业图片 --- ");
    [self.viewb removeFromSuperview];
    self.isGoCorrect = NO;
    [self start];
    if (self.uploadSuccess) {
        self.uploadSuccess(_photopImage);
    }
}

#pragma mark - Event Response

-(void)flashControlAction:(UIButton*)sender{
     sender.selected = !sender.selected;
     //  获取摄像机单例对象
      AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
      //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
      if (![device hasFlash]) return;
      
      //修改前必须先锁定
      [device lockForConfiguration:nil];
      if (device.flashMode == AVCaptureFlashModeOff) {
          device.flashMode = AVCaptureFlashModeOn;
          device.torchMode = AVCaptureTorchModeOn;
      } else if (device.flashMode == AVCaptureFlashModeOn) {
          device.flashMode = AVCaptureFlashModeOff;
          device.torchMode = AVCaptureTorchModeOff;
      }
      [device unlockForConfiguration];
}

-(void)switchAuto:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.enableBorderDetection = !btn.selected;
    if (btn.selected) {
        [btn setupborderWidth:1.f borderColor:UIColorFromHex(COLOR_FFFFFF)];
        self.midLable.text  = autoPhotoTipString;
        self.midLable.font = FONTBOLD(14);
        [_borderDetectTimeKeeper invalidate];
        self.scanCount = 0;
        [self hiddenTipSwitchImage];
    }else{
        [btn setupborderWidth:1.f borderColor:[UIColor clearColor]];
        self.midLable.text = manualPhotoTipString;
        self.midLable.font = FONTBOLD(20);
        _borderDetectTimeKeeper = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(enableBorderDetectFrame) userInfo:nil repeats:YES];
    }
}

// 拍照成像
-(void)takePhoto{
    //进行拍照保存图片
    _takePhotoButton.enabled = NO; // 防止连续拍照
    
//     AVCapturePhotoSettings *photoSett = [AVCapturePhotoSettings photoSettings];
//    [self.photoOutput capturePhotoWithSettings:photoSett delegate:self];
    
    AVCaptureConnection *conntion = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) {
        NSLog(@"拍照失败!");
        return;
    }
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == nil) {
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *oringImage = [UIImage imageWithData:imageData];
        // 裁剪成4:3的比例
        self->_photopImage = [self clipImageWithRectangle:oringImage];
        [self doPhoto];
        self->_takePhotoButton.enabled = YES;
    }];

}

// 处理(取消\批注)照片
-(void)hitopbutton:(UIButton *)button {
    //[button.superview.superview removeFromSuperview];
    if (button.tag == 1000) { // 1000 上传作业
        self.topLable.hidden = YES;
        self.midLable.hidden = NO;
        self.isGoCorrect = NO;
        [self.viewb removeFromSuperview];
        [self uploadHomeworkPicture];
    }else if(button.tag == 1001){
        self.topLable.hidden = YES;
        self.midLable.hidden = NO;
        [self.viewb removeFromSuperview];
        [self start];
    } else {
        // 去批注
        [self stop];
        self.topLable.hidden = YES;
        self.midLable.hidden = YES;
        self.isGoCorrect = YES;
        [self uploadHomeworkPicture];
    }
}

-(void)backBarBtnClick{
    [self stop];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 选择相册
 */
-(void)selectAblum{
    if (![SSUtility isAuthorizationStatusTypePhotoLibrary:YES]) {
        return;
    }
    //[self stop];
    [ZYQAssetVCHelp showImagePickerController:1 viewController:self sourceType:2 delegate:self];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImageJPEGRepresentation(image,1);
    NSInteger length = [imageData length]/1000;
    NSLog(@"压缩前 --- image-kb: %ld KB,image-M: %ld MB", (long)length, length/1024);
    _photopImage = [UIImage compressImage:image toByte:100000];
    NSData *imageData1 = UIImageJPEGRepresentation(_photopImage,1);
    NSInteger length1 = [imageData1 length]/1000;
    NSLog(@"压缩后 --- image-kb: %ld KB,image-M: %ld MB", (long)length1, length1/1024);

    [picker dismissViewControllerAnimated:NO completion:^{
        if (image) {
            [self doPhoto];
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Method

- (void)start {
    _isStopped = NO;
    self.midLable.hidden = NO;
    [self.session startRunning];
    _borderDetectTimeKeeper = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(enableBorderDetectFrame) userInfo:nil repeats:YES];
    [self hideGLKView:NO completion:nil];
}

- (void)stop {
    _isStopped = YES;
    self.scanCount = 0;
    SSLog(@"扫码时长 --- %f",self.scanCount);
    [self.session stopRunning];
    [_borderDetectTimeKeeper invalidate];
    [self hideGLKView:YES completion:nil];
}

-(void)showTipSwitchImage{
    self.tipSwitchImage.hidden = NO;
    self.scanCount = 0;
    //[self performSelector:@selector(hiddenTipSwitchImage) afterDelay:5.0];
    [self performSelector:@selector(hiddenTipSwitchImage) withObject:nil afterDelay:5.0];
}

-(void)hiddenTipSwitchImage{
    if (self.tipSwitchImage.hidden == NO) {
        self.tipSwitchImage.hidden = YES;
    }
}

- (void)hideGLKView:(BOOL)hidden completion:(void(^)(void))completion {
    [UIView animateWithDuration:0.1 animations:^{
        self->_glkView.alpha = (hidden) ? 0.0 : 1.0;
    }completion:^(BOOL finished){
        if (!completion) return;
        completion();
    }];
}

-(void)addGrid:(CALayer *)previewLayerlayer {
    CGFloat widthView = previewLayerlayer.frame.size.width;
    CGFloat heightView = previewLayerlayer.frame.size.height;
    
    void (^addLineWidthRect)(CGRect rect) = ^(CGRect rect) {
        CALayer *layer = [[CALayer alloc] init];
        [previewLayerlayer addSublayer:layer];
        layer.frame = rect;
        layer.backgroundColor = [UIColorFromHexA(COLOR_FFFFFF, 1) CGColor];
    };
    
    for (int i=0; i<2; i++) {
        addLineWidthRect(CGRectMake((i+1)*widthView/3, 0, 1, heightView));
    }
    
    for (int i=0; i<3; i++) {
        addLineWidthRect(CGRectMake(0,(i+1)*heightView/4, widthView,1));
    }
    //四个角
    // 1.左上角
    addLineWidthRect(CGRectMake(2,2,33,2));
    addLineWidthRect(CGRectMake(2,2,2,33));
    
    //2.右上角
    addLineWidthRect(CGRectMake(widthView-35,2,33,2));
    addLineWidthRect(CGRectMake(widthView-4,2,2,33));
    
    //3.左下角
    addLineWidthRect(CGRectMake(2,heightView-4,33,2));
    addLineWidthRect(CGRectMake(2,heightView-35,2,33));
    
    //4.右下角
    addLineWidthRect(CGRectMake(widthView-35,heightView-4,33,2));
    addLineWidthRect(CGRectMake(widthView-4,heightView-35,2,33));
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
   CGContextAddLines(ctx, pointA, 2);
   CGContextAddLines(ctx, pointB, 2);
}

-(UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform =CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,

                                             CGImageGetBitsPerComponent(aImage.CGImage),0,

                                             CGImageGetColorSpace(aImage.CGImage),

                                             CGImageGetBitmapInfo(aImage.CGImage));

    CGContextConcatCTM(ctx, transform);
    

    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 裁剪图片
-(UIImage *)clipImageWithRectangle:(UIImage*)image{
       image = [self fixOrientation:image];
       //imageView的size可能和iamge的size不一样，而裁剪是按image的size算，这里必须换算
       CGFloat imageViewrate = kFullScreenWidth/(kMiddleViewHeight);
       CGFloat testImagerate = image.size.width/image.size.height;

       // 实际需要裁剪的frame
       CGRect frame;
       if (imageViewrate > testImagerate)/*宽度铺满  高度裁掉部分*/
       {
           CGFloat height = ((kMiddleViewHeight)/kFullScreenWidth)*image.size.width;
           frame = CGRectMake(0, (image.size.height - height)/2.f, image.size.width, height);
       }else{/*高度铺满  宽度裁掉部分*/
           CGFloat width = (kFullScreenWidth/(kMiddleViewHeight))*image.size.height;
           frame = CGRectMake((image.size.width - width)/2.f, 0, width,image.size.height);
       }
     CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,frame);
     UIImage *subImage = [UIImage imageWithCGImage:imageRef];
   
    //subImage.imageOrientation;
     CGImageRelease(imageRef);
     SSLog(@"%@", NSStringFromCGSize(subImage.size));
     return  [self fixOrientation:subImage];
}

- (CGRect)cropRectForPreviewImage:(CIImage *)image {
    CGFloat cropWidth = image.extent.size.width;
    CGFloat cropHeight = image.extent.size.height;
    if (image.extent.size.width>image.extent.size.height) {
        cropWidth = image.extent.size.width;
        cropHeight = cropWidth*self.cachedBounds.size.height/self.cachedBounds.size.width;
    }else if (image.extent.size.width<image.extent.size.height) {
        cropHeight = image.extent.size.height;
        cropWidth = cropHeight*self.cachedBounds.size.width/self.cachedBounds.size.height;
    }
    return CGRectInset(image.extent, (image.extent.size.width-cropWidth)/2, (image.extent.size.height-cropHeight)/2);
}

- (CIImage *)drawHighlightOverlayForPoints:(CIImage *)image topLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight {
    CIImage *overlay = [CIImage imageWithColor:[CIColor colorWithRed:0.29 green:0.53 blue:0.93 alpha:0.6]];
    overlay = [overlay imageByCroppingToRect:image.extent];
    overlay = [overlay imageByApplyingFilter:@"CIPerspectiveTransformWithExtent" withInputParameters:@{@"inputExtent":[CIVector vectorWithCGRect:image.extent],@"inputTopLeft":[CIVector vectorWithCGPoint:topLeft],@"inputTopRight":[CIVector vectorWithCGPoint:topRight],@"inputBottomLeft":[CIVector vectorWithCGPoint:bottomLeft],@"inputBottomRight":[CIVector vectorWithCGPoint:bottomRight]}];
    return [overlay imageByCompositingOverImage:image];
}

- (CIImage *)filteredImageUsingContrastFilterOnImage:(CIImage *)image {
    return [CIFilter filterWithName:@"CIColorControls" withInputParameters:@{@"inputContrast":@(1.1),kCIInputImageKey:image}].outputImage;
}

- (CIImage *)correctPerspectiveForImage:(CIImage *)image withFeatures:(CIRectangleFeature *)rectangleFeature {
    NSMutableDictionary *rectangleCoordinates = [NSMutableDictionary new];
    rectangleCoordinates[@"inputTopLeft"] = [CIVector vectorWithCGPoint:rectangleFeature.topLeft];
    rectangleCoordinates[@"inputTopRight"] = [CIVector vectorWithCGPoint:rectangleFeature.topRight];
    rectangleCoordinates[@"inputBottomLeft"] = [CIVector vectorWithCGPoint:rectangleFeature.bottomLeft];
    rectangleCoordinates[@"inputBottomRight"] = [CIVector vectorWithCGPoint:rectangleFeature.bottomRight];
    image = [image imageByApplyingFilter:@"CIPerspectiveCorrection" withInputParameters:rectangleCoordinates];
    return image;
}

- (void)captureImageWithCompletionHander{
    
    dispatch_suspend(_captureQueue);
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) break;
    }

    __weak typeof(self) weakSelf = self;

    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         if (error) {
             dispatch_resume(self->_captureQueue);
             return;
         }

         //__block NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"ipdf_img_%i.jpeg",(int)[NSDate date].timeIntervalSince1970]];

         @autoreleasepool
         {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             CIImage *enhancedImage = [[CIImage alloc] initWithData:imageData options:@{kCIImageColorSpace:[NSNull null]}];
             imageData = nil;

             enhancedImage = [self filteredImageUsingContrastFilterOnImage:enhancedImage];
             if (weakSelf.isBorderDetectionEnabled && rectangleDetectionConfidenceHighEnough(self->_imageDedectionConfidence)) {
                 CIRectangleFeature *rectangleFeature = [self biggestRectangleInRectangles:[[self highAccuracyRectangleDetector] featuresInImage:enhancedImage]];
                 self->_imageDedectionConfidence = 0;
                 if (rectangleFeature){
                     enhancedImage = [self correctPerspectiveForImage:enhancedImage withFeatures:rectangleFeature];
                 }
             }

             CIFilter *transform = [CIFilter filterWithName:@"CIAffineTransform"];
             [transform setValue:enhancedImage forKey:kCIInputImageKey];
             NSValue *rotation = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(-90 * (M_PI/180))];
             [transform setValue:rotation forKey:@"inputTransform"];
             enhancedImage = [transform outputImage];

             if (!enhancedImage || CGRectIsEmpty(enhancedImage.extent)) return;

             static CIContext *ctx = nil;
             if (!ctx) {
                 ctx = [CIContext contextWithOptions:@{kCIContextWorkingColorSpace:[NSNull null]}];
             }

             CGSize bounds = enhancedImage.extent.size;
             bounds = CGSizeMake(floorf(bounds.width / 4) * 4,floorf(bounds.height / 4) * 4);
             CGRect extent = CGRectMake(enhancedImage.extent.origin.x, enhancedImage.extent.origin.y, bounds.width, bounds.height);

             static int bytesPerPixel = 8;
             uint rowBytes = bytesPerPixel * bounds.width;
             uint totalBytes = rowBytes * bounds.height;
             uint8_t *byteBuffer = malloc(totalBytes);

             CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

             [ctx render:enhancedImage toBitmap:byteBuffer rowBytes:rowBytes bounds:extent format:kCIFormatRGBA8 colorSpace:colorSpace];

             CGContextRef bitmapContext = CGBitmapContextCreate(byteBuffer,bounds.width,bounds.height,bytesPerPixel,rowBytes,colorSpace,kCGImageAlphaNoneSkipLast);
             CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
             CGColorSpaceRelease(colorSpace);
             CGContextRelease(bitmapContext);
             free(byteBuffer);

             if (imgRef == NULL)
             {
                 CFRelease(imgRef);
                 return;
             }
             //saveCGImageAsJPEGToFilePath(imgRef, filePath);
             dispatch_async(dispatch_get_main_queue(), ^
             {
                //completionHandler(filePath);
                 //UIImage *oringImage = [UIImage imageWithCGImage:imgRef];
                 self->_photopImage = [UIImage imageWithCGImage:imgRef];
                 [self doPhoto];
                 CFRelease(imgRef);
                dispatch_resume(self->_captureQueue);
             });

             self->_imageDedectionConfidence = 0.0f;
         }
     }];
}

#pragma mark - UI
// 构造自定义相机
-(void)makeMyCapture {
    // 1.顶部视图
    [self creatCameraTopView];
    //2.相机可视区域
    [self creatCameraMiddleView];
    //3.创建相机下面自定义视图
    [self createCusphototV];
}

// 自定义相机可视区域
-(void)creatCameraMiddleView{
    
    self.session = [[AVCaptureSession alloc] init];
   
//    self.photoOutput = [[AVCapturePhotoOutput alloc] init];

    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    /*
     'isFlashModeSupported:' is deprecated: first deprecated in iOS 10.0 - Use AVCapturePhotoOutput's -supportedFlashModes instead.
     'setFlashMode:' is deprecated: first deprecated in iOS 10.0 - Use AVCapturePhotoSettings.flashMode instead.
     'isFlashModeSupported:' is deprecated: first deprecated in iOS 10.0 - Use AVCapturePhotoOutput's -supportedFlashModes instead.
     'setFlashMode:' is deprecated: first deprecated in iOS 10.0 - Use AVCapturePhotoSettings.flashMode instead.
     */
    
    if ([device isFlashModeSupported:AVCaptureFlashModeOff]) {
        [device setFlashMode:AVCaptureFlashModeOff];
    }
    
    [device unlockForConfiguration];
    
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    [self.session addInput:input];
    
    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [dataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)}];
    [dataOutput setSampleBufferDelegate:self queue:_captureQueue];
    [self.session addOutput:dataOutput];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    CGFloat kWidth = kFullScreenWidth;
    CGFloat kHeight = kMiddleViewHeight;
    NSDictionary * outputSettings = @{AVVideoWidthKey : @(kWidth),
    AVVideoHeightKey: @(kHeight),
    AVVideoCodecKey : AVVideoCodecJPEG,AVVideoScalingModeKey:AVVideoScalingModeResizeAspectFill};
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    AVCaptureConnection *connection = [dataOutput.connections firstObject];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    
//    NSDictionary *setDic = @{AVVideoWidthKey : @(kWidth),
//                             AVVideoHeightKey: @(kHeight)}; // AVVideoCodecKey : AVVideoCodecTypeJPEG,
//    AVCapturePhotoSettings *photoSett = [AVCapturePhotoSettings photoSettings];
//    [photoSett setPreviewPhotoFormat:setDic];
    
    
//    // 图片输出格式,如果支持使用HEIF(HEIC)那么使用,否则使用JPEG
//    NSDictionary *format = @{AVVideoCodecKey: AVVideoCodecTypeJPEG};
//    NSArray<AVVideoCodecType> *availablePhotoCodecTypes = self.photoOutput.availablePhotoCodecTypes;
//    if ([availablePhotoCodecTypes containsObject:AVVideoCodecTypeHEVC]) {
//        format = @{AVVideoCodecKey: AVVideoCodecTypeHEVC};
//    }
//    AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:format];
//    outputSettings.autoStillImageStabilizationEnabled = YES;//默认值就是yes
//    outputSettings.flashMode = AVCaptureFlashModeOff;//关闭闪光灯
//
//    // 预览图设置
//    id photoPixelFormatType = outputSettings.availablePreviewPhotoPixelFormatTypes.firstObject;
//    NSDictionary *preview =
//            @{
//                    (NSString *) kCVPixelBufferPixelFormatTypeKey: photoPixelFormatType,
//                    (NSString *) kCVPixelBufferWidthKey: @(kWidth),
//                    (NSString *) kCVPixelBufferHeightKey: @(kHeight)
//            };
//    outputSettings.previewPhotoFormat = preview;

    // 缩略图设置
//    id thumbnailPhotoCodecType = outputSettings.availableEmbeddedThumbnailPhotoCodecTypes.firstObject;
//    NSDictionary *thumbnail =
//            @{
//                    (NSString *) kCVPixelBufferPixelFormatTypeKey: thumbnailPhotoCodecType,
//                    (NSString *) kCVPixelBufferWidthKey: @(NBUAsset.thumbnailSize.width),
//                    (NSString *) kCVPixelBufferHeightKey: @(NBUAsset.thumbnailSize.height)
//            };
//    _outputSettings.embeddedThumbnailPhotoFormat = thumbnail;

    //[self.photoOutput setPhotoSettingsForSceneMonitoring:outputSettings];
    //[self.photoOutput capturePhotoWithSettings:outputSettings delegate:self];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
//    if ([self.session canAddOutput:self.photoOutput]) {
//        [self.session addOutput:self.photoOutput];
//    }
    
    [self.session commitConfiguration];
    
    //self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = CGRectMake(0,kTopViewHeight,kFullScreenWidth,kMiddleViewHeight);
    self.previewLayer.contentsScale = [UIScreen mainScreen].scale;
    self.previewLayer.backgroundColor = [[UIColor blackColor]CGColor];
    self.cameraContentView.layer.masksToBounds = YES;
    [self.cameraContentView.layer addSublayer:self.previewLayer];
    
    [self createGLKView];
    [self addGrid:_glkView.layer];

    self.enableBorderDetection = YES;
    
    UILabel *midLabel = [[UILabel alloc] init];
    [self.cameraContentView addSubview:midLabel];
    midLabel.text = manualPhotoTipString;
    midLabel.textColor = UIColorFromHex(COLOR_FFFFFF);
    midLabel.font = FONTBOLD(20);
    midLabel.numberOfLines = 0;
    midLabel.textAlignment = NSTextAlignmentCenter;
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.cameraContentView.mas_centerX);
        make.centerY.mas_equalTo(self.cameraContentView.mas_centerY).offset(-50);
        make.width.mas_equalTo(270);
    }];
    self.midLable = midLabel;
}

- (void)createGLKView{
    if (self.context) return;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *view = [[GLKView alloc] initWithFrame:CGRectMake(0,kTopViewHeight,kFullScreenWidth,kMiddleViewHeight)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.context = self.context;
    view.contentScaleFactor = 1.0f;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [self.cameraContentView addSubview:view];
    _glkView = view;
    _coreImageContext = [CIContext contextWithEAGLContext:self.context options:@{ kCIContextWorkingColorSpace : [NSNull null],kCIContextUseSoftwareRenderer : @(NO)}];
    self.cachedBounds = view.bounds;
}

// 自定义相机顶部页面
-(void)creatCameraTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth,kTopViewHeight)];
    topView.backgroundColor = UIColorFromHex(COLOR_000000);
    [self.cameraContentView addSubview:topView];
     //1.返回按钮
     UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [backBtn setImage:[UIImage imageNamed:@"白色_返回"] forState:UIControlStateNormal];
     [topView addSubview:backBtn];
     [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(topView.mas_left);
         make.centerY.mas_equalTo(topView.mas_centerY).offset(10);
         make.size.mas_equalTo(CGSizeMake(44, 44));
     }];
     [backBtn addTarget:self action:@selector(backBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
     _backBtn = backBtn;
    
    //2.闪光灯
    UIButton * flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashBtn setImage:[UIImage imageNamed:@"拍照_关闭闪光灯"] forState:UIControlStateNormal];
    [flashBtn setImage:[UIImage imageNamed:@"拍照_打开闪光灯"] forState:UIControlStateSelected];
    [flashBtn addTarget:self action:@selector(flashControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:flashBtn];
    [flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topView.mas_right).offset(-14);
        make.centerY.mas_equalTo(backBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    _flashBtn = flashBtn;
    
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"请尽量拍摄完整页面，以提高识别率噢";
    lable.textColor = UIColorFromHex(COLOR_FFFFFF);
    lable.font = FONTBOLD(15);
//    [topView addSubview:lable];
//    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(topView.mas_centerX);
//        make.centerY.mas_equalTo(backBtn.mas_centerY);
//    }];
    self.topLable = lable;
    self.topLable.hidden = YES;
}
    
-(void)setUpSubViews{
    if (@available(iOS 11.0, *)) {
        self.mainScroolView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //1.添加滚动视图为容器视图
    [self.view addSubview:self.mainScroolView];
    [self.mainScroolView addSubview:self.cameraContentView];
}

// 自定义相机底部页面
-(void)createCusphototV {
    CGFloat kWidth = kFullScreenWidth;
    CGFloat kHeight = kBottomViewHeight;
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0,kFullScreenHeight-kHeight,kWidth,kHeight)];
    _downView.backgroundColor = UIColorFromHex(COLOR_000000);
    [self.cameraContentView addSubview:_downView];
    _photoButotn = [[UIView alloc] init];
    [_photoButotn setupCorneradius:25];
    [_photoButotn setupborderWidth:2.f borderColor:UIColorFromHex(COLOR_FFFFFF)];
    [_downView addSubview:_photoButotn];
    [_photoButotn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_downView.mas_centerX);
        make.centerY.mas_equalTo(_downView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    UIView *redCircleView = [[UIView alloc] init];
    [_photoButotn addSubview:redCircleView];
    [redCircleView setupCorneradius:19.f];
    redCircleView.userInteractionEnabled = YES;
    redCircleView.backgroundColor = UIColorFromHex(0xC9D3F4);
    [redCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_photoButotn.mas_centerX);
        make.centerY.mas_equalTo(_photoButotn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePhotoButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:takePhotoButton];
    _takePhotoButton = takePhotoButton;
    [takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_photoButotn);
    }];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
//    singleFingerOne.numberOfTouchesRequired = 1; //手指数
//    singleFingerOne.numberOfTapsRequired = 1; //tap次数
//    [_photoButotn addGestureRecognizer:tap];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"拍照_选择相册"] forState:UIControlStateNormal];
    [_downView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_photoButotn.mas_centerY);
        make.left.mas_equalTo(_downView.mas_left).offset(36);
    }];
    [leftBtn addTarget:self action:@selector(selectAblum) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"自动" forState:UIControlStateNormal];
    [rightBtn setTitle:@"手动" forState:UIControlStateSelected];
    [rightBtn setImage:[UIImage imageNamed:@"拍照_自动"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromHex(COLOR_FFFFFF) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:FONTBOLD(15)];
    [_downView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_photoButotn.mas_centerY);
        make.right.mas_equalTo(_downView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(85, 31));
    }];
    [rightBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateSelected];
    [rightBtn setBackgroundColor:UIColorFromHex(COLOR_4B87EF) forState:UIControlStateNormal];
    [rightBtn setupCorneradius:15.5f];
    //rightBtn.hidden = self.homePageModel.homeworkDynamic.type == SSHomeworkHomePageStateCorrected ? NO : YES;
    self.btnCheckHomeworkDetail = rightBtn;
    [rightBtn layoutButtonWithEdgeInsetsStyle:SSButtonEdgeInsetsStyleLeft imageTitleSpace:4];
    [rightBtn addTarget:self action:@selector(switchAuto:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *btnSwitchAuto = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnSwitchAuto setTitle:@"查看作业详情" forState:UIControlStateNormal];
//    [btnSwitchAuto setTitleColor:UIColorFromHex(COLOR_FFFFFF) forState:UIControlStateNormal];
//    [btnSwitchAuto.titleLabel setFont:FONTBOLD(12)];
//    [_downView addSubview:btnSwitchAuto];
//    [btnSwitchAuto mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(_photoButotn.mas_centerY);
//        make.right.mas_equalTo(_downView.mas_right).offset(-15);
//        make.size.mas_equalTo(CGSizeMake(95, 34));
//    }];
    
    //4.提示切换
    [self.cameraContentView addSubview:self.tipSwitchImage];
    [self.tipSwitchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(rightBtn.mas_centerX);
        make.bottom.mas_equalTo(rightBtn.mas_top).offset(-5);
    }];
    self.tipSwitchImage.hidden = YES;
}

// 拍照后处理照片
-(void)doPhoto {
    [self stop];
    self.topLable.hidden = NO;
    self.midLable.hidden = YES;
    UIView *viewb = [[UIView alloc]init];
    viewb.frame = CGRectMake(0,kTopViewHeight, kFullScreenWidth,kFullScreenHeight-kTopViewHeight);
    viewb.backgroundColor = [UIColor clearColor];
    self.viewb = viewb;
    [self.cameraContentView addSubview:viewb];
    UIImageView *imagev = [[UIImageView alloc] init];
    imagev.backgroundColor = UIColorFromHex(COLOR_000000);
    imagev.contentMode = UIViewContentModeScaleAspectFit;
    imagev.frame = CGRectMake(0, 0,viewb.width,kMiddleViewHeight);
    imagev.image = _photopImage;
    //[self addGrid:imagev.layer];
    [viewb addSubview:imagev];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kMiddleViewHeight, viewb.width,viewb.height-kMiddleViewHeight)];
    bottomView.backgroundColor = UIColorFromHex(COLOR_000000);
    [viewb addSubview:bottomView];
    
    // 上传作业
    UIButton *centerBtn = [[UIButton alloc]init];
    [centerBtn setImage:[UIImage imageNamed:@"拍照_确定"] forState:UIControlStateNormal];
    centerBtn.tag = 1000;
    [centerBtn setupCorneradius:17.f];
    [centerBtn setBackgroundColor:UIColorFromHex(0x4AD2A4) forState:UIControlStateNormal];
    [bottomView addSubview:centerBtn];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80,34));
    }];
    centerBtn.hidden = YES;
    [centerBtn addTarget:self action:@selector(hitopbutton:) forControlEvents:UIControlEventTouchUpInside];

    // 重拍
    UIButton *leftbutton = [[UIButton alloc]init];
    [leftbutton setImage:[UIImage imageNamed:@"拍照_取消"] forState:UIControlStateNormal];
    leftbutton.tag = 1001;
    [leftbutton setupCorneradius:17.f];
    [leftbutton setBackgroundColor:UIColorFromHex(COLOR_FFFFFF) forState:UIControlStateNormal];
    [bottomView addSubview:leftbutton];
    [leftbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(centerBtn.mas_centerY);
        make.right.mas_equalTo(centerBtn.mas_left).offset(-20);
        make.width.mas_equalTo(centerBtn.mas_width);
        make.height.mas_equalTo(centerBtn.mas_height);
    }];
    [leftbutton addTarget:self action:@selector(hitopbutton:) forControlEvents:UIControlEventTouchUpInside];

    // 去批注
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setupCorneradius:17.f];
    rightBtn.tag = 1002;
    [rightBtn setTitle:@"标对错" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:FONTBOLD(12)];
    [rightBtn setTitleColor:UIColorFromHex(COLOR_FFFFFF) forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:UIColorFromHex(COLOR_4B87EF) forState:UIControlStateNormal];
    [bottomView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(centerBtn.mas_centerY);
        make.left.mas_equalTo(centerBtn.mas_right).offset(20);
        make.width.mas_equalTo(centerBtn.mas_width);
        make.height.mas_equalTo(centerBtn.mas_height);
    }];
    [rightBtn addTarget:self action:@selector(hitopbutton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - NSNotificationCenter

/**屏幕旋转的通知回调*/
- (void)orientChange:(NSNotification *)noti {
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    CGAffineTransform currentTransform = CGAffineTransformIdentity;
    switch (orient) {
        case UIDeviceOrientationPortrait:
            SSLog(@"竖直屏幕");
            currentTransform = CGAffineTransformRotate(currentTransform,0);
            self.midLable.transform = currentTransform;
            break;
        case UIDeviceOrientationLandscapeLeft:
            SSLog(@"手机左转");
            currentTransform = CGAffineTransformRotate(currentTransform,M_PI_2);
            self.midLable.transform = currentTransform;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            SSLog(@"手机竖直");
            currentTransform = CGAffineTransformRotate(currentTransform,M_PI);
            self.midLable.transform = currentTransform;
            break;
        case UIDeviceOrientationLandscapeRight:
            SSLog(@"手机右转");
            currentTransform = CGAffineTransformRotate(currentTransform,-M_PI_2);
            self.midLable.transform = currentTransform;
            break;
        case UIDeviceOrientationUnknown:
            currentTransform = CGAffineTransformRotate(currentTransform,0);
            self.midLable.transform = currentTransform;
            SSLog(@"未知");
            break;
        case UIDeviceOrientationFaceUp:
            SSLog(@"手机屏幕朝上");
            currentTransform = CGAffineTransformRotate(currentTransform,0);
            self.midLable.transform = currentTransform;
            break;
        case UIDeviceOrientationFaceDown:
            SSLog(@"手机屏幕朝下");
            currentTransform = CGAffineTransformRotate(currentTransform,0);
            self.midLable.transform = currentTransform;
            break;
        default:
            break;
    }
}

#pragma mark - Lazy Load

- (CGSize)intrinsicContentSize
{
    if(_intrinsicContentSize.width == 0 || _intrinsicContentSize.height == 0) {
        return CGSizeMake(1, 1); //just enough so rendering doesn't crash
    }
    return _intrinsicContentSize;
}

-(UIImageView *)tipSwitchImage{
    if (!_tipSwitchImage) {
        _tipSwitchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"拍照_提示切换手动"]];
    }
    return _tipSwitchImage;
}

-(UIView *)cameraContentView {
    if (!_cameraContentView) {
        _cameraContentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kFullScreenWidth,self.mainScroolView.height)];
        _cameraContentView.backgroundColor = [UIColor clearColor];
    }
    return _cameraContentView;
}

-(UIScrollView *)mainScroolView{
    if (!_mainScroolView) {
        _mainScroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,kFullScreenWidth,kFullScreenHeight)];
        _mainScroolView.contentSize = CGSizeMake(kFullScreenWidth*2, 0);
        _mainScroolView.pagingEnabled = YES;
        _mainScroolView.delegate = self;
        _mainScroolView.scrollEnabled = NO;
        _mainScroolView.showsVerticalScrollIndicator = NO;
        _mainScroolView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScroolView;
}

- (CIDetector *)rectangleDetetor
{
    static CIDetector *detector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
          detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyLow,CIDetectorTracking : @(YES)}];
    });
    return detector;
}

- (CIDetector *)highAccuracyRectangleDetector {
    static CIDetector *detector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    });
    return detector;
}

- (CIRectangleFeature *)_biggestRectangleInRectangles:(NSArray *)rectangles {
    
    if (![rectangles count]) return nil;
    
    float halfPerimiterValue = 0;
    
    CIRectangleFeature *biggestRectangle = [rectangles firstObject];
    
    for (CIRectangleFeature *rect in rectangles)
    {
        CGPoint p1 = rect.topLeft;
        CGPoint p2 = rect.topRight;
        CGFloat width = hypotf(p1.x - p2.x, p1.y - p2.y);
        
        CGPoint p3 = rect.topLeft;
        CGPoint p4 = rect.bottomLeft;
        CGFloat height = hypotf(p3.x - p4.x, p3.y - p4.y);
        
        CGFloat currentHalfPerimiterValue = height + width;
        
        if (halfPerimiterValue < currentHalfPerimiterValue)
        {
            halfPerimiterValue = currentHalfPerimiterValue;
            biggestRectangle = rect;
        }
    }
    
    return biggestRectangle;
}

- (CIRectangleFeature *)biggestRectangleInRectangles:(NSArray *)rectangles {
    
    CIRectangleFeature *rectangleFeature = [self _biggestRectangleInRectangles:rectangles];
    
    if (!rectangleFeature) return nil;
    
    // Credit: http://stackoverflow.com/a/20399468/1091044
    
    NSArray *points = @[[NSValue valueWithCGPoint:rectangleFeature.topLeft],[NSValue valueWithCGPoint:rectangleFeature.topRight],[NSValue valueWithCGPoint:rectangleFeature.bottomLeft],[NSValue valueWithCGPoint:rectangleFeature.bottomRight]];
    
    CGPoint min = [points[0] CGPointValue];
    CGPoint max = min;
    for (NSValue *value in points)
    {
        CGPoint point = [value CGPointValue];
        min.x = fminf(point.x, min.x);
        min.y = fminf(point.y, min.y);
        max.x = fmaxf(point.x, max.x);
        max.y = fmaxf(point.y, max.y);
    }
    
    CGPoint center =
    {
        0.5f * (min.x + max.x),
        0.5f * (min.y + max.y),
    };
    
    NSNumber *(^angleFromPoint)(id) = ^(NSValue *value)
    {
        CGPoint point = [value CGPointValue];
        CGFloat theta = atan2f(point.y - center.y, point.x - center.x);
        CGFloat angle = fmodf(M_PI - M_PI_4 + theta, 2 * M_PI);
        return @(angle);
    };
    
    NSArray *sortedPoints = [points sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
    {
        return [angleFromPoint(a) compare:angleFromPoint(b)];
    }];
    
    IPDFRectangleFeature *rectangleFeatureMutable = [IPDFRectangleFeature new];
    rectangleFeatureMutable.topLeft = [sortedPoints[3] CGPointValue];
    rectangleFeatureMutable.topRight = [sortedPoints[2] CGPointValue];
    rectangleFeatureMutable.bottomRight = [sortedPoints[1] CGPointValue];
    rectangleFeatureMutable.bottomLeft = [sortedPoints[0] CGPointValue];
    
    return (id)rectangleFeatureMutable;
}

BOOL rectangleDetectionConfidenceHighEnough(float confidence) {
    return (confidence == 30.0);
}

#pragma mark - UIStatusBarStyle

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
