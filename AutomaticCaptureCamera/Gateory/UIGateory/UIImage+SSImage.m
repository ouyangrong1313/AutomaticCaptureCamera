//  UIImage+SSImage.h
//  Created by 刘辉 on 2018/2/6.
//  Copyright © 2018年 私塾家. All rights reserved.

#import "UIImage+SSImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

#define ASSETS_GROUP_PROPERTYNAME @"私塾家"

#define ORIGINAL_MAX_WIDTH 640
#define LEN_100 100 * 1000.0
#define LEN_150 150 * 1000.0
#define LEN_300 300 * 1000.0
#define LEN_500 500 * 1000.0

@implementation UIImage (SSImage)

/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


/**
 *  保存图片到指定相簿的文件夹中
 *
 *  @param metadata        <#metadata description#>
 *  @param imageData       图片对象
 *  @param customAlbumName 相册名
 *  @param completionBlock 成功回调
 *  @param failureBlock    失败回调
 */
- (void)saveToAlbumWithMetadata:(NSDictionary*)metadata
                      imageData:(NSData*)imageData
                customAlbumName:(NSString*)customAlbumName
                completionBlock:(void(^)(void))completionBlock
                   failureBlock:(void(^)(NSError*error))failureBlock
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    //接下来是疯狂的 block
    void(^AddAsset)(ALAssetsLibrary *, NSURL*) = ^(ALAssetsLibrary *assetsLibrary, NSURL*assetURL) {
        //1 遍历 AssetsLibrary 整个相册库
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            //2 遍历 ALAssetsGroup 相册库中文件夹
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL*stop) {
                //3 找到 customAlbumName 对应的相册库文件夹
                if (group) {
                    if([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                        [group addAsset:asset];
                        if(completionBlock) {
                            completionBlock();
                        }
                    }
                }else{
                    
                }
                
            } failureBlock:^(NSError*error) {
                if(failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError*error) {
            if(failureBlock) {
                failureBlock(error);
            }
        }];
    };
    ALAssetsLibrary *weakLibrary = assetsLibrary ;
    //把照片写入相册
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL*assetURL, NSError*error) {
        if(customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if(group) {
                    [weakLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if(completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError*error) {
                        if(failureBlock) {
                            failureBlock(error);
                        }
                    }];
                }else{
                    AddAsset(weakLibrary, assetURL);
                }
            } failureBlock:^(NSError*error) {
                AddAsset(weakLibrary, assetURL);
            }];
        }else{
            if(completionBlock) {
                completionBlock();
            }
        }
    }];
    
}
/**
 *  保存图片到相簿
 *
 *  @param image  图片对象
 *  @param photoName 相册名  不传为默认  友门鹿
 */
- (void)saveImage:(UIImage*)image photoName:(NSString *)photoName{
    
    NSString *tempPhotoName = @"" ;
    if (photoName.length == 0 ) {
        tempPhotoName = ASSETS_GROUP_PROPERTYNAME ;
    }else{
        tempPhotoName = photoName ;
    }
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    
    ALAssetsLibraryAccessFailureBlock failureblock =
    ^(NSError *myerror)
    {
        
        if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
            
        }else{
            
        }
    };
    
    
    NSMutableArray*groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL*stop)
    {
        
        // 把相册名保存到数组中
        if(group)
        {
            [groups addObject:group];
        }
        else
        {
            BOOL haveHDRGroup = NO;
            //遍历整个数组 判断相簿中有没存在相同的相册名
            for(ALAssetsGroup *gp in groups)
            {
                NSString*name =[gp valueForProperty:ALAssetsGroupPropertyName];
                
                if([name isEqualToString:tempPhotoName])
                {
                    haveHDRGroup = YES;
                }
            }
            //相簿中没有该相册名  创建相册文件夹
            if(!haveHDRGroup)
            {
                //ios8.0 之后的创建相册文件夹的方法
                if (iOS8UP) {
                    PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary] ;
                    [photoLibrary performChanges:^{
                        
                        
                        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:tempPhotoName];
                        
                    } completionHandler:^(BOOL success, NSError *error) {
                        
                    }];
                }else{
                    //ios8.0 之前的创建相册文件夹的方法
                    [assetsLibrary addAssetsGroupAlbumWithName:tempPhotoName
                                                   resultBlock:^(ALAssetsGroup *group)
                     {
                         if (group) {
                             [groups addObject:group];
                         }else{
                             
                         }
                         
                         
                     }
                                                  failureBlock:nil];
                }
                
                
                haveHDRGroup = YES;
            }
        }
        
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:failureblock];
    
    
    
    //
    UIImageJPEGRepresentation(image,1) ;
    //图片保存到相簿中
    [self saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(image) customAlbumName:tempPhotoName completionBlock:^
     {
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"保存成功"
                                                     delegate:nil
                                            cancelButtonTitle:@"知道了"
                                            otherButtonTitles: nil];
         dispatch_async(dispatch_get_main_queue(), ^{
             [alert show];
         });
         
     } failureBlock:^(NSError*error)
     {
         if ([self isAuthorizationStatusTypePhotoLibrary:NO]) {
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示"
                                                          message:@"保存失败"
                                                         delegate:nil
                                                cancelButtonTitle:@"知道了"
                                                otherButtonTitles:nil];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [alert show];
             });
         }
         //面这个方法可判断是否是因为用户拒绝访问地址所致，如果是中文环境返回 的是“用户拒绝访问”
         //         if (([error.localizedDescription rangeOfString:@"User denied access"].location!=NSNotFound )|| （[myerror.localizedDescription rangeOfString:@"用户拒绝访问"].location!= NSNotFound))
     }];
}

