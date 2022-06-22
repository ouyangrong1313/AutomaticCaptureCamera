//
//  UIPrintPageRenderer+PDF.m
//  私塾家
//
//  Created by 刘辉 on 2020/4/24.
//  Copyright © 2020 Liew. All rights reserved.
//

#import "UIPrintPageRenderer+PDF.h"

@implementation UIPrintPageRenderer (PDF)

- (NSData*) printToPDF {
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    for ( int i = 0 ; i < self.numberOfPages ; i++ ) {
        UIGraphicsBeginPDFPage();
        [self drawPageAtIndex: i inRect: bounds];
    }
    UIGraphicsEndPDFContext();
    return pdfData;
}

@end
