//
//  OYCameraViewController.h
//  AutomaticCaptureCamera
//
//  Created by 欧阳荣 on 2022/6/16.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


NS_ASSUME_NONNULL_BEGIN

// 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。

typedef void(^UploadHomeworkPictureSuccessBlock)(id sender);

@interface OYCameraViewController : UIViewController

@property (nonatomic, copy) UploadHomeworkPictureSuccessBlock uploadSuccess; // 上传作业 回调

@property (nonatomic, strong) AVCaptureSession* session;
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;

// 'AVCaptureStillImageOutput' is deprecated: first deprecated in iOS 10.0 - Use AVCapturePhotoOutput instead.

@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;

//@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic, strong) AVCapturePhotoOutput *imageOutput;

@end

NS_ASSUME_NONNULL_END