- (BOOL)isAuthorizationStatusTypePhotoLibrary:(BOOL)isAlert{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
    {
        if (isAlert) {
            //无权限
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示"
                                                         message:@"您没开启照片功能 请在设置->隐私->照片->友门鹿 设置为打开状态"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert show];
            });
        }
        return NO;
    }
    return YES;
}

/**
 *  根据颜色值改变图片的颜色
 *
 *  @param tintColor 颜色值
 *  @param blendMode 、
 *  @param alpha     透明度
 *
 *  @return 图片对象
 */

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:alpha];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

/**
 *  根据颜色值 设置圆角 生成图片
 */
+ (UIImage *)imageColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(0, 0, cornerRadius * 2 , cornerRadius * 2 );
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    path.lineWidth = 0;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    [path fill];
    [path stroke];
    [path addClip];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  设置颜色的图片  设置大小
 *
 *  @param color <#color description#>
 *  @param size  <#size description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        
        return img;
        
    }
}

+ (UIImage *)resizeImage:(NSString *)imageName viewframe:(CGRect)viewframe resizeframe:(CGRect)sizeframe
{
    UIGraphicsBeginImageContext(viewframe.size);
    [[UIImage imageNamed:imageName] drawInRect:sizeframe];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  把图片缩小到最大宽度为640
 *
 *  @return
 */
- (UIImage *)imageByScalingToMaxSize {
    if (self.size.width < ORIGINAL_MAX_WIDTH) return self;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (self.size.width > self.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = self.size.width * (ORIGINAL_MAX_WIDTH / self.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = self.size.height * (ORIGINAL_MAX_WIDTH / self.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingToTargetSize:targetSize];
}

/**
 *  把图片缩放到指定大小
 *
 *  @param targetSize
 *
 *  @return
 */
- (UIImage *)imageByScalingAndCroppingToTargetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  图片处理  压缩
 */
+ (NSArray *)disposeImagesWithArray:(NSArray *)imageArray
{
    NSMutableArray *fileDataMArray = [NSMutableArray array];
    
    for (UIImage *image in imageArray) {
        CGFloat quality = [self compressionQuality:image];
        UIImage *newImage = nil;
        NSMutableDictionary *fileDataMDictionary = [NSMutableDictionary dictionary];
        
        if (quality < 0.4) {
            CGSize size = CGSizeMake(800, 800 * (image.size.height/image.size.width));
            newImage = [self scaleToSize:image size:size];
        }
        else {
            newImage = image;
        }
        
        NSData *imageData = [self compressedData:quality image:newImage];
        BOOL isJPG = NO;
        if (imageData) {
            
            isJPG = YES;
        } else {
            isJPG = NO;
            imageData = UIImagePNGRepresentation(image);
            
        }
        if (!imageData) {
            
        }
        [fileDataMDictionary setObject:[NSNumber numberWithBool:isJPG] forKey:kJpgKey];
        if (imageData) {
            [fileDataMDictionary setObject:imageData forKey:kImageDataKey];
        }
        
        
        [fileDataMArray addObject:[fileDataMDictionary copy]];
    }
    return [fileDataMArray copy];
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
+ (NSData *)compressedData:(CGFloat)compressionQuality image:(UIImage *)image
{
    assert(compressionQuality <= 1.0 && compressionQuality >= 0);
    return UIImageJPEGRepresentation(image, compressionQuality);
}

+ (CGFloat)compressionQuality:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    if (!data) {
        data = UIImagePNGRepresentation(image);
    }
    
    NSUInteger dataLength = [data length];
    
    if(dataLength > LEN_100) {
        if (dataLength > LEN_500) {
            return 0.3;
        } else if (dataLength > LEN_300) {
            return  0.45;
        } else if (dataLength > LEN_150){
            return  0.65;
        } else {
            return 0.9;
        }
    } else {
        return 1.0;
    }
}

- (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius {
    
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:self withContentMode:UIViewContentModeScaleAspectFill];
}

- (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius withContentMode:(UIViewContentMode)contentMode {
    
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:self withContentMode:contentMode];
}

+ (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit CornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil withContentMode:UIViewContentModeScaleToFill];
}

+ (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius andColor:(UIColor *)color {
    
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:nil borderWidth:0 backgroundColor:color backgroundImage:nil withContentMode:UIViewContentModeScaleToFill];
}

+ (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit CornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode {
    
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit JMRadius:JMRadiusMake(radius, radius, radius, radius) borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage withContentMode:contentMode];
}

+ (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit JMRadius:(JMRadius)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode {
    
    if (backgroundImage) {
        backgroundImage = [backgroundImage scaleToSize:CGSizeMake(sizeToFit.width, sizeToFit.height) withContentMode:contentMode backgroundColor:backgroundColor];
        backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    } else if (!backgroundColor){
        backgroundColor = [UIColor whiteColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);

    CGFloat halfBorderWidth = borderWidth / 2;
    //设置上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //边框大小
    CGContextSetLineWidth(context, borderWidth);
    //边框颜色
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    //矩形填充颜色
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGFloat height = sizeToFit.height;
    CGFloat width = sizeToFit.width;
    
    CGContextMoveToPoint(context, width - halfBorderWidth, radius.topRightRadius + halfBorderWidth);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius.bottomRightRadius  - halfBorderWidth, height - halfBorderWidth, radius.bottomRightRadius);  // 右下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius.bottomLeftRadius - halfBorderWidth, radius.bottomLeftRadius); // 左下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius.topLeftRadius); // 左上角
    CGContextAddArcToPoint(context, width , halfBorderWidth, width - halfBorderWidth, radius.topRightRadius + halfBorderWidth, radius.topRightRadius); // 右上角
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImage;
}

- (UIImage *)scaleToSize:(CGSize)size withContentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    if (backgroundColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    }
    [self drawInRect:[self convertRect:CGRectMake(0.0f, 0.0f, size.width, size.height) withContentMode:contentMode]];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
    
    if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
        if (contentMode == UIViewContentModeLeft) {
            return CGRectMake(rect.origin.x,
                              rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeRight) {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeTop) {
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                              rect.origin.y,
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeBottom) {
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                              rect.origin.y + floor(rect.size.height - self.size.height),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeCenter) {
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                              rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeBottomLeft) {
            return CGRectMake(rect.origin.x,
                              rect.origin.y + floor(rect.size.height - self.size.height),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeBottomRight) {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y + (rect.size.height - self.size.height),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeTopLeft) {
            return CGRectMake(rect.origin.x,
                              rect.origin.y,
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeTopRight) {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y,
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeScaleAspectFill) {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;
            } else {
                imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;
            }
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                              rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                              imageSize.width, imageSize.height);
        } else if (contentMode == UIViewContentModeScaleAspectFit) {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;
            } else {
                imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;
            }
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                              rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                              imageSize.width, imageSize.height);
        }
    }
    return rect;
}

+ (UIImage *)triangleImageWithSize:(CGSize)size tintColor:(UIColor *)tintColor{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(size.width/2, 0)];
    [path addLineToPoint:CGPointMake(0,size.height)];
    [path addLineToPoint:CGPointMake(size.width,size.height)];
    [path closePath];
    CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
    [path fill];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return resultImage;
}


+ (UIImage *)shotWithView:(UIView *)view withViewFrame:(CGRect)viewFrame{
    CGSize s = view.bounds.size;

    //下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(s,NO,3.0);

    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}
@end
