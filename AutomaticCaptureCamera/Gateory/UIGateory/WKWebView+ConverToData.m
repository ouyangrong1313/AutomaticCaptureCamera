//  WKWebView+ConverToData.m
//  私塾家
//  Created by 刘辉 on 2020/6/24.
//  Copyright © 2020 Liew. All rights reserved.

#import "WKWebView+ConverToData.h"
#import "UIPrintPageRenderer+PDF.h"
#import "SSPublicHeader.h"
#import "UIView+SSView.h"

@implementation WKWebView (ConverToData)

- (NSData *)converToPDF {
    UIViewPrintFormatter *fmt = [self viewPrintFormatter];
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:fmt startingAtPageAtIndex:0];           CGRect page;
    page.origin.x = 0;
    page.origin.y = 0;
    page.size.width = 600;
    page.size.height = 768;
    
    CGRect printable = CGRectInset(page, 0, 0 );
    [render setValue:[NSValue valueWithCGRect:page] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printable] forKey:@"printableRect"];
    
    NSMutableData * pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    
    for (NSInteger i=0; i < [render numberOfPages]; i++) {
        UIGraphicsBeginPDFPage();
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        [render drawPageAtIndex:i inRect:bounds];
    }
    UIGraphicsEndPDFContext();
    return pdfData;
}

-(NSData *)PDFData{
    UIViewPrintFormatter *fmt = [self viewPrintFormatter];
    SSLog(@"UIViewPrintFormatter:%@",NSStringFromCGRect(fmt.view.frame));
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:fmt startingAtPageAtIndex:0];
    CGRect page;
    page.origin.x = 0;
    page.origin.y = 0;
    page.size.width = 595;  //375
    page.size.height = 842; //603
    CGRect printable = CGRectInset(page,0,0);
    [render setValue:[NSValue valueWithCGRect:page] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printable] forKey:@"printableRect"];
    
    NSData *pdfData = [render printToPDF];
    return pdfData;
    
    
//    NSMutableData * pdfData = [NSMutableData data];
//    UIGraphicsBeginPDFContextToData(pdfData,CGRectZero,nil);
//    for (NSInteger i=0; i < [render numberOfPages]; i++){
//        UIGraphicsBeginPDFPage();
//        CGRect bounds = UIGraphicsGetPDFContextBounds();
//        [render drawPageAtIndex:i inRect:bounds];
//    }
//    UIGraphicsEndPDFContext();
//    return pdfData;
//
}

- (NSData *)converPictureToPDF {
    UIViewPrintFormatter *fmt = [self viewPrintFormatter];
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:fmt startingAtPageAtIndex:0];
    CGRect page;
    page.origin.x = 0;
    page.origin.y = 0;
    page.size.width = 600;
    page.size.height = 848;
    
    CGRect printable = CGRectInset(page,0,0);
    [render setValue:[NSValue valueWithCGRect:page] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printable] forKey:@"printableRect"];
    
    NSMutableData * pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );
    
    for (NSInteger i=0; i < [render numberOfPages]; i++) {
        UIGraphicsBeginPDFPage();
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        [render drawPageAtIndex:i inRect:bounds];
    }
    UIGraphicsEndPDFContext();
    return pdfData;
}


-(NSData*)converWebViewToPDF{
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:self.viewPrintFormatter startingAtPageAtIndex:0];//关联对象
    NSUInteger contentHeight = self.scrollView.contentSize.height;
    NSUInteger contentWidth = self.scrollView.contentSize.width;
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    
   //需要打印的frame
   CGRect printableRect = CGRectMake(0, 0,contentSize.width,contentSize.height);
   CGRect paperRect = CGRectMake(0, 0,contentSize.width,[self getPageHeight]);
   [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"]; //因为是readonly属性，所以我们只能用KVC 进行赋值
   [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
   NSData *pdfData = [render printToPDF];
   return pdfData;
   //NSString *fileUrl = [NSString stringWithFormat:@"%@temp.pdf",NSTemporaryDirectory()];
   //[pdfData writeToFile:fileUrl atomically: YES];
}

-(CGFloat)getPageHeight{
    CGFloat pageHeight = 600;
    NSArray* a = [self.scrollView subviews];
    for (UIView* view in a) {
        if ([view isKindOfClass:NSClassFromString(@"UIWebPDFView")]) {
            NSArray* b = view.subviews;
            for (int i =0;i<b.count;i++) {
                UIView* subView = b[i];
                if ([subView isKindOfClass:NSClassFromString(@"UIPDFPageView")]) {
                    pageHeight = subView.height;
                    SSLog(@"UIPDFPageView.frame == %@",NSStringFromCGRect(subView.frame));
                }
            }
        }
    }
    return pageHeight;
    /*
    CGFloat content_hetght = self.scrollView.contentSize.height;
    NSInteger content_num = [self getTotalPDFPages];
    CGFloat page_height =  content_hetght / content_num;
    return page_height;
     */
}

-(NSInteger)getTotalPDFPages{
    NSArray* a = [self.scrollView subviews];
    NSInteger pages = 0;
    for (UIView* view in a) {
        if ([view isKindOfClass:NSClassFromString(@"UIWebPDFView")]) {
            NSArray* b = view.subviews;
            for (int i =0;i<b.count;i++) {
                UIView* subView = b[i];
                if ([subView isKindOfClass:NSClassFromString(@"UIPDFPageView")]) {
                    pages++;
                }
            }
        }
    }
    return pages;
}


@end
