//
//  WKWebView+ConverToData.h
//  私塾家
//
//  Created by 刘辉 on 2020/6/24.
//  Copyright © 2020 Liew. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (ConverToData)

-(NSData *)converToPDF;

-(NSData *)converPictureToPDF;

-(NSData*)converWebViewToPDF;

-(NSData *)PDFData;

@end

NS_ASSUME_NONNULL_END
