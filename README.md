# AutomaticCaptureCamera
自定义相机，自动捕获拍照，识别作业图片。


# 需求分析

自定义一个相机，要支持手动拍照，以及自动捕获作业拍照。


# 实现方法

## 创建相机

```
    self.session = [[AVCaptureSession alloc] init];
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
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = CGRectMake(0,kTopViewHeight,kFullScreenWidth,kMiddleViewHeight);
    self.previewLayer.contentsScale = [UIScreen mainScreen].scale;
    self.previewLayer.backgroundColor = [[UIColor blackColor]CGColor];
    self.cameraContentView.layer.masksToBounds = YES;
    [self.cameraContentView.layer addSublayer:self.previewLayer];
```

## 手动拍照

```
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
```

## 自动拍照

```
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
```


# 参考文章

[AVFoundation篇 - 苏沫离](https://www.jianshu.com/nb/29832666)

[AVFoundation - Seacen_Liu](https://www.jianshu.com/nb/36006736)

[人脸框检测 - 会飞的大马猴](https://www.jianshu.com/p/5545e1c224ab)
